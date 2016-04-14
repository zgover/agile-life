//
//  SideMenuViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/12/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

private let boardCellIdentifier = "SideMenuBoardCell"
private let agileCellIdentifier = "SideMenuAgileCell"
private let blSideMenuHeaderIdentifier = "BLSideMenuTableHeader"

class SideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /* ==========================================
    *
    * MARK: Outlet Connections
    *
    * =========================================== */
    @IBOutlet weak var tableView: UITableView!
    
    
    /* ==========================================
    *
    * MARK: Global Variables
    *
    * =========================================== */
    let menuItems:[String] = ["Donate", "About", "Support", "Legal"]
    
    
    /* ==========================================
    *
    * MARK: Default Methods
    *
    * =========================================== */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set default values
        
        // Register board list table header identifier
        tableView.registerNib(
            UINib(nibName: blSideMenuHeaderIdentifier, bundle: nil),
            forHeaderFooterViewReuseIdentifier: blSideMenuHeaderIdentifier
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* ==========================================
    *
    * MARK: Table View Delegates
    *
    * =========================================== */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Boards list and Agile Life List
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return menuItems.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60.0
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(blSideMenuHeaderIdentifier) as! BLSideMenuTableHeader
            return header
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Build the board item cell
            if let cell = tableView.dequeueReusableCellWithIdentifier(boardCellIdentifier, forIndexPath: indexPath) as? BLSideMenuCell {
                cell.boardName.text             = "School Board"
                cell.storyCount.text            = "23 Stories"
                cell.percentageComplete.text    = "32% Complete"
                cell.progressView.setProgress(0.32, animated: true)
                
                return cell
            }
        } else if indexPath.section == 1 {
            // Build the menu item cells for the Agile Life section
            if let cell = tableView.dequeueReusableCellWithIdentifier(agileCellIdentifier, forIndexPath: indexPath) as? AgileLifeTableViewCell {
                cell.menuItem.text = menuItems[indexPath.row]
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            // Open board detail view
            performSegueWithIdentifier("boardDetailSegue", sender: nil)
        } else if indexPath.section == 1 {
            // Open corresponding menu item from the Agile Life section.
            performSegueWithIdentifier("\(menuItems[indexPath.row].lowercaseString)Segue", sender: nil)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
