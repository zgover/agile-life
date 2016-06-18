//
//  StoryListViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/16/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

class StoryListViewController: UITabBarController {

    /* ==========================================
    *
    * MARK: Outlet Connections
    *
    * =========================================== */
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    /* ==========================================
    *
    * MARK: Global Variables
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
        super.setDefualtNav(menuBtn, statusBg: true, bg: true)
        super.setDefualtNav(nil, statusBg: true, bg: true)
        super.setDefualtNav(nil, statusBg: true, bg: true)
        super.setDefualtNav(nil, statusBg: true, bg: true)
        self.title = CoreModels.currentBoard?.name
        
        // Set default values
        self.viewControllers = CoreModels.setStages(self.tabBar.items!, viewCntrls: self.viewControllers)
        
        //performSegueWithIdentifier("createStorySegue", sender: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        storyboard.instantiateViewControllerWithIdentifier("stage1View")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {        
        CoreModels.fetchAll()
        self.title = CoreModels.currentBoard?.name
        self.viewControllers = CoreModels.setStages(self.tabBar.items!, viewCntrls: self.viewControllers)
        
        // Loop through each view controller in the tabbar and update them
        if let controllers = viewControllers {
            for view in controllers {
                if let stage1 = view as? StageOneViewController {
                    stage1.CoreModels = self.CoreModels
                    stage1.CoreModels.fetchAll()
                    stage1.CoreModels.fetchStories((CoreModels.currentBoard?.stage_one_name)!, _board: CoreModels!.currentBoard)
                    
                    if stage1.tableView != nil {
                        stage1.tableView.reloadData()
                    }
                } else if let stage2 = view as? StageTwoViewController {
                    stage2.CoreModels = self.CoreModels
                    stage2.CoreModels.fetchAll()
                    stage2.CoreModels.fetchStories((CoreModels.currentBoard?.stage_two_name)!, _board: CoreModels!.currentBoard)
                    
                    if stage2.tableView != nil {
                        stage2.tableView.reloadData()
                    }
                } else if let stage3 = view as? StageThreeViewController {
                    stage3.CoreModels = self.CoreModels
                    stage3.CoreModels.fetchAll()
                    stage3.CoreModels.fetchStories((CoreModels.currentBoard?.stage_three_name)!, _board: CoreModels!.currentBoard)
                    
                    if stage3.tableView != nil {
                        stage3.tableView.reloadData()
                    }
                } else if let stage4 = view as? StageFourViewController {
                    stage4.CoreModels = self.CoreModels
                    stage4.CoreModels.fetchAll()
                    stage4.CoreModels.fetchStories((CoreModels.currentBoard?.stage_four_name)!, _board: CoreModels!.currentBoard)
                    
                    if stage4.tableView != nil {
                        stage4.tableView.reloadData()
                    }
                }
            }
        }
        
        
        //super.setDefualtNav(menuBtn, statusBg: true, bg: true)
        //tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        // Resest tab bar height to make it have more space
        var tabBarFrame = self.tabBar.frame
        tabBarFrame.size.height = 55
        tabBarFrame.origin.y = self.view.frame.size.height - tabBarFrame.size.height
        self.tabBar.frame = tabBarFrame
    }

    
    /* ==========================================
    *
    * MARK: Segue Methods
    *
    * =========================================== */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? EditBoardViewController {
            destination.CoreModels = self.CoreModels
        } else if let destination = segue.destinationViewController as? CreateStoryViewController {
            destination.CoreModels = self.CoreModels
            destination.currentStage = self.selectedIndex
        }
    }
}
