//
//  StageTwoViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/19/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

private var StoryListCellIdentifier = "StoryListTableViewCell"
private var StoryListHeaderIdentifier = "StoryListTableHeader"

class StageTwoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    /* ==========================================
    *
    * MARK: Outlet Connections
    *
    * =========================================== */
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    /* ==========================================
    *
    * MARK: Global Properties
    *
    * =========================================== */
    
    var CoreModels:CoreDataModels!
    var selectedStory:Int!
    
    /* ==========================================
    *
    * MARK: Default Methods
    *
    * =========================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //super.setDefualtNav(nil, statusBg: false, bg: true)
        
        // Grab the current live instance of CoreModels from the tabbar root controller
        if let storyList = self.tabBarController as? StoryListViewController {
            self.CoreModels = storyList.CoreModels
        }
        
        // Register story list table view cell
        tableView.registerNib(
            UINib(nibName: StoryListCellIdentifier, bundle: nil),
            forCellReuseIdentifier: StoryListCellIdentifier
        )
        
        // Register story list table header identifier
        tableView.registerNib(
            UINib(nibName: StoryListHeaderIdentifier, bundle: nil),
            forHeaderFooterViewReuseIdentifier: StoryListHeaderIdentifier
        )
    }
    
    override func viewWillAppear(animated: Bool) {
        print("hello")
        CoreModels.fetchAll()
        CoreModels.fetchStories((CoreModels.currentBoard?.stage_two_name)!, _board: CoreModels!.currentBoard)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* ==========================================
    *
    * MARK: Tableview Delegates
    *
    * =========================================== */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = CoreModels.allStories?.count {
            return count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(StoryListCellIdentifier) as? StoryListTableViewCell {
            let totalComplete = CoreModels.subtaskCompletion(indexPath.row)
            let subtaskCount = CoreModels.allStories![indexPath.row].sub_tasks?.count
            cell.storyName.text = CoreModels.allStories![indexPath.row].name
            cell.subtasks.text = "\(subtaskCount == nil ? 0 : subtaskCount!) Sub-tasks"
            cell.totalCompletion.text = "\(Int(totalComplete * 100))% Complete"
            cell.progressBar.setProgress(totalComplete, animated: true)
            cell.priorityBg.backgroundColor = CoreModels.setPriorityBG(Int(CoreModels.allStories![indexPath.row].priority!))
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedStory = indexPath.row
        
        if let currentStory = CoreModels.allStories?[selectedStory] {
            CoreModels.currentStory = currentStory
            
            performSegueWithIdentifier("storyDetailSegue", sender: nil)
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(StoryListHeaderIdentifier) as! StoryListTableHeader
        header.createStory.addTarget(self, action: Selector("addStory"), forControlEvents: .TouchUpInside)
        
        return header
    }
    
    /* ==========================================
    *
    * MARK: Segue Methods
    *
    * =========================================== */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? StoryDetailViewController {
            destination.CoreModels = self.CoreModels
            destination.selectedStory = selectedStory
        }
    }
    
    /* ==========================================
    *
    * MARK: Custom Methods
    *
    * =========================================== */
    
    func addStory() {
        self.performSegueWithIdentifier("createStorySegue", sender: nil)
    }
}
