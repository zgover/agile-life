//
//  HomeScreenViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/11/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

private let HomeScreenCellIdentfier = "HomeScreenTableViewCell"
private let HomeScreenHeaderIdentifier = "HomeScreenTableViewHeader"
private let HomeScreenFooterIdentifier = "HomeScreenTableViewFooter"

class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /* ==========================================
    *
    * MARK: Outlet Connections
    *
    * =========================================== */
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    /* ==========================================
    *
    * MARK: Global Variables
    *
    * =========================================== */
    
    var directToCreateBoard = false
    var CoreModels = CoreDataModels()
    var selectedStory:Int!
    var storyCount:[Int] = []
    
    /* ==========================================
    *
    * MARK: Default Methods
    *
    * =========================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setDefualtNav(menuBtn, statusBg: true, bg: true)
        CoreModels.fetchAll()
        
        // Set default values
        
        // Register cell identifier
        tableView.registerNib(
            UINib(nibName: HomeScreenCellIdentfier, bundle: nil),
            forCellReuseIdentifier: HomeScreenCellIdentfier
        )
        
        // Register header identifier
        tableView.registerNib(
            UINib(nibName: HomeScreenHeaderIdentifier, bundle: nil),
            forHeaderFooterViewReuseIdentifier: HomeScreenHeaderIdentifier
        )
        
        // Register footer identifier
        tableView.registerNib(
            UINib(nibName: HomeScreenFooterIdentifier, bundle: nil),
            forCellReuseIdentifier: HomeScreenFooterIdentifier
        )
        
        //CoreModels.createBoard("School Board", stage_one_icon: "hourglass", stage_one_name: "Backlog", stage_two: nil, stage_two_icon: nil, stage_two_name: nil, stage_three: nil, stage_three_icon: nil, stage_three_name: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if directToCreateBoard == true {
            performSegueWithIdentifier("createBoardSegue", sender: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        CoreModels.fetchAll()
        tableView.reloadData()
    }
    
    /* ==========================================
    *
    * MARK: Tableview Delegate Methods
    *
    * =========================================== */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let count = CoreModels.allBoards?.count {
            return count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let boards = CoreModels.allBoards {
            let storyCount = boards[section].story_lists!.count
            let returnCount = storyCount > 3 ? 3 : storyCount
            self.storyCount.append(returnCount)
            
            return returnCount <= 0 ? 1 : returnCount + 1
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 52
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(HomeScreenCellIdentfier) as? HomeScreenTableViewCell where indexPath.row != 3 && CoreModels.allBoards![indexPath.section].story_lists!.count > 0 {
            
            //CoreModels.fetchStories(nil, _board: CoreModels.allBoards![indexPath.section])
            
            let subtaskCount = CoreModels.allStories?[indexPath.row].sub_tasks?.count
            let totalComplete = CoreModels.subtaskCompletion(indexPath.row)
            
            cell.storyName.text = CoreModels.allStories![indexPath.row].name
            cell.subtaskCount.text = "\(subtaskCount == nil ? 0 : subtaskCount!) Sub-tasks"
            cell.percentageComplete.text = "\(Int(totalComplete * 100))% Complete"
            cell.progressBar.setProgress(totalComplete, animated: true)
            
            return cell
            
        } else if let cell = tableView.dequeueReusableCellWithIdentifier(HomeScreenFooterIdentifier) as? HomeScreenTableViewFooter where indexPath.row <= 3 {
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HomeScreenHeaderIdentifier) as! HomeScreenTableViewHeader
        header.boardName.text = CoreModels.allBoards![section].name
        return header
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != 3 && CoreModels.allBoards![indexPath.section].story_lists!.count > 0 {
            
            CoreModels.currentBoard = CoreModels.allBoards![indexPath.section]
            CoreModels.fetchStories(nil, _board: CoreModels.currentBoard)
            CoreModels.currentStory = CoreModels.allStories?[indexPath.row]
            selectedStory = indexPath.row
            self.performSegueWithIdentifier("storyDetailSegue", sender: nil)
            
        } else if indexPath.row <= 3 {
            if let currentBoard = CoreModels.allBoards?[indexPath.section] {
                CoreModels.currentBoard = currentBoard
                self.performSegueWithIdentifier("boardDetailSegue", sender: nil)
            }
        }
    }
    
    /* ==========================================
    *
    * MARK: Custom Delegates
    *
    * =========================================== */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? StoryDetailViewController {
            destination.selectedStory = self.selectedStory
            destination.CoreModels = self.CoreModels
        } else if let destination = segue.destinationViewController as? StoryListViewController {
            destination.CoreModels = self.CoreModels
        }
    }

    /* ==========================================
    *
    * MARK: Segue Methods
    *
    * =========================================== */
    
    @IBAction func addBoard(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("createBoardSegue", sender: sender)
    }
    
    func viewAllStories() {
        
    }

    
    /* ==========================================
    *
    * MARK: Custom Delegates
    *
    * =========================================== */
    
    func updateData() {
        CoreModels.fetchBoards()
        tableView.reloadData()
    }
}

