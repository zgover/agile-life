//
//  StageTwoViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/19/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

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
    }
    
    override func viewWillAppear(animated: Bool) {
        CoreModels.fetchAll()
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        if let count = CoreModels.allBoards?.count {
//            return count
//        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        if let cell = tableView.dequeueReusableCellWithIdentifier(HomeScreenCellIdentfier) as? HomeScreenTableViewCell {
        //            cell.storyName.text = "Algebra 1"
        //            cell.subtaskCount.text = "23 Sub-tasks"
        //            cell.percentageComplete.text = "32% Complete"
        //            cell.progressBar.setProgress(0.32, animated: true)
        //            return cell
        //        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HomeScreenHeaderIdentifier) as! HomeScreenTableViewHeader
        //        header.boardName.text = CoreModels.allBoards![section].name
        return UIView()
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //        let footer = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HomeScreenFooterIdentifier) as! HomeScreenTableViewFooter
        return UIView()
    }
}
