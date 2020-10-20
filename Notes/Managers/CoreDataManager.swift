//
//  CoreDataManager.swift
//  Notes
//
//  Created by Mathieu on 12/10/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

// Import UIKit to use the UIApplication singleton
import UIKit
import CoreData

// Using final because it's not intended to be subclassed.
final class CoreDataManager {
    
    // MARK: - Properties
    // private let is accessible outside the  class. And modelName refer to the name of the data model
    private let modelName: String
    
    // MARK: - Initialization
    // Init with the name of the data model as an argument
    init(modelName: String) {
        self.modelName = modelName
        
        // Invoking a helper method setupNotificationHandling() in the initializer
        setupNotificationHandling()
    }
    
    // MARK: - Saving during background or terminate
    
    // Adding the Core Data manager instance in setupNotificationHandling(), as an observer of two notifications sent by the UIApplication singleton: UIApplicationWillTerminate and UIApplicationDidEnterBackground
    private func setupNotificationHandling(){
        let notificationCenter = NotificationCenter.default
        
        // By importing the UIKit we can use the notification. NB: Using UIApplication.willTerminateNotification instead of Notification.Name.UIApplicationWillTerminate
        notificationCenter.addObserver(self, selector: #selector(saveChanges(_ :)), name: UIApplication.willTerminateNotification, object: nil)
        // NB: Using UIApplication.didEnterBackgroundNotification instead of Notification.Name.UIApplicationDidEnterBackground
        notificationCenter.addObserver(self, selector: #selector(saveChanges(_ :)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    // When the Core Data manager receives one of these notifications, the saveChanges(_:) method is invoked. In this method, we invoke another helper method, saveChanges().
    @objc func saveChanges(_ notification: Notification){
        saveChanges()
    }
    
    // The save operation takes place in the saveChanges() method
    private func saveChanges() {
        //  First asking the managed object context by using the value of its hasChanges property. Then if it has changes we need to push to the persistent store.
        guard managedObjectContext.hasChanges else { return }
        
        // Pushing if the managed object context has changes by invoking save() on the managed object context in a do-catch statement. Remember that save() is a throwing method.
        do {
            try managedObjectContext.save()
        } catch {
            // It isn’t useful to notify the user if the save operation failed. However, that doesn’t mean that you can ignore any errors that are thrown when something goes wrong. It’s recommended to notify the user at some point that a problem occurred.
            print("Unable to Save Managed Object Context")
            print("\(error), \(error.localizedDescription)")
        }
    }
    
    // MARK: - Core Data Stack
    // private(set) lazy var stops anything outside of the file from changing the value, while the class itself still has the power to modify it.
    // A lazy stored property is a property whose initial value is not calculated until the first time it is used. Only used with var cause its initial value might not be retrieved until after instance initialization completes.
    private(set) lazy var managedObjectContext : NSManagedObjectContext = {
        
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        // Configure Managed Object Context
        // Every parent managed object context keeps a reference to the persistent store coordinator of the Core Data stack so need to set the persistentStoreCoordinator property of the managed object context.
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    // The managed object model loads the data model from the application bundle. The code responsible for this lives in the closure of the managedObjectModel property of the CoreDataManager class
    private lazy var managedObjectModel: NSManagedObjectModel = {
        
        // Fetch Model URL
        // Asking the application bundle for the URL of the data model
        //The file that’s loaded from the application bundle is named Notes and has an momd extension. The extension stands for managed object model document. This is the compiled version of the data model. 
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to find Data Model")
        }
        
        // Initialize Managed Object Model
        // Using the URL to instantiate an instance of the NSManagedObjectModel class
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
       
// NB: We use fatalError() cause if the data model isn’t present in the application bundle or the application is unable to load the data model from the application bundle, we have bigger problems to worry about. this should never happen in production.
    }()
    
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        // Initialize Persistent Store Coordinator
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        // Helpers
        // A file manager object lets you examine the contents of the file system and make changes to it.
        let fileManager = FileManager.default
        // Appending sqlite to the name of the data model because we’re going to use a SQLite database as the persistent store
        let storeName = "\(self.modelName).sqlite"
        
        // URL Documents Directory
        //In this example, we store the persistent store in the Documents directory of the application’s sandbox. But we could also store it in the Library directory
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // URL Persistent Store
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        // Adding a persistent store is an operation that can fail, we need to perform it in a do-catch statement
        do {
            // Add Persistent Store
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            // First parameter the type of the persistent store, SQLite in this example
            // Second parameter the configuration
            // Fourth parameter the options dictionary
            //If the persistent store coordinator cannot find a persistent store at the location we specified, it creates one for us. If a persistent store already exists at the specified location, it’s added to the persistent store coordinator. This means that the persistent store is automatically created the first time a user launches your application. The second time, Core Data looks for the persistent store, finds it at the specified location, and adds it to the persistent store coordinator.
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: options)
        } catch {
            fatalError("Unable to Add Persistent Store")
        }
        return persistentStoreCoordinator
    }()
}
