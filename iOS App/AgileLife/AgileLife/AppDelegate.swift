//
//  AppDelegate.swift
//  AgileLife
//
//  Created by Zachary Gover on 4/11/16.
//  Copyright © 2016 Full Sail University. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        // Navbar button colors
        navigationBarAppearace.tintColor = UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1)
        
        // Navbar background color
        navigationBarAppearace.barTintColor = UIColor(red: 36/255, green: 103/255, blue: 101/255, alpha: 1)
        
        // Navbar title color, font and size
        navigationBarAppearace.titleTextAttributes = [
            NSForegroundColorAttributeName:UIColor.white,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20.0)
        ]
        
        // Status bar text color
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

        if readPlist("Settings", key: "firstTimeOpening") as! NSObject == true {
            let CoreModels = CoreDataModels()
            
            CoreModels.createBoard("Recipes", stage_one_icon: "folder", stage_one_name: "All Recipes", stage_two: true, stage_two_icon: "folder-open", stage_two_name: "Grocery List", stage_three: true, stage_three_icon: "cart", stage_three_name: "In Cart")
            
            CoreModels.createStory("Recipe 1", notes: "These are sample notes...", stage: "All Recipes", priority: 1)
            CoreModels.createSubtask("Ingredient 1", deadline: Date(), description: "This is a sample description...")
            CoreModels.currentSubtask?.completed = true
            CoreModels.createSubtask("Ingredient 2", deadline: Date(), description: "This is a sample description...")
            CoreModels.currentSubtask?.completed = true
            CoreModels.createSubtask("Ingredient 3", deadline: Date(), description: "This is a sample description...")
            CoreModels.currentSubtask?.completed = true
            CoreModels.createSubtask("Ingredient 4", deadline: Date(), description: "This is a sample description...")
            CoreModels.currentSubtask?.completed = true
            
            CoreModels.createStory("Recipe 2", notes: "These are sample notes...", stage: "All Recipes", priority: 2)
            CoreModels.createSubtask("Ingredient 1", deadline: Date(), description: "This is a sample description...")
            CoreModels.currentSubtask?.completed = true
            CoreModels.createSubtask("Ingredient 2", deadline: Date(), description: "This is a sample description...")
            CoreModels.currentSubtask?.completed = true
            CoreModels.createSubtask("Ingredient 3", deadline: Date(), description: "This is a sample description...")
            CoreModels.currentSubtask?.completed = true
            CoreModels.createSubtask("Ingredient 4", deadline: Date(), description: "This is a sample description...")
            CoreModels.currentSubtask?.completed = false
            
            CoreModels.createStory("Recipe 3", notes: "These are sample notes...", stage: "All Recipes", priority: 3)
            CoreModels.createSubtask("Ingredient 1", deadline: Date(), description: "This is a sample description...")
            CoreModels.currentSubtask?.completed = true
            CoreModels.createSubtask("Ingredient 2", deadline: Date(), description: "This is a sample description...")
            CoreModels.currentSubtask?.completed = true
            CoreModels.createSubtask("Ingredient 3", deadline: Date(), description: "This is a sample description...")
            CoreModels.currentSubtask?.completed = false
            CoreModels.createSubtask("Ingredient 4", deadline: Date(), description: "This is a sample description...")
            CoreModels.currentSubtask?.completed = false
            
            CoreModels.createStory("Recipe 4", notes: "These are sample notes...", stage: "All Recipes", priority: 4)
            CoreModels.createSubtask("Ingredient 1", deadline: Date(), description: "This is a sample description...")
            CoreModels.currentSubtask?.completed = true
            CoreModels.createSubtask("Ingredient 2", deadline: Date(), description: "This is a sample description...")
            CoreModels.currentSubtask?.completed = false
            CoreModels.createSubtask("Ingredient 3", deadline: Date(), description: "This is a sample description...")
            CoreModels.currentSubtask?.completed = false
            CoreModels.createSubtask("Ingredient 4", deadline: Date(), description: "This is a sample description...")
            CoreModels.currentSubtask?.completed = false
            
            writePlist("Settings", key: "firstTimeOpening", data: false as AnyObject)
        }
        
        Fabric.with([Crashlytics.self])
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.fullsail.zacharygover.AgileLife" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "AgileLife", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                //abort()
            }
        }
    }
    
    func readPlist(_ namePlist: String, key: String) -> AnyObject{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(namePlist + ".plist")
        
        var output:AnyObject = false as AnyObject
        
        if let dict = NSMutableDictionary(contentsOfFile: path) {
            output = dict.object(forKey: key)! as AnyObject
        } else {
            if let privPath = Bundle.main.path(forResource: namePlist, ofType: "plist") {
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    output = dict.object(forKey: key)! as AnyObject
                } else {
                    output = false as AnyObject
                    print("error_read")
                }
            } else {
                output = false as AnyObject
                print("error_read")
            }
        }
        return output
    }
    
    func writePlist(_ namePlist: String, key: String, data: AnyObject) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(namePlist + ".plist")
        
        if let dict = NSMutableDictionary(contentsOfFile: path) {
            dict.setObject(data, forKey: key as NSCopying)
            if dict.write(toFile: path, atomically: true){
                print("plist_write")
            } else {
                print("plist_write_error")
            }
        } else {
            if let privPath = Bundle.main.path(forResource: namePlist, ofType: "plist") {
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    dict.setObject(data, forKey: key as NSCopying)
                    if dict.write(toFile: path, atomically: true) {
                        print("plist_write")
                    } else {
                        print("plist_write_error")
                    }
                } else {
                    print("plist_write")
                }
            } else {
                print("error_find_plist")
            }
        }
    }
}

