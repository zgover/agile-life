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
    
    /* ==========================================
    *
    * MARK: Default Methods
    *
    * =========================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setDefualtNav(menuBtn)
        
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
            forHeaderFooterViewReuseIdentifier: HomeScreenFooterIdentifier
        )
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
    
    /* ==========================================
    *
    * MARK: Tableview Delegate Methods
    *
    * =========================================== */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
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
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 52
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(HomeScreenCellIdentfier) as? HomeScreenTableViewCell {
            cell.storyName.text = "Algebra 1"
            cell.subtaskCount.text = "23 Sub-tasks"
            cell.percentageComplete.text = "32% Complete"
            cell.progressBar.setProgress(0.32, animated: true)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HomeScreenHeaderIdentifier) as! HomeScreenTableViewHeader
        header.boardName.text = "School Board"
        return header
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HomeScreenFooterIdentifier) as! HomeScreenTableViewFooter
        return footer
    }

    /* ==========================================
    *
    * MARK: Segue Methods
    *
    * =========================================== */
    
    @IBAction func addBoard(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("createBoardSegue", sender: sender)
    }

}

