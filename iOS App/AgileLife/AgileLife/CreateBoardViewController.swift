//
//  CreateBoardViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/14/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

private let iconPickerSegueIdentifier = "iconPickerSegue"

class CreateBoardViewController: UIViewController, UITextFieldDelegate, ViewDelegates {

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
    var selectedIcon:String!
    var stage1IconName:String = "hourglass"
    var stage2IconName:String = "edit-square"
    var stage3IconName:String = "users"
    
    /* ==========================================
    *
    * MARK: Default Methods
    *
    * =========================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setDefualtNav(nil, statusBg: true, bg: true)

        // Set default values
        stage1Icon.image = UIImage(named: stage1IconName)
        stage2Icon.image = UIImage(named: stage2IconName)
        stage3Icon.image = UIImage(named: stage3IconName)
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
    * MARK: Segue Methods
    *
    * =========================================== */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? IconPickerViewController {
            destination.selectedIcon = selectedIcon
            destination.delegate = self
        }
    }
    
    /* ==========================================
    *
    * MARK: View Delegates
    *
    * =========================================== */
    
    func selectedIcon(icon: String) {
        switch self.selectedIcon {
        case "stage1":
            stage1IconName = icon
            stage1Icon.image = UIImage(named: icon)
        case "stage2":
            stage2IconName = icon
            stage2Icon.image = UIImage(named: icon)
        case "stage3":
            stage3IconName = icon
            stage3Icon.image = UIImage(named: icon)
        default:
            break
        }
    }

    /* ==========================================
    *
    * MARK: Edit Icon Methods
    *
    * =========================================== */
    @IBAction func stage1EditIcon(sender: UIButton) {
        selectedIcon = "stage1"
        performSegueWithIdentifier(iconPickerSegueIdentifier, sender: sender)
    }
    
    @IBAction func stage2EditIcon(sender: UIButton) {
        selectedIcon = "stage2"
        performSegueWithIdentifier(iconPickerSegueIdentifier, sender: sender)
    }
    
    @IBAction func stage3EditIcon(sender: UIButton) {
        selectedIcon = "stage3"
        performSegueWithIdentifier(iconPickerSegueIdentifier, sender: sender)
    }
    
    /* ==========================================
    *
    * MARK: Board Actions
    *
    * =========================================== */
    
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
        } else {
            // Loop through all of the fields and make sure they're no duplicate names,
            // because there are dependencies on their name
            let allFields:[(text: String, on: Bool)] = [
                (boardNameInput.text!, true),
                (stage1Input.text!, true),
                (stage2Input.text!, stage2Switch.on),
                (stage3Input.text!, stage3Switch.on)
            ]
            
            for (currentText, on) in allFields {
                if on {
                    var dupCount = 0
                    
                    for (searchText, on) in allFields {
                        if on && currentText == searchText {
                            dupCount++
                        }
                    }
                    
                    if dupCount > 1 {
                        // Alert the user this is a duplicate
                        let alertController = UIAlertController(title: "Warning", message: "Please make sure they're no duplicate names.", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        return
                    }
                }
            }
        }
        
        // Create the board
        let creationResult = CoreModels.createBoard(
            boardNameInput.text!, stage_one_icon: stage1IconName, stage_one_name: stage1Input.text!,
            stage_two: stage2Switch.on, stage_two_icon: stage2IconName, stage_two_name: stage2Input.text,
            stage_three: stage3Switch.on, stage_three_icon: stage3IconName, stage_three_name: stage3Input.text
        )
        
        // Dismiss view controller or notify the user based in the returned result of creating a board.
        switch creationResult {
        case .Success:
            
            self.navigationController?.popViewControllerAnimated(true)
            
        default:
            
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Error", message: "An error has occurred! Please review all fields and make sure they are correct, before you try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
}
