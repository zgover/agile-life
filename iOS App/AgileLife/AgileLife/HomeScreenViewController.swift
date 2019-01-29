//
//  HomeScreenViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/11/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit
import Crashlytics

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
        tableView.register(
            UINib(nibName: HomeScreenCellIdentfier, bundle: nil),
            forCellReuseIdentifier: HomeScreenCellIdentfier
        )
        
        // Register header identifier
        tableView.register(
            UINib(nibName: HomeScreenHeaderIdentifier, bundle: nil),
            forHeaderFooterViewReuseIdentifier: HomeScreenHeaderIdentifier
        )
        
        // Register footer identifier
        tableView.register(
            UINib(nibName: HomeScreenFooterIdentifier, bundle: nil),
            forCellReuseIdentifier: HomeScreenFooterIdentifier
        )
            
        //CoreModels.createBoard("School Board", stage_one_icon: "hourglass", stage_one_name: "Backlog", stage_two: nil, stage_two_icon: nil, stage_two_name: nil, stage_three: nil, stage_three_icon: nil, stage_three_name: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if directToCreateBoard == true {
            performSegue(withIdentifier: "createBoardSegue", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CoreModels.fetchAll()
        tableView.reloadData()
    }
    
    /* ==========================================
    *
    * MARK: Tableview Delegate Methods
    *
    * =========================================== */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let count = CoreModels.allBoards?.count {
            return count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let boards = CoreModels.allBoards {
            let storyCount = boards[section].story_lists!.count
            var returnCount = storyCount > 3 ? 3 : storyCount
            self.storyCount.append(returnCount)
            returnCount = returnCount <= 0 ? 1 : returnCount + 1
            return returnCount
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: HomeScreenCellIdentfier) as? HomeScreenTableViewCell, indexPath.row != 3 && indexPath.row < CoreModels.allBoards![indexPath.section].story_lists!.count && CoreModels.allBoards![indexPath.section].story_lists!.count > 0 {
            
            CoreModels.fetchStories(nil, _board: CoreModels.allBoards![indexPath.section])
            
            let subtaskCount = CoreModels.allStories?[indexPath.row].sub_tasks?.count
            let totalComplete = CoreModels.subtaskCompletion(indexPath.row)
            
            cell.storyName.text = CoreModels.allStories![indexPath.row].name
            cell.subtaskCount.text = "\(subtaskCount == nil ? 0 : subtaskCount!) Sub-tasks"
            cell.percentageComplete.text = "\(Int(totalComplete * 100))% Complete"
            cell.progressBar.setProgress(totalComplete, animated: true)
            
            return cell
            
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: HomeScreenFooterIdentifier) as? HomeScreenTableViewFooter, indexPath.row <= 3 {
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeScreenHeaderIdentifier) as! HomeScreenTableViewHeader
        header.boardName.text = CoreModels.allBoards![section].name
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 3 && indexPath.row < CoreModels.allBoards![indexPath.section].story_lists!.count && CoreModels.allBoards![indexPath.section].story_lists!.count > 0 {
            
            CoreModels.currentBoard = CoreModels.allBoards![indexPath.section]
            CoreModels.fetchStories(nil, _board: CoreModels.currentBoard)
            CoreModels.currentStory = CoreModels.allStories?[indexPath.row]
            selectedStory = indexPath.row
            self.performSegue(withIdentifier: "storyDetailSegue", sender: nil)
            
        } else if indexPath.row <= 3 {
            if let currentBoard = CoreModels.allBoards?[indexPath.section] {
                CoreModels.currentBoard = currentBoard
                self.performSegue(withIdentifier: "boardDetailSegue", sender: nil)
            }
        }
    }
    
    /* ==========================================
    *
    * MARK: Custom Delegates
    *
    * =========================================== */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? StoryDetailViewController {
            destination.selectedStory = self.selectedStory
            destination.CoreModels = self.CoreModels
        } else if let destination = segue.destination as? StoryListViewController {
            destination.CoreModels = self.CoreModels
        }
    }

    /* ==========================================
    *
    * MARK: Segue Methods
    *
    * =========================================== */
    
    @IBAction func addBoard(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "createBoardSegue", sender: sender)
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

