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

class StoryDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ViewDelegates {

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
        tableView.register(
            UINib(nibName: SubtaskListCellIdentifier, bundle: nil),
            forCellReuseIdentifier: SubtaskListCellIdentifier
        )
        
        // Register story list table header identifier
        tableView.register(
            UINib(nibName: SubtaskListHeaderIdentifier, bundle: nil),
            forHeaderFooterViewReuseIdentifier: SubtaskListHeaderIdentifier
        )
        
        didDeleteSubtask(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CoreModels.fetchSubtasks(CoreModels.currentStory)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = CoreModels.allSubtasks?.count {
            return count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SubtaskListCellIdentifier) as? StoryListTableViewCell {
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.short
            formatter.timeStyle = .short
            
            let taskDate = formatter.string(from: CoreModels.allSubtasks![indexPath.row].deadline! as Date)
            
            cell.storyName.text = CoreModels.allSubtasks![indexPath.row].name
            cell.subtasks.text = CoreModels.allSubtasks![indexPath.row].task_description
            cell.totalCompletion.text = "\(taskDate)"
            cell.progressBar.isHidden = true
            cell.priorityBg.isHidden = true
            
            if CoreModels.allSubtasks![indexPath.row].completed == 1 {
                cell.totalCompletion.isHidden = true
                cell.completedIcon.isHidden = false
            } else {
                cell.totalCompletion.isHidden = false
                cell.completedIcon.isHidden = true
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedStory = indexPath.row
        
        if let currentSubtask = CoreModels.allSubtasks?[indexPath.row] {
            CoreModels.currentSubtask = currentSubtask
            
            performSegue(withIdentifier: "subtaskDetailSegue", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SubtaskListHeaderIdentifier) as! StoryListTableHeader
        header.createStory.addTarget(self, action: #selector(StoryDetailViewController.addSubtask), for: .touchUpInside)
        header.header.text = "Sub-tasks"
        
        return header
    }
    
    /* ==========================================
    *
    * MARK: Segue Methods
    *
    * =========================================== */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditStoryViewController {
            destination.delegate = self
            destination.CoreModels = self.CoreModels
            destination.currentStage = self.currentStage
        } else if let destination = segue.destination as? CreateSubtaskViewController {
            destination.CoreModels = self.CoreModels
        } else if let destination = segue.destination as? SubtaskDetailViewController {
            destination.CoreModels = self.CoreModels
        }
    }
    
    /* ==========================================
    *
    * MARK: Custom Methods
    *
    * =========================================== */
    
    func addSubtask() {
        performSegue(withIdentifier: "createSubtaskSegue", sender: nil)
    }

    
    /* ==========================================
    *
    * MARK: View Delegates
    *
    * =========================================== */
    
    func didDeleteSubtask(_ didDelete: Bool) {
        if didDelete {
            self.navigationController?.popViewController(animated: true)
        } else {
            CoreModels.fetchSubtasks(CoreModels.currentStory)
            name.text = currentStory.name
            stage.text = currentStory.stage
            priority.text = "\(currentStory.priority!)"
            notes.text = currentStory.notes
            tableView.reloadData()
        }
    }
}
