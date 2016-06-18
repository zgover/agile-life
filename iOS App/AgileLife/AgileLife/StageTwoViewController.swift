//
//  StageTwoViewController.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/19/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

class StageTwoViewController: StageViewController {
    
    /* ==========================================
     *
     * MARK: Default Methods
     *
     * =========================================== */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.stage = 1
        super.stageName = super.stages[super.stage]
        super.stageIcon = super.icons[super.stage]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
