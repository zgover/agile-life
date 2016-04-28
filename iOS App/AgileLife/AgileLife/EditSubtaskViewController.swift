//
//  EditSubtaskViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/26/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

class EditSubtaskViewController: UIViewController {
    
    /* ==========================================
    *
    * MARK: Outlet Connections
    *
    * =========================================== */
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var deadline: UITextField!
    @IBOutlet weak var subtaskDescription: UITextView!
    @IBOutlet weak var completeBtnBG: UITextField!
    @IBOutlet weak var completeBtn: UIButton!
    
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

        // Do any additional setup after loading the view.
        name.text = CoreModels.currentSubtask!.name
        deadline.text = String(CoreModels.currentSubtask!.deadline!)
        subtaskDescription.text = CoreModels.currentSubtask!.task_description
        
        if CoreModels.currentSubtask!.completed == true {
            completeBtn.hidden = true
            completeBtnBG.hidden = true
        }
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
    
    @IBAction func EditSubtask(sender: UIButton) {
        // Notify the user if there is anything wrong with the required fields.
        //let strTime = "2015-07-27 19:29:50"
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = formatter.dateFromString(deadline.text!)
        
        if name.text == "" {
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Warning", message: "Please specify a subtask name.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        } else if date == nil  {
            // Alert the user if this is true
            let alertController = UIAlertController(title: "Warning", message: "Please correct the date to the specified format MM/DD/YYYY HH:mm:ss.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        // Create the board
        CoreModels.currentSubtask?.name = name.text
        CoreModels.currentSubtask?.task_description = subtaskDescription.text
        CoreModels.currentSubtask?.deadline = date
        
        let creationResult = CoreModels.editSubtask()
        
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
    
    @IBAction func deleteSubtask(sender: UIButton) {
        let alertController = UIAlertController(title: "Warning", message: "You're about to delete this subtask, please confirm.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) -> Void in
            self.CoreModels.deleteSubtask(false)
            self.navigationController?.popViewControllerAnimated(true)
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func completeSubtask(sender: UIButton) {
        let alertController = UIAlertController(title: "Warning", message: "Are you sure you would like to complete this subtask?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Complete", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) -> Void in
            self.CoreModels.currentSubtask?.completed = true
            self.EditSubtask(sender)
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
