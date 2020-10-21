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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - Properties
    // instantiation of the Core Data manager in the view controller. It is no longer an optional
    private var coreDataManager = CoreDataManager(modelName: "Notes")
    
    // Declaring a property for storing the notes which are going to be fetched from the persistent store.
    private var notes: [Note]? {
        // Defining a property observer because we want to update the user interface every time the value of the notes property changes
        didSet {
            // Invoking a helper method, updateView()
            updateView()
        }
    }
    
    // Implementing a computed property that tells us if we have notes to display
    private var hasNotes: Bool {
        guard let notes = notes else { return false }
        return notes.count > 0
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
//        setupView()
        
        // Fetching the notes from the persistent store by invoking another helper method, fetchNotes()
        fetchNotes()
        
        setupNotificationHandling()
        
        // Every managed object has an entity description, an instance of the NSEntityDescription class.
        // The entity description is accessible through the entity property of the managed object.
        // The entity description refers to a specific entity in the data model.
        // Need to use the managed object context as a proxy to access the managed object model cause we rarely, if ever, directly access the managed object model of the Core Data stack.
        if let entityDescription = NSEntityDescription.entity(forEntityName: "Note", in: coreDataManager.managedObjectContext) {
            // Print the entity name. It should be Note.
            print(entityDescription.name ?? "No Name")
            // Print the properties of the entity name.
            print(entityDescription.properties)
            

            // Initialize Managed Object
            // the Note class knows what entity it is linked to, the initializer no longer requires an NSEntityDescription instance
//            let note = NSManagedObject(entity: entityDescription, insertInto: coreDataManager.managedObjectContext)
            
            // Configure Managed Object
            // Before we can save the managed object to the persistent store, we need to set the required properties of the managed object
//            note.setValue("My First Note", forKey: "title")
//            note.setValue(NSDate(), forKey: "createdAt")
//            note.setValue(NSDate(), forKey: "updatedAt")
            
            // Initialize Note
            // It's possible cause in the .xcdatamodeld file, Note entity has its Codegen set up at Class Definition. It means entity became automatically a class
            let note = Note(context: coreDataManager.managedObjectContext)
                        
            // Configure Note
            // Why are the properties optionals? When a managed object is created, the value of each property is set to nil.
            // But it's really important to not add the interrogation mark because the value of each property will be set to nil and we do not want cause those properties are required. Do not forget optional boxes have been unchecked for the properties. Otherwise no save !!
            note.title = "My Second Note"
            note.createdAt = Date()
            note.updatedAt = Date()
                        
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
    
    private func fetchNotes(){
        // First ingredient need is a fetch request.
        // Creating Fetch Request <ResultType>
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        // Configure Fetch Request
        // The sortDescriptors property is an array, which means we could specify multiple sort descriptors. The sort descriptors are evaluated based on the order in which they appear in the array.
        // keypaths are a way of storing uninvoked references to properties, which is a fancy way of saying they refer to a property itself rather than to that property's value.
        // Want to show the most recently updated note at the top of the table view
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false)]
        
        // Perform Fetch Data
        // Never directly access the persistent store. Executing the fetch request using the MOC of the CD manager
        // Invoking the fetch request in the closure of the performAndWait(_:) method, we access the managed object context on the thread it’s associated with. This method is executed synchronously hence the wait keyword in the method name.
        coreDataManager.managedObjectContext.performAndWait {
            // Executing a fetch request is a throwing operation, which is why we wrap it in a do-catch statement
            do {
                // Execute Fetch Request
                // // Executing a fetch request is a throwing operation, so use try
                let notes = try fetchRequest.execute()
                
                // Update Notes
                // self cause notes refer to the property of NotesViewController class
                self.notes = notes
                
                // Reload Table View
                self.tableView.reloadData()
                
            }catch{
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
                    
            }
        }
    }
    
    // Using the value of the hasNotes property to update the user interface
    private func updateView(){
        tableView.isHidden = !hasNotes
        messageLabel.isHidden = hasNotes
    }
    
    private func setupNotificationHandling(){
        let notificationCenter = NotificationCenter.default
        // If you’re developing an application that uses multiple managed object contexts, you need to make sure you only observe the managed object context the object is interested in. This is very important, not only from a performance perspective, but also in the context of threading.
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange(_:)),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: coreDataManager.managedObjectContext)
    }
    
    // MARK: - Notification Handling
    
    @objc private func managedObjectContextObjectsDidChange(_ notification: Notification){
        guard let userInfo = notification.userInfo else { return }
        
        // Helpers
        var notesDidChange = false
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            for insert in inserts {
                if let note = insert as? Note {
                    notes?.append(note)
                    notesDidChange = true
                }
            }
        }
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            for update in updates {
                if let _ = update as? Note {
                    notesDidChange = true
                }
            }
        }
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            for delete in deletes {
                if let note = delete as? Note {
                    if let index = notes?.firstIndex(of: note) {
                        notes?.remove(at: index)
                        notesDidChange = true
                    }
                }
            }
        }
        if notesDidChange {
            // Sort Notes
            notes?.sort(by: {$0.updatedAtAsDate > $1.updatedAtAsDate})
            // Update Table View
            tableView.reloadData()
            
            // Update View
            updateView()
            }
        }
    
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
            guard let indexPath = tableView.indexPathForSelectedRow, let note = notes?[indexPath.row] else { return }
            
            // Configure Destination
            destination.note = note
            
        default:
            break
        }
    }
}

extension UIViewController {
    // MARK: - Alerts
    func showAlert(with title: String, and message: String){
        // Initialize Alert Controllert
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Configure Alert Controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // Present Alert Controller
        present(alertController, animated: true, completion: nil)
    }
}

extension NotesViewController: UITableViewDataSource {
    // MARK: - TableView Data Source
    
    // Updating the implementation of the UITableViewDataSource protocol.
    func numberOfSections(in tableView: UITableView) -> Int {
        // The application returns 1 if it has notes, otherwise it returns 0
        return hasNotes ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // The application returns the number of notes if it has notes to display, otherwise it returns 0
        guard let notes = notes else { return 0 }
        return notes.count
    }
    
    // First fetching the note that corresponds with the value of the indexPath parameter.
    // Then dequeuing a note table view cell
    // And populating the table view cell with the data of the note.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Fetch Note
        guard let note = notes?[indexPath.row] else {
            fatalError("Unexpected Index Path")
        }
        
        // Dequeue Reusable Cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as? NoteTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        // Configure Cell
        cell.titleLabel.text = note.title
        cell.contentsLabel.text = note.contents
        let dateFormatter = DateFormatter()
        // utilisation of Note extension
        cell.updatedAtLabel.text = dateFormatter.string(from: note.updatedAtAsDate)
        return cell
    }
    
    // For a deleting note we need to implement the method is tableView(_:commit:forRowAt:)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Exiting early if the editingStyle's value isn't equal to delete
        guard editingStyle == .delete else { return }
        // Fetch Note
        guard let note = notes?[indexPath.row] else { fatalError("Unexpected Index Path") }
        // Delete Note
        // To delete the managed object, we pass the note to the delete(_:) method of the managed object context to which the note belongs
        // The implementation also works if we use coreDataManager.managedObjectContext.delete(note)
        note.managedObjectContext?.delete(note)
    }
}


