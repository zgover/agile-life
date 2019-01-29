//
//  CoreDataModels.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/18/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import Foundation
import CoreData
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class CoreDataModels {
    
    /* ==========================================
    *
    * MARK: Core Data Properties
    *
    * =========================================== */
    
    fileprivate var managedContext:NSManagedObjectContext!
    fileprivate var boardEntityDescription:NSEntityDescription!
    fileprivate var storyEntityDescription:NSEntityDescription!
    fileprivate var subtaskEntityDescription:NSEntityDescription!
    
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
        managedContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        boardEntityDescription = NSEntityDescription.entity(forEntityName: "Boards", in: managedContext)
        storyEntityDescription = NSEntityDescription.entity(forEntityName: "Stories", in: managedContext)
        subtaskEntityDescription = NSEntityDescription.entity(forEntityName: "Subtasks", in: managedContext)
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Boards")
        let descriptor = NSSortDescriptor(key: "date_created", ascending: false)
        fetchRequest.sortDescriptors = [descriptor]
        
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [Boards] {
                self.allBoards = result
                //print(result)
                //print("recieved boards")
                return .success
            } else {
                print("No boards")
                return .warning
            }
        } catch {
            print("Failed loading the boards")
            return .error
        }
    }
    
    func fetchStories(_ stageName: String?, _board: Boards?) -> ReturnStatus {
        // Set default values for CoreData properties
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stories")
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
            if let result = try managedContext.fetch(fetchRequest) as? [Stories] {
                self.allStories = result
                //print(result)
                //print("recieved stories")
                return .success
            } else {
                print("No stories")
                return .warning
            }
        } catch {
            print("Failed loading the stories")
            return .error
        }
    }
    
    func fetchSubtasks(_ story: Stories?) -> ReturnStatus {
        // Set default values for CoreData properties
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Subtasks")
        let descriptor = NSSortDescriptor(key: "completed", ascending: true)
        fetchRequest.sortDescriptors = [descriptor]
        
        if let stories = story {
            // Fetch by story type
            fetchRequest.predicate = NSPredicate(format: "story = %@", stories)
        }
        
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [Subtasks] {
                self.allSubtasks = result
                //print(result)
                //print("recieved subtasks")
                return .success
            } else {
                print("No subtasks")
                return .warning
            }
        } catch {
            print("Failed loading the subtasks")
            return .error
        }
    }
    
    /* ==========================================
    *
    * MARK: Object Creation Methods
    *
    * =========================================== */
    
    func createBoard(
        _ name: String, stage_one_icon: String, stage_one_name: String,
        stage_two: Bool?, stage_two_icon: String?, stage_two_name: String?,
        stage_three: Bool?, stage_three_icon: String?, stage_three_name: String?
    ) -> ReturnStatus {
            
        // Add each new property and add it to the users device
        let newBoard = Boards(entity: boardEntityDescription, insertInto: managedContext)
        newBoard.id = UUID().uuidString
        newBoard.name = name
        newBoard.date_created = Date()
        newBoard.stage_one_icon = stage_one_icon
        newBoard.stage_one_name = stage_one_name
        newBoard.stage_two = stage_two as! NSNumber
        newBoard.stage_two_icon = stage_two_icon
        newBoard.stage_two_name = stage_two_name
        newBoard.stage_three = stage_three as! NSNumber
        newBoard.stage_three_icon = stage_three_icon
        newBoard.stage_three_name = stage_three_name
        
        // Default stage 4 as we will be utilizing it for the app
        newBoard.stage_four_icon = "finished-flag"
        newBoard.stage_four_name = "Completed"
        
        do {
            try managedContext.save()
            self.currentBoard = newBoard
            return .success
        } catch {
            print("Error creating new board")
            return .error
        }
    }
    
    func createStory(_ name: String, notes: String, stage: String, priority: Int) -> ReturnStatus {
        
        // Add each new property and add it to the users device
        let newStory = Stories(entity: storyEntityDescription, insertInto: managedContext)
        newStory.id = UUID().uuidString
        newStory.name = name
        newStory.notes = notes
        newStory.stage = stage
        newStory.priority = priority as NSNumber
        newStory.date_created = Date()
        newStory.board = currentBoard
        
        do {
            try managedContext.save()
            self.currentStory = newStory
            return .success
        } catch {
            print("Error creating new story")
            return .error
        }
    }
    
    func createSubtask(_ name: String, deadline: Date, description: String) -> ReturnStatus {
        // Add each new property and add it to the users device
        let newSubtask = Subtasks(entity: subtaskEntityDescription, insertInto: managedContext)
        newSubtask.id = UUID().uuidString
        newSubtask.name = name
        newSubtask.deadline = deadline
        newSubtask.task_description = description
        newSubtask.completed = false
        newSubtask.date_created = Date()
        newSubtask.story = currentStory
        
        do {
            try managedContext.save()
            self.currentSubtask = newSubtask
            return .success
        } catch {
            print("Error creating new subtask")
            return .error
        }
    }
    
    /* ==========================================
    *
    * MARK: Object Update Methods
    *
    * =========================================== */
    
    func editBoard() -> ReturnStatus {
        
        // Fetch the current active board
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Boards")
        fetchRequest.predicate = NSPredicate(format: "id = %@", currentBoard!.id!)
        
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [Boards] {
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
                    return .success
                } else {
                    return .error
                }
            } else {
                print("No boards")
                return .warning
            }
        } catch {
            print("Failed saving board")
            return .error
        }
    }
    
    func editStory() -> ReturnStatus {
        
        // Fetch the current active board
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stories")
        fetchRequest.predicate = NSPredicate(format: "id = %@", currentStory!.id!)
        
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [Stories] {
                //print(result)
                //print("Saved Board")
                
                if result.count > 0 {
                    // Save and return
                    try managedContext.save()
                    return .success
                } else {
                    return .error
                }
            } else {
                print("No boards")
                return .warning
            }
        } catch {
            print("Failed saving board")
            return .error
        }
    }
    
    func editSubtask() -> ReturnStatus {
        
        // Fetch the current active board
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Subtasks")
        fetchRequest.predicate = NSPredicate(format: "id = %@", currentSubtask!.id!)
        
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [Subtasks] {
                //print(result)
                //print("Saved Board")
                
                if result.count > 0 {
                    // Save and return
                    try managedContext.save()
                    return .success
                } else {
                    return .error
                }
            } else {
                print("No boards")
                return .warning
            }
        } catch {
            print("Failed saving board")
            return .error
        }
    }
    
    /* ==========================================
    *
    * MARK: Object Delete Methods
    *
    * =========================================== */
    
    func deleteBoard() -> ReturnStatus {
        // Fetch the current active board
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Boards")
        fetchRequest.predicate = NSPredicate(format: "id = %@", currentBoard!.id!)
        
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [Boards] {
                if result.count > 0 {
                    for board in result {
                        self.currentBoard = board
                        
                        for story in self.allStories! {
                            self.fetchSubtasks(story)
                            self.currentStory = story
                            deleteSubtask(true)
                            deleteStory(true)
                        }
                        
                        managedContext.delete(board)
                    }
                    // delete and return
                    try managedContext.save()
                    print("Deleted Board")
                    return .success
                } else {
                    return .error
                }
            } else {
                print("No boards")
                return .warning
            }
        } catch {
            print("Failed deleting board")
            return .error
        }
    }
    
    func deleteStory(_ board: Bool) -> ReturnStatus {
        // Fetch the current active board
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stories")
        
        if board {
            fetchRequest.predicate = NSPredicate(format: "board = %@", currentBoard!)
        } else {
            fetchRequest.predicate = NSPredicate(format: "id = %@", currentStory!.id!)
        }
        
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [Stories] {
                
                if result.count > 0 {
                    // delete and return
                    for item in result {
                        self.fetchSubtasks(item)
                        self.currentStory = item
                        self.deleteSubtask(true)
                        managedContext.delete(item)
                    }
                    
                    try managedContext.save()
                    
                    return .success
                } else {
                    return .error
                }
            } else {
                print("No stories")
                return .warning
            }
        } catch {
            print("Failed deleting story")
            return .error
        }
    }
    
    func deleteSubtask(_ story: Bool) -> ReturnStatus {
        // Fetch the current active board
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Subtasks")
        
        if story {
            fetchRequest.predicate = NSPredicate(format: "story = %@", currentStory!)
        } else {
            fetchRequest.predicate = NSPredicate(format: "id = %@", currentSubtask!.id!)
        }
        
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [Subtasks] {
                
                if result.count > 0 {
                    // delete and return
                    for item in result {
                        managedContext.delete(item)
                    }
                    
                    try managedContext.save()
                    
                    return .success
                } else {
                    return .error
                }
            } else {
                print("No stories")
                return .warning
            }
        } catch {
            print("Failed deleting story")
            return .error
        }
    }
    
    /* ==========================================
    *
    * MARK: Detail Methods
    *
    * =========================================== */
    
    func stageName(_ row: Int, stageTotalCount: Int) -> String {
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
    
    func setStages(_ items:[UITabBarItem], viewCntrls:[UIViewController]?) -> [UIViewController]? {
        var vc = viewCntrls
        var tabItems = items as [UITabBarItem]
        tabItems[tabItems.count - 1].title = "Complete"
        tabItems[tabItems.count - 1].image = UIImage(named: "finished-flag")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        tabItems[tabItems.count - 1].selectedImage = UIImage(named: "finished-flag")
        
        
        // Set stage 1 tabbar elemented
        if let stageOneName = self.currentBoard?.stage_one_name,
            let stageOneImage = self.currentBoard?.stage_one_icon
        {
            tabItems[0].title = stageOneName
            tabItems[0].image = UIImage(named: stageOneImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            tabItems[0].selectedImage = UIImage(named: stageOneImage)
        }
        
        // Set stage 2 tabbar elements; if not enabled remove second stage
        if let stageTwoName = self.currentBoard?.stage_two_name,
            let stageTwoImage = self.currentBoard?.stage_two_icon,
            let enabled = self.currentBoard?.stage_two, enabled == true
        {
            tabItems[1].title = stageTwoName
            tabItems[1].image = UIImage(named: stageTwoImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            tabItems[1].selectedImage = UIImage(named: stageTwoImage)
        } else if vc != nil {
            vc?.remove(at: 1)
        }
        
        // Set stage 3 tabbar elements; if not enabled remove second stage
        if let stageThreeName = self.currentBoard?.stage_three_name,
            let stageThreeImage = self.currentBoard?.stage_three_icon,
            let enabled = self.currentBoard?.stage_three, enabled == true
        {
            tabItems[2].title = stageThreeName
            tabItems[2].image = UIImage(named: stageThreeImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            tabItems[2].selectedImage = UIImage(named: stageThreeImage)
        } else if vc != nil {
            vc?.remove(at: 2)
        }
        
        return vc
    }
    
    func setPriorityBG(_ priority: Int) -> UIColor {
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
    
    func subtaskCompletion(_ storyIndex: Int) -> Float {
        var totalCount:Float = 0.0
        var completedSubtasks:Float = 0.0
        
        if storyIndex < self.allStories?.count {
            if let story = self.allStories?[storyIndex] {
                // Set default values for CoreData properties
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Subtasks")
                fetchRequest.predicate = NSPredicate(format: "story = %@", story)
                
                do {
                    if let result = try managedContext.fetch(fetchRequest) as? [Subtasks] {
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
        }
        return 0.0
    }
    
    func storyCompletion() -> Float {
        var totalCount:Float = 0.0
        var completedSubtasks:Float = 0.0
        
        for story in self.allStories! {
            let tasks = story.sub_tasks as! NSMutableSet
            
            for task in tasks {
                totalCount = totalCount + 1.0
                
                if String((task describing: as AnyObject).value(forKey: "completed")!) == "1" {
                    completedSubtasks = completedSubtasks + 1.0
                }
            }
        }
        
        return self.calculateCompletionPercentage(totalCount, completedSubtasks: completedSubtasks)
    }
    
    func boardCompletion() -> Float {
        var totalCount:Float = 0.0
        var completedSubtasks:Float = 0.0
        
        if self.allBoards?.count > 0 {
            for board in self.allBoards! {
                fetchStories(nil, _board: board)
                
                for story in self.allStories! {
                    let tasks = story.sub_tasks as! NSMutableSet
                    
                    for task in tasks {
                        totalCount += 1.0
                        
                        if String((task describing: as AnyObject).value(forKey: "completed")!) == "1" {
                            completedSubtasks += 1.0
                        }
                    }
                }
            }
        }
        
        return self.calculateCompletionPercentage(totalCount, completedSubtasks: completedSubtasks)
    }
    
    fileprivate func calculateCompletionPercentage(_ totalCount: Float, completedSubtasks: Float) -> Float {
        if totalCount == completedSubtasks && completedSubtasks != 0.0 {
            return 1.0
        } else if completedSubtasks == 0.0 {
            return 0.0
        }
        
        let totalComplete:Float = (1.0 / totalCount) * completedSubtasks
        
        return totalComplete
    }
}
