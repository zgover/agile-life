//
//  CreateSubtaskViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/22/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

class CreateSubtaskViewController: UIViewController, UITextFieldDelegate {

    /* ==========================================
    *
    * MARK: Outlet Connections
    *
    * =========================================== */
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var deadline: UIDatePicker!
    @IBOutlet weak var subtaskDescription: UITextView!
    
    /* ==========================================
    *
    * MARK: Global Variables
    *
    * =========================================== */
    
    var CoreModels:CoreDataModels!
    var selectedStage:String!
    var stageTotalCount:Int!
    var currentStage:Int!
    
    /* ==========================================
    *
    * MARK: Default Methods
    *
    * =========================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setDefualtNav(nil, statusBg: true, bg: true)
        name.delegate = self
        
        deadline.date = NSDate()

        // Do any additional setup after loading the view.
    
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateSubtaskViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
        view.endEditing(true)
        return false
    }
    
    /* ==========================================
    *
    * MARK: Custom Methods
    *
    * =========================================== */
    
    @IBAction func createSubtask(sender: UIButton) {
        // Notify the user if there is anything wrong with the required fields.
        if name.text == "" {
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Warning", message: "Please specify a subtask name.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
//        else if deadline.date == nil  {
//            // Alert the user if this is true
//            let alertController = UIAlertController(title: "Warning", message: "Please correct the date to the specified format MM/DD/YYYY HH:mm:ss.", preferredStyle: UIAlertControllerStyle.Alert)
//            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
//            
//            presentViewController(alertController, animated: true, completion: nil)
//            
//            return
//        }
        
        // Create the board
        let creationResult = CoreModels.createSubtask(
            name.text!, deadline: deadline.date, description: subtaskDescription.text
        )
        
        // Dismiss view controller or notify the user based in the returned result of creating a board.
        switch creationResult {
        case .Success:

            self.navigationController?.popViewControllerAnimated(true)
            
        default:
            
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Error", message: "An error has occurred! Please review all fields and make sure they are correct, before you try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            presentViewController(alertController, animated: true, completion: nil)
            
        }
    }

}
