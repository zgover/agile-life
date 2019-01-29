//
//  Subtasks+CoreDataProperties.swift
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

extension Subtasks {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var deadline: Date?
    @NSManaged var task_description: String?
    @NSManaged var completed: NSNumber?
    @NSManaged var date_created: Date?
    @NSManaged var story: Stories?

}
