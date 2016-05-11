//
//  ViewDelegates.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/19/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import Foundation

@objc protocol ViewDelegates {
    optional func didDeleteSubtask(didDelete: Bool)
    optional func selectedIcon(icon: String)
}