//
//  ViewDelegates.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/19/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import Foundation

@objc protocol ViewDelegates {
    @objc optional func didDeleteSubtask(_ didDelete: Bool)
    @objc optional func didDeleteStory(_ didDelete: Bool)
    @objc optional func selectedIcon(_ icon: String)
}
