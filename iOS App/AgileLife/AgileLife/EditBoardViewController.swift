//
//  EditBoardViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/20/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

class EditBoardViewController: UIViewController, UITextFieldDelegate {

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
        boardNameInput.text = CoreModels.currentBoard?.name
        stage1Input.text = CoreModels.currentBoard?.stage_one_name
        
        // Set stage 1 elements
        if let stageOneName = CoreModels.currentBoard?.stage_one_name,
            let stageOneImage = CoreModels.currentBoard?.stage_one_icon
        {
            stage1Input.text = stageOneName
            stage1Icon.image = UIImage(named: stageOneImage)
        }
        
        // Set stage 2 elements; if not enabled remove second stage
        if let stageTwoName = CoreModels.currentBoard?.stage_two_name,
            let stageTwoImage = CoreModels.currentBoard?.stage_two_icon,
            let enabled = CoreModels.currentBoard?.stage_two where enabled == true
        {
            stage2Input.text = stageTwoName
            stage2Icon.image = UIImage(named: stageTwoImage)
            stage2Switch.on = true
            stage2Switch.enabled = false
        } else {
            stage2Input.enabled = false
            stage2Switch.on = false
            stage2Switch.enabled = false
        }
        
        // Set stage 3 elements; if not enabled remove second stage
        if let stageThreeName = CoreModels.currentBoard?.stage_three_name,
            let stageThreeImage = CoreModels.currentBoard?.stage_three_icon,
            let enabled = CoreModels.currentBoard?.stage_three where enabled == true
        {
            stage3Input.text = stageThreeName
            stage3Icon.image = UIImage(named: stageThreeImage)
            stage3Switch.on = true
            stage3Switch.enabled = false
        } else {
            stage3Input.enabled = false
            stage3Switch.on = false
            stage3Switch.enabled = false
        }
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
    
    @IBAction func saveBoard(sender: UIButton) {
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
            let alertController = UIAlertController(title: "Warning", message: "Please specify the second stage", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        } else if stage3Switch.on && stage3Input.text == "" {
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Warning", message: "Please specify the third stage.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        let stories = CoreModels.currentBoard?.story_lists as! NSMutableOrderedSet
        
        for story in stories {
            let currentStage = String(story.valueForKey("stage")!)
            let stage1 = String(CoreModels.currentBoard!.stage_one_name!)
            let stage2 = String(CoreModels.currentBoard!.stage_two_name!)
            let stage3 = String(CoreModels.currentBoard!.stage_three_name!)

            // Update each story under this board, with the updated stages.
            switch currentStage {
            case stage1:
                story.setValue(String(UTF8String: stage1Input.text!)! as AnyObject!, forKey: "stage")
                print(stage1)
            case stage2:
                story.setValue(String(UTF8String: stage2Input.text!)! as AnyObject!, forKey: "stage")
                print(stage2)
            case stage3:
                story.setValue(String(UTF8String: stage3Input.text!)! as AnyObject!, forKey: "stage")
                print(stage3)
            default:
                print("error")
                break
            }
        }
        
        CoreModels.currentBoard?.name = boardNameInput.text
        CoreModels.currentBoard?.stage_one_name = stage1Input.text
        CoreModels.currentBoard?.stage_two_name = stage2Input.text
        CoreModels.currentBoard?.stage_three_name = stage3Input.text
        CoreModels.currentBoard?.story_lists = stories
        
        let creationResult = CoreModels.editBoard()
        
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

    
    @IBAction func deleteBoard(sender: UIButton) {
        let alertController = UIAlertController(title: "Warning", message: "You're about to delete this board, please confirm.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) -> Void in
            self.CoreModels.deleteBoard()
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
