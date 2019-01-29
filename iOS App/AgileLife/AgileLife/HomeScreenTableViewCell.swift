//
//  HomeScreenTableViewCell.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/16/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit

class HomeScreenTableViewCell: UITableViewCell {
    
    /* ==========================================
    *
    * MARK: Outlet Connections
    *
    * =========================================== */
    
    @IBOutlet weak var storyName: UILabel!
    @IBOutlet weak var subtaskCount: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var percentageComplete: UILabel!

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
