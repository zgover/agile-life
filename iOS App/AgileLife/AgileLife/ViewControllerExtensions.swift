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
    func setDefualtNav(_ menuBtn: UIBarButtonItem?, statusBg: Bool, bg: Bool) {

        // Add the status bar BG if requested
        if bg {
            // Set the application BG and add the status bar background
            self.view.backgroundColor = UIColor(red: 36/255, green: 103/255, blue: 101/255, alpha: 1)
        }
        
        if statusBg {
            // Create status bar bg
            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
            view.backgroundColor = UIColor(red: 0/255, green: 55/255, blue: 53/255, alpha: 0.5)
            
            // Make sure the nav controller won't go beyond the status bar so we may see the status bar bg
            self.navigationController?.navigationBar.clipsToBounds = true
            self.view.addSubview(view)
        }
        
        // Open the side menu by the bar button item
        if let btn = menuBtn, revealViewController() != nil {
            let deviceWidth = UIScreen.main.bounds.size.width
            let sideMenuWidth = deviceWidth * 0.8
            
            revealViewController().rearViewRevealWidth = sideMenuWidth
            revealViewController().rearViewRevealOverdraw = 0
            
            btn.target = revealViewController()
            btn.action = #selector(SWRevealViewController.revealToggle(_:))
        }
    }
    
}
