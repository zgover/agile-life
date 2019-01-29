//
//  StageViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 6/18/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit
private var StoryListCellIdentifier = "StoryListTableViewCell"
private var StoryListHeaderIdentifier = "StoryListTableHeader"

class StageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    var stageName:String = ""
    var stageIcon:String = ""
    var stage:Int = 0
    var stages:[String] = []
    var icons:[String] = []
    
    /* ==========================================
     *
     * MARK: Default Methods
     *
     * =========================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stages = [
            (CoreModels.currentBoard?.stage_one_name)!,
            (CoreModels.currentBoard?.stage_two_name)!,
            (CoreModels.currentBoard?.stage_three_name)!,
            (CoreModels.currentBoard?.stage_four_name)!
        ]
        
        self.icons = [
            (CoreModels.currentBoard?.stage_one_icon)!,
            (CoreModels.currentBoard?.stage_two_icon)!,
            (CoreModels.currentBoard?.stage_three_icon)!,
            (CoreModels.currentBoard?.stage_four_icon)!
        ]
        
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        //super.setDefualtNav(nil, statusBg: false, bg: true)
        
        // Grab the current live instance of CoreModels from the tabbar root controller
        if let storyList = self.tabBarController as? StoryListViewController {
            self.CoreModels = storyList.CoreModels
        }
        
        // Register story list table view cell
        tableView.register(
            UINib(nibName: StoryListCellIdentifier, bundle: nil),
            forCellReuseIdentifier: StoryListCellIdentifier
        )
        
        // Register story list table header identifier
        tableView.register(
            UINib(nibName: StoryListHeaderIdentifier, bundle: nil),
            forHeaderFooterViewReuseIdentifier: StoryListHeaderIdentifier
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        CoreModels.fetchAll()
        CoreModels.fetchStories(stageName, _board: CoreModels!.currentBoard)
        tableView.reloadData()
        
        // Make sure to update the tabbar icon if they have recently edited the board icons
        self.tabBarItem.image = UIImage(named: stageIcon)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        if let controller = self.tabBarController as? StoryListViewController {
            CoreModels.setStages(controller.tabBar.items!, viewCntrls: nil)
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CoreModels.fetchAll()
        CoreModels.fetchStories(stageName, _board: CoreModels!.currentBoard)
        
        if let count = CoreModels.allStories?.count {
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: StoryListCellIdentifier) as? StoryListTableViewCell {
            CoreModels.fetchAll()
            CoreModels.fetchStories(stageName, _board: CoreModels!.currentBoard)
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedStory = indexPath.row
        
        if let currentStory = CoreModels.allStories?[selectedStory] {
            CoreModels.currentStory = currentStory
            
            performSegue(withIdentifier: "storyDetailSegue", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: StoryListHeaderIdentifier) as! StoryListTableHeader
        header.createStory.addTarget(self, action: #selector(StageViewController.addStory), for: .touchUpInside)
        
        return header
    }
    
    /* ==========================================
     *
     * MARK: Segue Methods
     *
     * =========================================== */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? StoryDetailViewController {
            destination.CoreModels = self.CoreModels
            destination.selectedStory = selectedStory
            destination.currentStage = self.stage
        } else if let destination = segue.destination as? CreateStoryViewController {
            destination.CoreModels = self.CoreModels
            destination.currentStage = self.tabBarController?.selectedIndex
        }
    }
    
    /* ==========================================
     *
     * MARK: Custom Methods
     *
     * =========================================== */
    
    func addStory() {
        self.performSegue(withIdentifier: "createStorySegue", sender: nil)
    }

}
