//
//  StoryListTableViewCell.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/20/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

class StoryListTableViewCell: UITableViewCell {

    /* ==========================================
    *
    * MARK: Outlet Connections
    *
    * =========================================== */
    
    @IBOutlet weak var priorityBg: UIView!
    @IBOutlet weak var storyName: UILabel!
    @IBOutlet weak var subtasks: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var totalCompletion: UILabel!
    @IBOutlet weak var completedIcon: UIImageView!
    
    /* ==========================================
    *
    * MARK: Default Methods
    *
    * =========================================== */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
