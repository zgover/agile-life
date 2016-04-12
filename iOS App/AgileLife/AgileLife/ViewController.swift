//
//  ViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/11/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        super.setDefualtNav(menuBtn)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

