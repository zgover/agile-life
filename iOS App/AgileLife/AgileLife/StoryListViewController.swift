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
    var tabItemsSet = false
    
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
        setStages()
        tabItemsSet = true
        
        performSegueWithIdentifier("createStorySegue", sender: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {        
        CoreModels.fetchAll()
        self.title = CoreModels.currentBoard?.name
        setStages()
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
        }
    }
    
    
    /* ==========================================
    *
    * MARK: Custom Methods
    *
    * =========================================== */
    
    func setStages() {
        var tabItems = self.tabBar.items! as [UITabBarItem]
        tabItems[tabItems.count - 1].title = "Complete"
        tabItems[tabItems.count - 1].image = UIImage(named: "check-square")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

        
        // Set stage 1 tabbar elemented
        if let stageOneName = CoreModels.currentBoard?.stage_one_name,
            let stageOneImage = CoreModels.currentBoard?.stage_one_icon
        {
            tabItems[0].title = stageOneName
            tabItems[0].image = UIImage(named: stageOneImage)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        }
        
        // Set stage 2 tabbar elements; if not enabled remove second stage
        if let stageTwoName = CoreModels.currentBoard?.stage_two_name,
            let stageTwoImage = CoreModels.currentBoard?.stage_two_icon,
            let enabled = CoreModels.currentBoard?.stage_two where enabled == true
        {
            tabItems[1].title = stageTwoName
            tabItems[1].image = UIImage(named: stageTwoImage)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        } else if !tabItemsSet {
            self.viewControllers?.removeAtIndex(1)
        }
        
        // Set stage 3 tabbar elements; if not enabled remove second stage
        if let stageThreeName = CoreModels.currentBoard?.stage_three_name,
            let stageThreeImage = CoreModels.currentBoard?.stage_three_icon,
            let enabled = CoreModels.currentBoard?.stage_three where enabled == true
        {
            tabItems[2].title = stageThreeName
            tabItems[2].image = UIImage(named: stageThreeImage)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        } else if !tabItemsSet {
            self.viewControllers?.removeAtIndex(2)
        }
    }
}
