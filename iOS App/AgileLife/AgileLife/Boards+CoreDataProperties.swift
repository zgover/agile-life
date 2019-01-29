//
//  Boards+CoreDataProperties.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/18/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Boards {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var stage_one_name: String?
    @NSManaged var stage_two: NSNumber?
    @NSManaged var stage_two_name: String?
    @NSManaged var stage_three: NSNumber?
    @NSManaged var stage_three_name: String?
    @NSManaged var stage_one_icon: String?
    @NSManaged var stage_two_icon: String?
    @NSManaged var stage_three_icon: String?
    @NSManaged var date_created: Date?
    @NSManaged var stage_four_name: String?
    @NSManaged var stage_four_icon: String?
    @NSManaged var story_lists: NSOrderedSet?

}
