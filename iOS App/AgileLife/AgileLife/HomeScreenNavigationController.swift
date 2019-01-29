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
    
    override func viewDidAppear(_ animated: Bool) {
        if directToCreateBoard == true {
            self.visibleViewController?.performSegue(withIdentifier: "createBoardSegue", sender: nil)
        }
    }
    
    /* ==========================================
    *
    * MARK: Segue Methods
    *
    * =========================================== */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? HomeScreenViewController {
            destination.directToCreateBoard = true
        }
    }

}
