//
//  ViewControllerExtensions.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/11/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import Foundation

extension UIViewController {
    
    /* ==========================================
    *
    * Change the default properties for the nav
    *
    * =========================================== */
    func setDefualtNav(menuBtn: UIBarButtonItem) {

        // Create status bar bg
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        view.backgroundColor = UIColor(red: 0/255, green: 55/255, blue: 53/255, alpha: 0.5)
        
        // Make sure the nav controller won't go beyond the status bar so we may see the status bar bg
        self.navigationController?.navigationBar.clipsToBounds = true
        
        // Set the application BG and add the status bar background
        self.view.backgroundColor = UIColor(red: 36/255, green: 103/255, blue: 101/255, alpha: 1)
        self.view.addSubview(view)
        
        // Open the side menu by the bar button item
        if revealViewController() != nil {
            let deviceWidth = UIScreen.mainScreen().bounds.size.width
            let sideMenuWidth = round(80 / 100 * deviceWidth)
            revealViewController().rearViewRevealWidth = sideMenuWidth
            
            menuBtn.target = revealViewController()
            menuBtn.action = "revealToggle:"
        }
    }
    
}