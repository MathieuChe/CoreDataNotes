//
//  ViewController.swift
//  Notes
//
//  Created by Mathieu on 12/10/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    
    // MARK: - Properties
    // instantiation of the Core Data manager in the view controller. It is no longer an optional
    private var coreDataManager = CoreDataManager(modelName: "Notes")
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Every managed object has an entity description, an instance of the NSEntityDescription class.
        // The entity description is accessible through the entity property of the managed object.
        // The entity description refers to a specific entity in the data model.
        // Need to use the managed object context as a proxy to access the managed object model cause we rarely, if ever, directly access the managed object model of the Core Data stack.
        if let entityDescription = NSEntityDescription.entity(forEntityName: "Note", in: coreDataManager.managedObjectContext) {
            // Print the entity name
            print(entityDescription.name ?? "No Name")
            // Print the entity name
            print(entityDescription.properties)
            

            // Initialize Managed Object
            // the Note class knows what entity it is linked to, the initializer no longer requires an NSEntityDescription instance
            let note = NSManagedObject(entity: entityDescription, insertInto: coreDataManager.managedObjectContext)
            
            // Configure Managed Object
            // Before we can save the managed object to the persistent store, we need to set the required properties of the managed object
            note.setValue("My First Note", forKey: "title")
            note.setValue(NSDate(), forKey: "createdAt")
            note.setValue(NSDate(), forKey: "updatedAt")
            
            // Initialize Note
            // let note = Note(context: coreDataManager.managedObjectContext)
                        
            // Configure Note
            // Why are the properties optionals? When a managed object is created, the value of each property is set to nil.
            // note.title? = "My Second Note"
            // note.createdAt? = Date()
            // note.updatedAt? = Date()
                        
            print(note)
            
            // Pushing the managed object to the persistent store by saving the managed object context
            // Any changes we make to the managed object are only pushed to the persistent store if we save the managed object context the managed object belongs to
            // save() is a throwing method, we wrap it in a do-catch statement
            do {
                try coreDataManager.managedObjectContext.save()
            } catch {
                print("Unable to Save Managed Object Context")
                print("\(error), \(error.localizedDescription)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){}
}

