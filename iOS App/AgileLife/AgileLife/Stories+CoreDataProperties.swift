//
//  Stories+CoreDataProperties.swift
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

extension Stories {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var notes: String?
    @NSManaged var stage: String?
    @NSManaged var priority: NSNumber?
    @NSManaged var date_created: NSDate?
    @NSManaged var board: Boards?
    @NSManaged var sub_tasks: NSSet?

}
