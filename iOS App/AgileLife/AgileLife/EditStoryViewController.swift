//
//  EditStoryViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/23/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

class EditStoryViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    /* ==========================================
    *
    * MARK: Outlet Connections
    *
    * =========================================== */
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var stage: UIPickerView!
    @IBOutlet weak var priority: UISegmentedControl!
    
    /* ==========================================
    *
    * MARK: Global Variables
    *
    * =========================================== */
    
    var CoreModels:CoreDataModels!
    var selectedStage:String!
    var stageTotalCount:Int!
    var stageCount:Int = 0
    var delegate:ViewDelegates!
    
    /* ==========================================
    *
    * MARK: Default Methods
    *
    * =========================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setDefualtNav(nil, statusBg: true, bg: true)
        name.delegate = self
        // Do any additional setup after loading the view.
        
        name.text = CoreModels.currentStory!.name
        notes.text = CoreModels.currentStory!.notes
        priority.selectedSegmentIndex = Int(CoreModels.currentStory!.priority!) - 1
    
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
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
    * MARK: UIPickerView Delegates
    *
    * =========================================== */
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var stageCount = 2
        
        if CoreModels.currentBoard?.stage_two == 1 {
            stageCount = stageCount + 1
        }
        
        if CoreModels.currentBoard?.stage_three == 1 {
            stageCount = stageCount + 1
        }
        
        stageTotalCount = stageCount
        
        return stageCount
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let stageName = CoreModels.stageName(row, stageTotalCount: stageTotalCount)
        selectedStage = stageName
        
        // Grab index so we may select it on load
        if selectedStage == CoreModels.currentStory!.stage {
            stage.selectRow(row, inComponent: 0, animated: true)
        }
        
        return stageName
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStage = CoreModels.stageName(row, stageTotalCount: stageTotalCount)
    }
    
    /* ==========================================
    *
    * MARK: Custom Methods
    *
    * =========================================== */
    
    @IBAction func editStory(sender: UIButton) {
        // Notify the user if there is anything wrong with the required fields.
        if name.text == "" {
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Warning", message: "Please specify a story name.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        } else if selectedStage == nil {
            // Alert the user if this is true
            let alertController = UIAlertController(title: "Warning", message: "Please specify the stage.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        // Create the board
        CoreModels.currentStory?.name = name.text
        CoreModels.currentStory?.notes = notes.text
        CoreModels.currentStory?.stage = selectedStage
        CoreModels.currentStory?.priority = priority.selectedSegmentIndex + 1
        
        let creationResult = CoreModels.editStory()
        
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

    @IBAction func deleteBoard(sender: UIButton) {
        let alertController = UIAlertController(title: "Warning", message: "You're about to delete this story, please confirm.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) -> Void in
            self.CoreModels.deleteStory(false)
            self.delegate.didDeleteSubtask!(true)
            self.navigationController?.popViewControllerAnimated(true)
        }))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
