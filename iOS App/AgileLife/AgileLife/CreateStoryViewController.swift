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
    var currentStage:Int!
    
    /* ==========================================
    *
    * MARK: Default Methods
    *
    * =========================================== */

    override func viewDidLoad() {
        super.viewDidLoad()
        super.setDefualtNav(nil, statusBg: true, bg: true)
        stage.selectRow(0, inComponent: 0, animated: false)
        name.delegate = self
        // Do any additional setup after loading the view.
    
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateStoryViewController.dismissKeyboard))
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.endEditing(true)
        return false
    }
    
    /* ==========================================
    *
    * MARK: UIPickerView Delegates
    *
    * =========================================== */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let stageName = CoreModels.stageName(row, stageTotalCount: stageTotalCount)
        selectedStage = stageName
        
        if row == currentStage {
            stage.selectRow(row, inComponent: 0, animated: true)
        }
        
        return stageName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStage = CoreModels.stageName(row, stageTotalCount: stageTotalCount)
    }
    
    /* ==========================================
    *
    * MARK: Custom Methods
    *
    * =========================================== */

    @IBAction func createStory(_ sender: UIButton) {
        // Notify the user if there is anything wrong with the required fields.
        if name.text == "" {
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Warning", message: "Please specify a story name.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return
        } else if selectedStage == nil {
            // Alert the user if this is true
            let alertController = UIAlertController(title: "Warning", message: "Please specify the stage.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        // Create the board
        let creationResult = CoreModels.createStory(
            name.text!, notes: notes.text, stage:
            selectedStage, priority: priority.selectedSegmentIndex + 1
        )
        
        // Dismiss view controller or notify the user based in the returned result of creating a board.
        switch creationResult {
        case .success:
            
            self.navigationController?.popViewController(animated: true)
            
        default:
            
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Error", message: "An error has occurred! Please review all fields and make sure they are correct, before you try again.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
        }
    }
}
