//
//  CreateBoardViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/14/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

class CreateBoardViewController: UIViewController {

    /* ==========================================
    *
    * MARK: Outlet Connections
    *
    * =========================================== */
    
    @IBOutlet weak var boardNameInput: UITextField!
    @IBOutlet weak var stage1Input: UITextField!
    @IBOutlet weak var stage2Input: UITextField!
    @IBOutlet weak var stage3Input: UITextField!
    @IBOutlet weak var stage1Icon: UIImageView!
    @IBOutlet weak var stage2Icon: UIImageView!
    @IBOutlet weak var stage3Icon: UIImageView!
    
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

    /* ==========================================
    *
    * MARK: Custom Methods
    *
    * =========================================== */
    @IBAction func stage1EditIcon(sender: UIButton) {
        
    }
    
    @IBAction func stage2EditIcon(sender: UIButton) {
        
    }
    
    @IBAction func stage3EditIcon(sender: UIButton) {
        
    }
    
    @IBAction func createBoard(sender: UIButton) {
        
    }
}
