//
//  GlobalEnums.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/19/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import Foundation

/* ==========================================
*
* MARK: Global Enums
*
* =========================================== */

enum StoryPriority: Int {
    case Low = 1
    case MiddleLow = 2
    case MiddleHigh = 3
    case High = 4
}

enum ReturnStatus {
    case Success
    case Error
    case Warning
}