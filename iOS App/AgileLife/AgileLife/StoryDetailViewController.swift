//
//  StoryDetailViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/21/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

private var SubtaskListCellIdentifier = "StoryListTableViewCell"
private var SubtaskListHeaderIdentifier = "StoryListTableHeader"

class StoryDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    /* ==========================================
    *
    * MARK: Outlet Connections
    *
    * =========================================== */
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var stage: UILabel!
    @IBOutlet weak var priority: UILabel!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    /* ==========================================
    *
    * MARK: Global Variables
    *
    * =========================================== */
    
    var CoreModels:CoreDataModels!
    var selectedStory:Int!
    var currentStory:Stories!
    var currentStage:Int!
    
    /* ==========================================
    *
    * MARK: Default Methods
    *
    * =========================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setDefualtNav(nil, statusBg: true, bg: true)

        // Do any additional setup after loading the view.
        currentStory = CoreModels.allStories![selectedStory]
        name.text = currentStory.name
        stage.text = currentStory.stage
        priority.text = "\(currentStory.priority!)"
        notes.text = currentStory.notes
        
        // Register story list table view cell
        tableView.registerNib(
            UINib(nibName: SubtaskListCellIdentifier, bundle: nil),
            forCellReuseIdentifier: SubtaskListCellIdentifier
        )
        
        // Register story list table header identifier
        tableView.registerNib(
            UINib(nibName: SubtaskListHeaderIdentifier, bundle: nil),
            forHeaderFooterViewReuseIdentifier: SubtaskListHeaderIdentifier
        )
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        CoreModels.fetchSubtasks(currentStory)
        name.text = currentStory.name
        stage.text = currentStory.stage
        priority.text = "\(currentStory.priority!)"
        notes.text = currentStory.notes
        tableView.reloadData()
    }
    
    /* ==========================================
    *
    * MARK: Tableview Delegates
    *
    * =========================================== */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = CoreModels.allSubtasks?.count {
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
        if let cell = tableView.dequeueReusableCellWithIdentifier(SubtaskListCellIdentifier) as? StoryListTableViewCell {
            cell.storyName.text = CoreModels.allSubtasks![indexPath.row].name
            cell.subtasks.text = CoreModels.allSubtasks![indexPath.row].task_description
            cell.totalCompletion.text = "\(CoreModels.allSubtasks![indexPath.row].deadline!)"
            cell.progressBar.hidden = true
            cell.priorityBg.hidden = true
            
            if CoreModels.allSubtasks![indexPath.row].completed == true {
                cell.totalCompletion.hidden = true
                cell.completedIcon.hidden = false
                
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedStory = indexPath.row
        
        if let currentSubtask = CoreModels.allSubtasks?[indexPath.row] {
            CoreModels.currentSubtask = currentSubtask
            
            performSegueWithIdentifier("subtaskDetailSegue", sender: nil)
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(SubtaskListHeaderIdentifier) as! StoryListTableHeader
        header.createStory.addTarget(self, action: Selector("addSubtask"), forControlEvents: .TouchUpInside)
        header.header.text = "Sub-tasks"
        
        return header
    }
    
    /* ==========================================
    *
    * MARK: Segue Methods
    *
    * =========================================== */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? EditStoryViewController {
            destination.CoreModels = self.CoreModels
        } else if let destination = segue.destinationViewController as? CreateSubtaskViewController {
            destination.CoreModels = self.CoreModels
        } else if let destination = segue.destinationViewController as? SubtaskDetailViewController {
            destination.CoreModels = self.CoreModels
        }
    }
    
    /* ==========================================
    *
    * MARK: Custom Methods
    *
    * =========================================== */
    
    func addSubtask() {
        performSegueWithIdentifier("createSubtaskSegue", sender: nil)
    }

}
