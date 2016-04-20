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
        super.setDefualtNav(menuBtn)
        self.title = CoreModels.currentBoard?.name
        
        // Set default values
        let tabItems = self.tabBar.items! as [UITabBarItem]
        let stage1 = tabItems[0] as UITabBarItem
        let stage2 = tabItems[1] as UITabBarItem
        let stage3 = tabItems[2] as UITabBarItem
        let stage4 = tabItems[3] as UITabBarItem
        stage4.title = "Complete"
        stage4.image = UIImage(named: "check-square")
        
        print(stage4.title)
        
        if let stageOneName = CoreModels.currentBoard?.stage_one_name,
           let stageOneImage = CoreModels.currentBoard?.stage_one_icon
        {
            stage1.title = stageOneName
            stage1.image = UIImage(named: stageOneImage)
        }
        
        if let stageTwoName = CoreModels.currentBoard?.stage_two_name,
           let stageTwoImage = CoreModels.currentBoard?.stage_two_icon
        {
            stage2.title = stageTwoName
            stage2.image = UIImage(named: stageTwoImage)
        }
        
        if let stageThreeName = CoreModels.currentBoard?.stage_three_name,
           let stageThreeImage = CoreModels.currentBoard?.stage_three_icon
        {
            stage3.title = stageThreeName
            stage3.image = UIImage(named: stageThreeImage)
        }
        
        // Hide the second or third stage if it is disabled on the board.
        if CoreModels.currentBoard?.stage_two == 0 {
            self.viewControllers?.removeAtIndex(1)
        }
        
        if CoreModels.currentBoard?.stage_three == 0 {
            self.viewControllers?.removeAtIndex(2)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        // Resest tab bar height to make it have more space
        var tabBarFrame = self.tabBar.frame
        tabBarFrame.size.height = 50
        tabBarFrame.origin.y = self.view.frame.size.height - 60
        self.tabBar.frame = tabBarFrame
    }

}
