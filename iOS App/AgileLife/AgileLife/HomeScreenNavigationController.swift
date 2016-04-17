//
//  HomeScreenNavigationController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/16/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

class HomeScreenNavigationController: UINavigationController {
    
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

        // Set default values
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if directToCreateBoard == true {
            self.visibleViewController?.performSegueWithIdentifier("createBoardSegue", sender: nil)
        }
    }
    
    /* ==========================================
    *
    * MARK: Segue Methods
    *
    * =========================================== */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? HomeScreenViewController {
            destination.directToCreateBoard = true
            print("nav = true")
        }
        print(segue.sourceViewController)
    }

}
