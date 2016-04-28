//
//  SubtaskDetailViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/22/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

class SubtaskDetailViewController: UIViewController {

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
        deadline.text = String(CoreModels.currentSubtask!.deadline!)
        subtaskDescription.text = CoreModels.currentSubtask!.task_description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        CoreModels.fetchSubtasks(CoreModels.currentStory)
        name.text = CoreModels.currentSubtask!.name
        deadline.text = String(CoreModels.currentSubtask!.deadline!)
        subtaskDescription.text = CoreModels.currentSubtask!.task_description
    }
    
    /* ==========================================
    *
    * MARK: Segue Methods
    *
    * =========================================== */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? EditSubtaskViewController {
            destination.CoreModels = self.CoreModels
        }
    }

}
