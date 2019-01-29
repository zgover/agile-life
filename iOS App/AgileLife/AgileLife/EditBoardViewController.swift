//
//  EditBoardViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/20/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

private let iconPickerSegueIdentifier = "iconPickerSegue"

class EditBoardViewController: UIViewController, UITextFieldDelegate, ViewDelegates {

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
    var stage1IconName = ""
    var stage2IconName = ""
    var stage3IconName = ""
    
    /* ==========================================
    *
    * MARK: Default Methods
    *
    * =========================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setDefualtNav(nil, statusBg: true, bg: true)
        stage1Input.delegate = self
        stage2Input.delegate = self
        stage3Input.delegate = self
        boardNameInput.delegate = self
        
        // Set default values
        boardNameInput.text = CoreModels.currentBoard?.name
        stage1Input.text = CoreModels.currentBoard?.stage_one_name
        
        // Set stage 1 elements
        if let stageOneName = CoreModels.currentBoard?.stage_one_name,
            let stageOneImage = CoreModels.currentBoard?.stage_one_icon
        {
            stage1Input.text = stageOneName
            stage1Icon.image = UIImage(named: stageOneImage)
            stage1IconName = stageOneImage
        }
        
        // Set stage 2 elements; if not enabled remove second stage
        if let stageTwoName = CoreModels.currentBoard?.stage_two_name,
            let stageTwoImage = CoreModels.currentBoard?.stage_two_icon,
            let enabled = CoreModels.currentBoard?.stage_two, enabled == true
        {
            stage2Input.text = stageTwoName
            stage2Icon.image = UIImage(named: stageTwoImage)
            stage2Switch.isOn = true
            stage2Switch.isEnabled = false
            stage2IconName = stageTwoImage
        } else {
            stage2Input.isEnabled = false
            stage2Switch.isOn = false
            stage2Switch.isEnabled = false
        }
        
        // Set stage 3 elements; if not enabled remove second stage
        if let stageThreeName = CoreModels.currentBoard?.stage_three_name,
            let stageThreeImage = CoreModels.currentBoard?.stage_three_icon,
            let enabled = CoreModels.currentBoard?.stage_three, enabled == true
        {
            stage3Input.text = stageThreeName
            stage3Icon.image = UIImage(named: stageThreeImage)
            stage3Switch.isOn = true
            stage3Switch.isEnabled = false
            stage3IconName = stageThreeImage
        } else {
            stage3Input.isEnabled = false
            stage3Switch.isOn = false
            stage3Switch.isEnabled = false
        }
    
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditBoardViewController.dismissKeyboard))
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
    * MARK: Segue Methods
    *
    * =========================================== */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? IconPickerViewController {
            destination.selectedIcon = selectedIcon
            destination.delegate = self
        }
    }
    
    
    /* ==========================================
    *
    * MARK: View Delegates
    *
    * =========================================== */
    
    func selectedIcon(_ icon: String) {
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
    
    @IBAction func stage1EditIcon(_ sender: UIButton) {
        selectedIcon = "stage1"
        performSegue(withIdentifier: iconPickerSegueIdentifier, sender: sender)
    }
    
    @IBAction func stage2EditIcon(_ sender: UIButton) {
        selectedIcon = "stage2"
        performSegue(withIdentifier: iconPickerSegueIdentifier, sender: sender)
    }
    
    @IBAction func stage3EditIcon(_ sender: UIButton) {
        selectedIcon = "stage3"
        performSegue(withIdentifier: iconPickerSegueIdentifier, sender: sender)
    }
    
    
    /* ==========================================
    *
    * MARK: Board Actions
    *
    * =========================================== */
    
    @IBAction func saveBoard(_ sender: UIButton) {
        // Notify the user if there is anything wrong with the required fields.
        if boardNameInput.text == "" {
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Warning", message: "Please specify a board name.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return
        } else if stage1Input.text == "" {
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Warning", message: "Please specify the first stage", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return
        } else if stage2Switch.isOn && stage2Input.text == "" {
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Warning", message: "Please specify the second stage", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return
        } else if stage3Switch.isOn && stage3Input.text == "" {
            // Alert the user if this fails
            let alertController = UIAlertController(title: "Warning", message: "Please specify the third stage.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        let stories = CoreModels.currentBoard?.story_lists as! NSMutableOrderedSet
        
        for story in stories {
            let currentStage = String((story describing: as AnyObject).value(forKey: "stage")!)
            let stage1 = String(CoreModels.currentBoard!.stage_one_name!)
            let stage2 = String(CoreModels.currentBoard!.stage_two_name!)
            let stage3 = String(CoreModels.currentBoard!.stage_three_name!)

            // Update each story under this board, with the updated stages.
            switch currentStage {
            case stage1:
                (story as AnyObject).setValue(String(validatingUTF8: stage1Input.text!)! as AnyObject!, forKey: "stage")
            case stage2:
                (story as AnyObject).setValue(String(validatingUTF8: stage2Input.text!)! as AnyObject!, forKey: "stage")
            case stage3:
                (story as AnyObject).setValue(String(validatingUTF8: stage3Input.text!)! as AnyObject!, forKey: "stage")
            default:
                break
            }
        }
        
        CoreModels.currentBoard?.name = boardNameInput.text
        CoreModels.currentBoard?.stage_one_name = stage1Input.text
        CoreModels.currentBoard?.stage_one_icon = stage1IconName
        CoreModels.currentBoard?.stage_two_name = stage2Input.text
        CoreModels.currentBoard?.stage_two_icon = stage2IconName
        CoreModels.currentBoard?.stage_three_name = stage3Input.text
        CoreModels.currentBoard?.stage_three_icon = stage3IconName
        CoreModels.currentBoard?.story_lists = stories
        
        let creationResult = CoreModels.editBoard()
        
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

    
    @IBAction func deleteBoard(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Warning", message: "You're about to delete this board, please confirm.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) -> Void in
            self.CoreModels.deleteBoard()
            self.navigationItem.hidesBackButton = true
            self.view.isUserInteractionEnabled = false
            self.revealViewController().revealToggle(animated: true)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
}
