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
    
    func fetchAll() {
        fetchBoards()
        fetchStories(nil, _board: nil)
        fetchSubtasks(nil)
    }
    
    func fetchBoards() -> ReturnStatus {
        // Set default values for CoreData properties
        let fetchRequest = NSFetchRequest(entityName: "Boards")
        let descriptor = NSSortDescriptor(key: "date_created", ascending: false)
        fetchRequest.sortDescriptors = [descriptor]
        
        do {
            if let result = try managedContext.executeFetchRequest(fetchRequest) as? [Boards] {
                self.allBoards = result
                //print(result)
                //print("recieved boards")
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
    
    func fetchStories(stageName: String?, _board: Boards?) -> ReturnStatus {
        // Set default values for CoreData properties
        let fetchRequest = NSFetchRequest(entityName: "Stories")
        let descriptor = NSSortDescriptor(key: "priority", ascending: false)
        var stagePredicate:NSPredicate? = nil
        var boardPredicate:NSPredicate? = nil
        
        fetchRequest.sortDescriptors = [descriptor]
        
        if let stage = stageName {
            // Fetch by stage and board
            stagePredicate = NSPredicate(format: "stage = %@", stage)
        }
        
        if let board = _board {
            boardPredicate = NSPredicate(format: "board = %@ ", board)
        }
        
        if let stagePred = stagePredicate, let boardPred = boardPredicate {
            fetchRequest.predicate = NSCompoundPredicate.init(
                andPredicateWithSubpredicates: [stagePred, boardPred]
            )
        } else if let stagePred = stagePredicate {
            fetchRequest.predicate = stagePred
        } else if let boardPred = boardPredicate {
            fetchRequest.predicate = boardPred
        }
        
        do {
            if let result = try managedContext.executeFetchRequest(fetchRequest) as? [Stories] {
                self.allStories = result
                //print(result)
                //print("recieved stories")
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
    
    func fetchSubtasks(story: Stories?) -> ReturnStatus {
        // Set default values for CoreData properties
        let fetchRequest = NSFetchRequest(entityName: "Subtasks")
        let descriptor = NSSortDescriptor(key: "date_created", ascending: false)
        fetchRequest.sortDescriptors = [descriptor]
        
        if let stories = story {
            // Fetch by story type
            fetchRequest.predicate = NSPredicate(format: "story = %@", stories)
        }
        
        do {
            if let result = try managedContext.executeFetchRequest(fetchRequest) as? [Subtasks] {
                self.allSubtasks = result
                //print(result)
                //print("recieved subtasks")
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
    
    func createStory(name: String, notes: String, stage: String, priority: Int) -> ReturnStatus {
        
        // Add each new property and add it to the users device
        let newStory = Stories(entity: storyEntityDescription, insertIntoManagedObjectContext: managedContext)
        newStory.id = NSUUID().UUIDString
        newStory.name = name
        newStory.notes = notes
        newStory.stage = stage
        newStory.priority = priority
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
    
    func createSubtask(name: String, deadline: NSDate, description: String) -> ReturnStatus {
        // Add each new property and add it to the users device
        let newSubtask = Subtasks(entity: subtaskEntityDescription, insertIntoManagedObjectContext: managedContext)
        newSubtask.id = NSUUID().UUIDString
        newSubtask.name = name
        newSubtask.deadline = deadline
        newSubtask.task_description = description
        newSubtask.completed = false
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
    
    /* ==========================================
    *
    * MARK: Object Update Methods
    *
    * =========================================== */
    
    func editBoard() -> ReturnStatus {
        
        // Fetch the current active board
        let fetchRequest = NSFetchRequest(entityName: "Boards")
        fetchRequest.predicate = NSPredicate(format: "id = %@", currentBoard!.id!)
        
        do {
            if let result = try managedContext.executeFetchRequest(fetchRequest) as? [Boards] {
                //print(result)
                //print("Saved Board")
                
                if result.count > 0 {
//                    if currentBoard?.stage_one_name != result[0].stage_one_name ||
//                        currentBoard?.stage_two_name != result[0].stage_three_name ||
//                        currentBoard?.stage_three_name != result[0].stage_three_name
//                    {
//                        updateStoryStages()
//                    }
                    
                    // Save and return
                    try managedContext.save()
                    return .Success
                } else {
                    return .Error
                }
            } else {
                print("No boards")
                return .Warning
            }
        } catch {
            print("Failed saving board")
            return .Error
        }
    }
    
    func editStory() -> ReturnStatus {
        
        // Fetch the current active board
        let fetchRequest = NSFetchRequest(entityName: "Stories")
        fetchRequest.predicate = NSPredicate(format: "id = %@", currentStory!.id!)
        
        do {
            if let result = try managedContext.executeFetchRequest(fetchRequest) as? [Stories] {
                //print(result)
                //print("Saved Board")
                
                if result.count > 0 {
                    // Save and return
                    try managedContext.save()
                    return .Success
                } else {
                    return .Error
                }
            } else {
                print("No boards")
                return .Warning
            }
        } catch {
            print("Failed saving board")
            return .Error
        }
    }
    
    func editSubtask() -> ReturnStatus {
        
        // Fetch the current active board
        let fetchRequest = NSFetchRequest(entityName: "Subtasks")
        fetchRequest.predicate = NSPredicate(format: "id = %@", currentSubtask!.id!)
        
        do {
            if let result = try managedContext.executeFetchRequest(fetchRequest) as? [Subtasks] {
                //print(result)
                //print("Saved Board")
                
                if result.count > 0 {
                    // Save and return
                    try managedContext.save()
                    return .Success
                } else {
                    return .Error
                }
            } else {
                print("No boards")
                return .Warning
            }
        } catch {
            print("Failed saving board")
            return .Error
        }
    }
    
    /* ==========================================
    *
    * MARK: Object Delete Methods
    *
    * =========================================== */
    
    func deleteBoard() -> ReturnStatus {
        // Fetch the current active board
        let fetchRequest = NSFetchRequest(entityName: "Boards")
        fetchRequest.predicate = NSPredicate(format: "id = %@", currentBoard!.id!)
        
        do {
            if let result = try managedContext.executeFetchRequest(fetchRequest) as? [Boards],
                let selectedEntity = result.first
            {
                //print(result)
                print("Deleted Board")
                
                if result.count > 0 {                    
                    // delete and return
                    managedContext.deleteObject(selectedEntity)
                    try managedContext.save()
                    return .Success
                } else {
                    return .Error
                }
            } else {
                print("No boards")
                return .Warning
            }
        } catch {
            print("Failed deleting board")
            return .Error
        }
    }
    
    func deleteStory(board: Bool) -> ReturnStatus {
        // Fetch the current active board
        let fetchRequest = NSFetchRequest(entityName: "Stories")
        
        if board {
            fetchRequest.predicate = NSPredicate(format: "board = %@", currentBoard!)
        } else {
            fetchRequest.predicate = NSPredicate(format: "id = %@", currentStory!.id!)
        }
        
        do {
            if let result = try managedContext.executeFetchRequest(fetchRequest) as? [Stories] {
                
                if result.count > 0 {
                    // delete and return
                    for item in result {
                        managedContext.deleteObject(item)
                    }
                    
                    return .Success
                } else {
                    return .Error
                }
            } else {
                print("No stories")
                return .Warning
            }
        } catch {
            print("Failed deleting story")
            return .Error
        }
    }
    
    func deleteSubtask(story: Bool) -> ReturnStatus {
        // Fetch the current active board
        let fetchRequest = NSFetchRequest(entityName: "Subtasks")
        
        if story {
            fetchRequest.predicate = NSPredicate(format: "story = %@", currentStory!)
        } else {
            fetchRequest.predicate = NSPredicate(format: "id = %@", currentSubtask!.id!)
        }
        
        do {
            if let result = try managedContext.executeFetchRequest(fetchRequest) as? [Subtasks] {
                
                if result.count > 0 {
                    // delete and return
                    for item in result {
                        managedContext.deleteObject(item)
                    }
                    
                    return .Success
                } else {
                    return .Error
                }
            } else {
                print("No stories")
                return .Warning
            }
        } catch {
            print("Failed deleting story")
            return .Error
        }
    }
    
    /* ==========================================
    *
    * MARK: Detail Methods
    *
    * =========================================== */
    
    func stageName(row: Int, stageTotalCount: Int) -> String {
        switch (row, stageTotalCount) {
        case (0, 2):
            return (currentBoard?.stage_one_name)!
        case (0, 3):
            return (currentBoard?.stage_one_name)!
        case (0, 4):
            return (currentBoard?.stage_one_name)!
        case (1, 2):
            return (currentBoard?.stage_four_name)!
        case (1, 3):
            return (currentBoard?.stage_two_name)!
        case (1, 4):
            return (currentBoard?.stage_two_name)!
        case (2, 3):
            return (currentBoard?.stage_four_name)!
        case (2, 4):
            return (currentBoard?.stage_three_name)!
        case (3, 4):
            return (currentBoard?.stage_four_name)!
        default:
            return "ERROR!!!!"
        }
    }
    
    func setPriorityBG(priority: Int) -> UIColor {
        switch priority {
        case 1:
            // Green
            return UIColor(red: 29/255, green: 146/255, blue: 69/255, alpha: 0.5)
        case 2:
            // Yellow
            return UIColor(red: 204/255, green: 187/255, blue: 45/255, alpha: 0.5)
        case 3:
            // Orange
            return UIColor(red: 204/255, green: 144/255, blue: 47/255, alpha: 0.5)
        case 4:
            // Red
            return UIColor(red: 146/255, green: 30/255, blue: 30/255, alpha: 0.5)
        default:
            // Green
            return UIColor(red: 29/255, green: 146/255, blue: 69/255, alpha: 0.5)
        }
    }
    
    func subtaskCompletion(storyIndex: Int) -> Float {
        var totalCount:Float = 0.0
        var completedSubtasks:Float = 0.0
        
        // Set default values for CoreData properties
        let fetchRequest = NSFetchRequest(entityName: "Subtasks")
        fetchRequest.predicate = NSPredicate(format: "story = %@", self.allStories![storyIndex])
        
        do {
            if let result = try managedContext.executeFetchRequest(fetchRequest) as? [Subtasks] {
                for task in result {
                    totalCount = totalCount + 1.0
                    
                    if task.completed == true {
                        completedSubtasks = completedSubtasks + 1.0
                    }
                }
            } else {
                print("No subtasks")
                return 0.0
            }
        } catch {
            print("Failed loading the subtasks")
            return 0.0
        }
        
        return self.calculateCompletionPercentage(totalCount, completedSubtasks: completedSubtasks)
    }
    
    func storyCompletion() -> Float {
        var totalCount:Float = 0.0
        var completedSubtasks:Float = 0.0
        
        for story in self.allStories! {
            let tasks = story.sub_tasks as! NSMutableSet
            
            for task in tasks {
                totalCount = totalCount + 1.0
                
                if String(task.valueForKey("completed")!) == "1" {
                    completedSubtasks = completedSubtasks + 1.0
                }
            }
        }
        
        return self.calculateCompletionPercentage(totalCount, completedSubtasks: completedSubtasks)
    }
    
    private func calculateCompletionPercentage(totalCount: Float, completedSubtasks: Float) -> Float {
        if totalCount == completedSubtasks && completedSubtasks != 0.0 {
            return 1.0
        } else if completedSubtasks == 0.0 {
            return 0.0
        }
        
        let totalComplete:Float = (1.0 / totalCount) * completedSubtasks
        
        return totalComplete
    }
}