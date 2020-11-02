//
//  ViewController.swift
//  Notes
//
//  Created by Mathieu on 12/10/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit
import CoreData

// NSFetchedResultsControllerDelegate for using a NSFetchedResultsController instance to populate the table view of the notes view controller

class NotesViewController: UIViewController {
    
    // As we have a tableView, it's absolutly necessary to use the datasource as a variable and the delegate. You could set it up on the storyboard or in the code !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - Properties
    
    // instantiation of the Core Data manager in the view controller. It is no longer an optional
    
    private var coreDataManager = CoreDataManager(modelName: "Notes")
    
    
    // MARK: - Refactoring Notes View Controller
    
    // We use a NSFetchedResultsController instance to populate the table view of the notes view controller.
    
    // A lazy stored property is a property whose initial value is not calculated until the first time it is used. You indicate a lazy stored property by writing the lazy modifier before its declaration.
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        
        // Create Fetch Request
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        // Configure Fetch Request
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        
        // Create Fetched Results Controller
        
        // initialize the NSFetchedResultsController instance by invoking the designated initializer, init(fetchRequest:managedObjectContext:sectionNameKeyPath:cacheName:). The initializer defines four parameters: a fetch request, a managed object context, a key path for creating sections and a cache name for optimizing performance
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        
        // Setting its delegate to self, the view controller
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
    }()
    
    // Implementing a computed property by asking the fetched results controller for the value of its fetchedObjects property
    
    private var hasNotes: Bool {
        
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return false }
        
        return fetchedObjects.count > 0
    }
    
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Notes"
        
        // Fetching the notes from the persistent store by invoking another helper method, fetchNotes()
        
        fetchNotes()
                
        updateView()
        
        // Every managed object has an entity description, an instance of the NSEntityDescription class.
        
        // The entity description is accessible through the entity property of the managed object.
        
        // The entity description refers to a specific entity in the data model.
        
        // Need to use the managed object context as a proxy to access the managed object model cause we rarely, if ever, directly access the managed object model of the Core Data stack.
        
        if let entityDescription = NSEntityDescription.entity(forEntityName: "Note", in: coreDataManager.managedObjectContext) {
            
            // Print the entity name. It should be Note.
            
            print(entityDescription.name ?? "No Name")
            
            // Print the properties of the entity name.
            
            print(entityDescription.properties)
            
        }
    }
    
    // Notify the view controller its view was added to a view hierarchy
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        fetchNotes()
    }
    
    
    private func fetchNotes(){
        
        
        // Performing the fetched results controller
        
        // fetched results controller doesn’t perform a fetch if we don’t tell it to
        
        do{
            
            // Executing a perform fetch is a throwing operation, so use try
            
            try self.fetchedResultsController.performFetch()
            
        }catch{
            
            let fetchError = error as NSError
            
            print("Unable to Execute Fetch Request")
            
            print("\(fetchError), \(fetchError.localizedDescription)")
            
        }
    }
    
    // Using the value of the hasNotes property to update the user interface
    
    private func updateView(){
        
        tableView.isHidden = !hasNotes
        
        messageLabel.isHidden = hasNotes
        
        messageLabel.text = "you don't have any note yet"
        
    }
    
// MARK: - Segue

    // When the segue that leads to the add note view controller is about to be performed, we set the managedObjectContext property of the add note view controller.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        // Checked the identifier segue with a switch case
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            
            // Identifiant Segue
            
        case "AddNote":
            guard let destination = segue.destination as? AddNoteViewController else { return }
            
            // Configure Destination
            
            destination.managedObjectContext = coreDataManager.managedObjectContext
            
        case "UpdateNote":
            guard let destination = segue.destination as? NoteViewController else { return }
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            // Fetch Note
            
            let note = fetchedResultsController.object(at: indexPath)
            
            // Configure Destination
            
            destination.note = note
            
        default:
            break
        }
    }
}

// MARK: - Alerts

extension UIViewController {
        
    func showAlert(with title: String, and message: String){
        
        // Initialize Alert Controllert
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Configure Alert Controller
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present Alert Controller
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - TableView Data Source

extension NotesViewController: UITableViewDataSource {
    
    
    // A fetched results controller is perfectly capable of managing hierarchical data. That’s why it’s such a good fit for table and collection views. Even though we’re not splitting the notes up into sections, we can still ask the fetched results controller for the sections it manages.
    
    // Updating the implementation of the UITableViewDataSource protocol.
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let sections = fetchedResultsController.sections else { return 0 }
        
        return sections.count
        
    }
    
    // The numberOfObjects property tells us exactly how many managed object the section contains
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // The application returns the number of notes if it has notes to display, otherwise it returns 0
        
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        
        return section.numberOfObjects
        
    }
    
    // First fetching the note that corresponds with the value of the indexPath parameter.
    
    // Then dequeuing a note table view cell
    
    // And populating the table view cell with the data of the note.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue Reusable Cell
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as? NoteTableViewCell else {
            
            fatalError("Unexpected Index Path")
        }
        
        // Configure Cell by using helper method, configure(_:at:)
        
        configure(cell, at: indexPath)
        
        return cell
        
    }
    
    // For a deleting note we need to implement the method is tableView(_:commit:forRowAt:)
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Exiting early if the editingStyle's value isn't equal to delete
        
        guard editingStyle == .delete else { return }
        
        // Fetch Note
        
        let note = fetchedResultsController.object(at: indexPath)
        
        // Delete Note
        
        // To delete the managed object, we pass the note to the delete(_:) method of the managed object context to which the note belongs
        
        // The implementation also works if we use coreDataManager.managedObjectContext.delete(note)
        
        coreDataManager.managedObjectContext.delete(note)
    }
    
}

// MARK: - Fetched Results Controller Delegate

// The NSFetchedResultsControllerDelegate protocol defines four methods. We need to implement three of those

extension NotesViewController: NSFetchedResultsControllerDelegate {
    
    // This method is invoked when the fetched results controller starts processing one or more inserts, updates, or deletes.
    
    // Informing the table view that updates are on their way.
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // This method is invoked when the fetched results controller has finished processing the changes.
    
    // Notifying the table view that we won’t be sending it any more updates. This is important since multiple updates can occur in a very short time frame.
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
        
        // Invoking updateView because need to show the message label when the last note is deleted and to show the tableView when the first note is inserted.
        
        updateView()
    }
    
    // This method is invoked every time a managed object is modified
    
    // Type parameter can have four possible values: insert, delete, update and move
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
            
            // This method gives us the destination of the managed object that was inserted
            
        case .insert:
            
            // This destination is stored in the newIndexPath parameter
            
            if let indexPath = newIndexPath {
                
                // Unwrapping the value of newIndexPath and insert a row at the correct index path
                
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
            
        case .delete:
            
            // Index path of the deleted managed object is stored in the indexPath parameter
            
            if let indexPath = indexPath {
                
                // Unwrapping the value of indexPath and delete the corresponding row from the table view
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
            
        case .update:
            
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell {
                
                // Unwrapping the value of indexPath, fetch the table view cell that corresponds with the index path, and use the configure(_:at:) method to update the contents of the table view cell.
                
                configure(cell, at: indexPath)
            }
            
        case .move:
            
            // Value of the indexPath parameter represents the ORIGINAL position
            
            if let indexPath = indexPath {
                
                // Need to delete the row at the old position
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
            
            // Value of the newIndexPath parameter represents the NEW position
            
            if let indexPath = newIndexPath {
                
                // Need to insert the row at the new position
                
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
        @unknown default:
            fatalError("Undefined error")
            
        }
    }
    
    // For updates, need to fetch the table view cell that corresponds with the updated managed object and update its contents by using helper method, configure(_:at:)
    
    func configure(_ cell: NoteTableViewCell, at indexPath: IndexPath) {
        
        // Fetch Note
        
        let note = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        
        // utilisation of Note extension
        
        cell.titleLabel.text = note.title
        
        cell.contentsLabel.text = note.contents
        
        let dateFormatter = DateFormatter()
        
        cell.updatedAtLabel.text = dateFormatter.string(from: note.updatedAtAsDate)
        
    }
}
