//
//  SubtaskDetailViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/22/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

class SubtaskDetailViewController: UIViewController, ViewDelegates {

    /* ==========================================
    *
    * MARK: Outlet Connections
    *
    * =========================================== */
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var deadline: UILabel!
    @IBOutlet weak var subtaskDescription: UITextView!
    
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
        super.setDefualtNav(nil, statusBg: true, bg: true)
        
        // Do any additional setup after loading the view.
        name.text = CoreModels.currentSubtask!.name
        deadline.text = String(describing: CoreModels.currentSubtask!.deadline!)
        subtaskDescription.text = CoreModels.currentSubtask!.task_description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = .short
        
        CoreModels.fetchSubtasks(CoreModels.currentStory)
        name.text = CoreModels.currentSubtask!.name
        deadline.text = formatter.string(from: (CoreModels.currentSubtask!.deadline!) as Date)
        subtaskDescription.text = CoreModels.currentSubtask!.task_description
    }
    
    /* ==========================================
    *
    * MARK: Segue Methods
    *
    * =========================================== */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditSubtaskViewController {
            destination.CoreModels = self.CoreModels
            destination.delegate = self
        }
    }

    
    /* ==========================================
    *
    * MARK: View Delegates
    *
    * =========================================== */
    
    func didDeleteSubtask(_ didDelete: Bool) {
        if didDelete == true {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
