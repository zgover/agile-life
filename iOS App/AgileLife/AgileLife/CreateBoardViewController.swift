//
//  CreateBoardViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/14/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

class CreateBoardViewController: UIViewController, UITextFieldDelegate {

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
    @IBOutlet weak var stage2Switch: UISwitch!
    @IBOutlet weak var stage3Switch: UISwitch!
    
    
    /* ==========================================
    *
    * MARK: Global Variables
    *
    * =========================================== */
    
    var CoreModels = CoreDataModels()
    
    /* ==========================================
    *
    * MARK: Default Methods
    *
    * =========================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setDefualtNav(nil, statusBg: true, bg: true)

        // Set default values
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* ==========================================
    *
    * MARK: TextField Delegates
    *
    * =========================================== */
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        // Notify the user if there is anything wrong with the required fields.
        if boardNameInput.text == "" {
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Warning", message: "Please specify a board name.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        } else if stage1Input.text == "" {
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Warning", message: "Please specify the first stage", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        } else if stage2Switch.on && stage2Input.text == "" {
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Warning", message: "Please specify the second stage, or disable it.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        } else if stage3Switch.on && stage3Input.text == "" {
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Warning", message: "Please specify the third stage, or disable it.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        // Create the board
        let creationResult = CoreModels.createBoard(
            boardNameInput.text!, stage_one_icon: "hourglass", stage_one_name: stage1Input.text!,
            stage_two: stage2Switch.on, stage_two_icon: "edit-square", stage_two_name: stage2Input.text,
            stage_three: stage3Switch.on, stage_three_icon: "users", stage_three_name: stage3Input.text
        )
        
        // Dismiss view controller or notify the user based in the returned result of creating a board.
        switch creationResult {
        case .Success:
            
            self.navigationController?.popViewControllerAnimated(true)
            
        default:
            
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Error", message: "An error has occurred! please review all fields and make sure they are correct, before you try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
}
