//
//  CoreDataModels.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/18/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import Foundation
import CoreData

class CoreDataModels {
    
    /* ==========================================
    *
    * MARK: Core Data Properties
    *
    * =========================================== */
    
    private var managedContext:NSManagedObjectContext!
    private var boardEntityDescription:NSEntityDescription!
    private var storyEntityDescription:NSEntityDescription!
    private var subtaskEntityDescription:NSEntityDescription!
    
    /* ==========================================
    *
    * MARK: Agile Life Core Data
    *
    * =========================================== */
    
    var allBoards:[Boards]?
    var allStories:[Stories]?
    var allSubtasks:[Subtasks]?
    var currentBoard:Boards?
    var currentStory:Stories?
    var currentSubtask:Subtasks?
    
    init() {
        // Set default values on initialization
        managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        boardEntityDescription = NSEntityDescription.entityForName("Boards", inManagedObjectContext: managedContext)
        storyEntityDescription = NSEntityDescription.entityForName("Stories", inManagedObjectContext: managedContext)
        subtaskEntityDescription = NSEntityDescription.entityForName("Subtasks", inManagedObjectContext: managedContext)
    }
    
    /* ==========================================
    *
    * MARK: Core Data Fetch Methods
    *
    * =========================================== */
    
    func fetchBoards() -> ReturnStatus {
        // Set default values for CoreData properties
        let fetchRequest = NSFetchRequest(entityName: "Boards")
        let descriptor = NSSortDescriptor(key: "date_created", ascending: false)
        fetchRequest.sortDescriptors = [descriptor]
        
        do {
            if let result = try managedContext.executeFetchRequest(fetchRequest) as? [Boards] {
                self.allBoards = result
                print(result)
                print("recieved boards")
                return .Success
            } else {
                print("No boards")
                return .Warning
            }
        } catch {
            print("Failed loading the boards")
            return .Error
        }
    }
    
    func fetchStories() -> ReturnStatus {
        // Set default values for CoreData properties
        let fetchRequest = NSFetchRequest(entityName: "Stories")
        let descriptor = NSSortDescriptor(key: "date_created", ascending: false)
        fetchRequest.sortDescriptors = [descriptor]
        
        do {
            if let result = try managedContext.executeFetchRequest(fetchRequest) as? [Stories] {
                self.allStories = result
                print(result)
                print("recieved stories")
                return .Success
            } else {
                print("No stories")
                return .Warning
            }
        } catch {
            print("Failed loading the stories")
            return .Error
        }
    }
    
    func fetchSubtasks() -> ReturnStatus {
        // Set default values for CoreData properties
        let fetchRequest = NSFetchRequest(entityName: "Subtasks")
        let descriptor = NSSortDescriptor(key: "date_created", ascending: false)
        fetchRequest.sortDescriptors = [descriptor]
        
        do {
            if let result = try managedContext.executeFetchRequest(fetchRequest) as? [Subtasks] {
                self.allSubtasks = result
                print(result)
                print("recieved subtasks")
                return .Success
            } else {
                print("No subtasks")
                return .Warning
            }
        } catch {
            print("Failed loading the subtasks")
            return .Error
        }
    }
    
    /* ==========================================
    *
    * MARK: Object Creation Methods
    *
    * =========================================== */
    
    func createBoard(
        name: String, stage_one_icon: String, stage_one_name: String,
        stage_two: Bool?, stage_two_icon: String?, stage_two_name: String?,
        stage_three: Bool?, stage_three_icon: String?, stage_three_name: String?
    ) -> ReturnStatus {
            
        // Add each new property and add it to the users device
        let newBoard = Boards(entity: boardEntityDescription, insertIntoManagedObjectContext: managedContext)
        newBoard.id = NSUUID().UUIDString
        newBoard.name = name
        newBoard.date_created = NSDate()
        newBoard.stage_one_icon = stage_one_icon
        newBoard.stage_one_name = stage_one_name
        newBoard.stage_two = stage_two
        newBoard.stage_two_icon = stage_two_icon
        newBoard.stage_two_name = stage_two_name
        newBoard.stage_three = stage_three
        newBoard.stage_three_icon = stage_three_icon
        newBoard.stage_three_name = stage_three_name
        
        // Default stage 4 as we will be utilizing it for structure
        newBoard.stage_four_icon = "check-square"
        newBoard.stage_four_name = "Completed"
        
        do {
            try managedContext.save()
            return .Success
        } catch {
            print("Error creating new board")
            return .Error
        }
    }
    
    func createStory(name: String, notes: String, stage: String, priority: StoryPriority) -> ReturnStatus {
        
        // Add each new property and add it to the users device
        let newStory = Stories(entity: storyEntityDescription, insertIntoManagedObjectContext: managedContext)
        newStory.id = NSUUID().UUIDString
        newStory.name = name
        newStory.notes = notes
        newStory.stage = stage
        newStory.priority = priority.rawValue
        newStory.date_created = NSDate()
        newStory.board = currentBoard
        
        do {
            try managedContext.save()
            return .Success
        } catch {
            print("Error creating new story")
            return .Error
        }
    }
    
    func createSubtask(name: String, deadline: NSDate, description: String, completed: Bool) -> ReturnStatus {
        
        // Add each new property and add it to the users device
        let newSubtask = Subtasks(entity: subtaskEntityDescription, insertIntoManagedObjectContext: managedContext)
        newSubtask.id = NSUUID().UUIDString
        newSubtask.name = name
        newSubtask.deadline = deadline
        newSubtask.task_description = description
        newSubtask.completed = completed
        newSubtask.date_created = NSDate()
        newSubtask.story = currentStory
        
        do {
            try managedContext.save()
            return .Success
        } catch {
            print("Error creating new subtask")
            return .Error
        }
    }
}