//
//  CategoriesViewController.swift
//  Notes
//
//  Created by Mathieu on 23/10/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController, NSFetchedResultsControllerDelegate {
   
    // MARK: - Properties
    
    // As we have a tableView, it's absolutly necessary to use the datasource as a variable and the delegate. You could set it up on the storyboard or in the code !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    private var coreDataManager = CoreDataManager(modelName: "Notes")
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -
    
    // No longer need a property for the managed object context because we can access the managed object context through the note property
    
    var note: Note?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        updated()
//
//        // Initialize the entities from Category
//        if let entityDescription = NSEntityDescription.entity(forEntityName: "Category", in: coreDataManager.managedObjectContext) {
//
//            // Print the entity name. It should be Note.
//
//            print(entityDescription.name ?? "No Name")
//
//            // Print the properties of the entity name.
//
//            print(entityDescription.properties)
//
//            // Initiatilize the Managed Object
//            let category = NSManagedObject(entity: entityDescription, insertInto: coreDataManager.managedObjectContext)
//
//            print(category)
//
//            category.setValue("My First Category", forKey: "name")
//
//            do {
//                try coreDataManager.managedObjectContext.save()
//            }catch{
//                print("Unable to save the category")
//                print("\(error), \(error.localizedDescription)")
//            }
//
//        }
        
    }
    
    private func updated() {
        
        messageLabel.text = "No category yet"
        
    }
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
        
        // Access the managed object context through the note property
        
        guard let managedObjectContext = self.note?.managedObjectContext else {
            
            fatalError("No Managed Object Context Found")
    
        }
        
        // Create Fetch Request
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        // Configure Fetch Request
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        
        return fetchedResultsController
                
    } ()
    
    // Implementing a computed property by asking the fetched results controller for the value of its fetchedObjects property
    
    private var hasCategory: Bool {
        
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return false }
        
        return fetchedObjects.count > 0
    }
    
    // MARK: - Segue

    // When the segue that leads to the add note view controller is about to be performed, we set the managedObjectContext property of the add note view controller.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        // Checked the identifier segue with a switch case
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            
            // Identifiant Segue
            
        case "AddCategory":
            
            guard let destination = segue.destination as? AddCategoryViewController else { return }
            
            // Configure Destination
            
//            destination.managedObjectContext = note?.managedObjectContext
            
            
        case "UpdateCategory":
            
            guard let destination = segue.destination as? CategoryViewController else { return }
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            // Fetch Note
            
            let note = fetchedResultsController.object(at: indexPath)
            
            // Configure Destination
            
            
        default:
            break
        }
    }
    
    
}
