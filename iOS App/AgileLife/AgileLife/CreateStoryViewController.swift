//
//  CreateStoryViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/20/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

class CreateStoryViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
    
    /* ==========================================
    *
    * MARK: Default Methods
    *
    * =========================================== */

    override func viewDidLoad() {
        super.viewDidLoad()
        super.setDefualtNav(nil, statusBg: true, bg: true)

        // Do any additional setup after loading the view.
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
        return stageName(row)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStage = stageName(row)
    }
    
    /* ==========================================
    *
    * MARK: Custom Methods
    *
    * =========================================== */
    
    func stageName(row: Int) -> String {
        switch (row, stageTotalCount) {
        case (0, 2):
            return (CoreModels.currentBoard?.stage_one_name)!
        case (0, 3):
            return( CoreModels.currentBoard?.stage_one_name)!
        case (0, 4):
            return (CoreModels.currentBoard?.stage_one_name)!
        case (1, 2):
            return (CoreModels.currentBoard?.stage_four_name)!
        case (1, 3):
            return (CoreModels.currentBoard?.stage_two_name)!
        case (1, 4):
            return (CoreModels.currentBoard?.stage_two_name)!
        case (2, 2):
            return (CoreModels.currentBoard?.stage_four_name)!
        case (2, 3):
            return (CoreModels.currentBoard?.stage_two_name)!
        case (2, 4):
            return (CoreModels.currentBoard?.stage_two_name)!
        case (3, 4):
            return (CoreModels.currentBoard?.stage_four_name)!
        default:
            return "ERROR!!!!"
        }
    }

    @IBAction func createStory(sender: UIButton) {
        // Notify the user if there is anything wrong with the required fields.
        if name.text == "" {
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Warning", message: "Please specify a story name.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        } else if selectedStage == nil {
            // Alert the user if this is true
            let alertController = UIAlertController(title: "Warning", message: "Please specify the stage.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        // Create the board
        let creationResult = CoreModels.createStory(
            name.text!, notes: notes.text, stage:
            selectedStage, priority: priority.selectedSegmentIndex + 1
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
