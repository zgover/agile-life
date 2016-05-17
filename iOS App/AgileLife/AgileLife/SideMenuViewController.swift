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
private let blSideMenuFooterIdentifier = "BLSideMenuTableFooter"
private let alSideMenuHeaderIdentifier = "ALSideMenuTableHeader"

class SideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /* ==========================================
    *
    * MARK: Outlet Connections
    *
    * =========================================== */
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var percentComplete: UILabel!
    
    /* ==========================================
    *
    * MARK: Global Variables
    *
    * =========================================== */
    
    let menuItems:[String] = ["Donate", "About", "Support", "Legal"]
    var directToCreateBoard = Bool()
    var CoreModels = CoreDataModels()
    
    /* ==========================================
    *
    * MARK: Default Methods
    *
    * =========================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreModels.fetchAll()
        tableView.reloadData()
        
        // Set default values
        directToCreateBoard = false
        
        // Register board list table header identifier
        tableView.registerNib(
            UINib(nibName: blSideMenuHeaderIdentifier, bundle: nil),
            forHeaderFooterViewReuseIdentifier: blSideMenuHeaderIdentifier
        )
        
        // Register board list table footer identifier
        tableView.registerNib(
            UINib(nibName: blSideMenuFooterIdentifier, bundle: nil),
            forHeaderFooterViewReuseIdentifier: blSideMenuFooterIdentifier
        )
        
        // Register Agile Life table header identifier
        tableView.registerNib(
            UINib(nibName: alSideMenuHeaderIdentifier, bundle: nil),
            forHeaderFooterViewReuseIdentifier: alSideMenuHeaderIdentifier
        )
        
        let totalComplete       = CoreModels.boardCompletion()
        percentComplete.text    = "\(Int(totalComplete * 100))%"
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
    * MARK: Table View Delegates
    *
    * =========================================== */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Boards list and Agile Life List
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let count = CoreModels.allBoards?.count {
                return count
            }
            
            return 0
            
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
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let count = CoreModels.allBoards?.count where count < 1 {
            return 45
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(blSideMenuHeaderIdentifier) as! BLSideMenuTableHeader
            header.addBoardBtn.addTarget(self, action: #selector(SideMenuViewController.addBoard), forControlEvents: .TouchUpInside)
            header.headerLabel.text = "Boards"
            return header
        } else if section == 1 {
            let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(alSideMenuHeaderIdentifier) as! ALSideMenuTableHeader
            return header
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(blSideMenuFooterIdentifier) as! BLSideMenuTableFooter
            
            if let count = CoreModels.allBoards?.count where count < 1 {
                header.viewHistoryBtn.setTitle("Please create a story", forState: .Normal)
                
                return header
            }
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Build the board item cell
            if let cell = tableView.dequeueReusableCellWithIdentifier(boardCellIdentifier, forIndexPath: indexPath) as? BLSideMenuCell {
                if let board = CoreModels.allBoards?[indexPath.row] {
                    CoreModels.fetchStories(nil, _board: CoreModels.allBoards![indexPath.row])
                    let storyCount                  = board.story_lists?.count
                    let totalComplete               = CoreModels.storyCompletion()
                    
                    cell.boardName.text             = board.name
                    cell.storyCount.text            = "\(storyCount == nil ? 0 : storyCount!) Stories"
                    cell.percentageComplete.text    = "\(Int(totalComplete * 100))% Complete"
                    cell.progressView.setProgress(totalComplete, animated: true)
                    
                    return cell
                }
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
            if let currentBoard = CoreModels.allBoards?[indexPath.row] {
                CoreModels.currentBoard = currentBoard
                performSegueWithIdentifier("boardDetailSegue", sender: nil)
            }
        } else if indexPath.section == 1 {
            // Open corresponding menu item from the Agile Life section.
            performSegueWithIdentifier("\(menuItems[indexPath.row].lowercaseString)Segue", sender: nil)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    /* ==========================================
    *
    * MARK: Segue Methods
    *
    * =========================================== */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Destinations
        
        // Home
        if let destination = segue.destinationViewController as? HomeScreenNavigationController {
            // Go directly to the create board screen
            if self.directToCreateBoard == true {
                self.directToCreateBoard = false
                destination.directToCreateBoard = true
            }
            
            // Proceed as normal here
            //if let targetController = destination.topViewController as? HomeScreenViewController {
                //targetController.delegate = self
            //}
        }
        
        // Story List
        else if let destination = segue.destinationViewController as? StoryListNavigationViewController,
            let targetController = destination.topViewController as? StoryListViewController {
            targetController.CoreModels = self.CoreModels
            //targetController.delegate = self
        }
    }
    
    /* ==========================================
    *
    * MARK: Table View Custom Methods
    *
    * =========================================== */
    func addBoard() {
        self.directToCreateBoard = true
        self.performSegueWithIdentifier("homeScreenSegue", sender: nil)
    }
}
