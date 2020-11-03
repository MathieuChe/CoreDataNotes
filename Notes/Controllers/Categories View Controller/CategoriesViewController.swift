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
    
    // MARK: - Properties
    
    // Private because properties are not accessible from other files
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: -
    
    // No longer need a property for the managed object context because we can access the managed object context through the note property
    
    var note: Note?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        updatedMessageLabelText()
    }
    
    private func updatedMessageLabelText() {
        
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
    
    // For updates, need to fetch the table view cell that corresponds with the updated managed object and update its contents by using helper method, configure(_:at:)
    
    func configure(_ cell: CategoryTableViewCell, at indexPath: IndexPath) {
        
        // Fetch Note
        
        let category = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        
        // utilisation of Note extension
        
        cell.nameLabel.text = category.name
        
        if note?.category == category {
            
            cell.nameLabel.textColor = .yellow
            
        }else{
            
            cell.nameLabel.textColor = .black
            
        }
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
            
            destination.note = note
            
        case "UpdateCategory":
            
            guard let destination = segue.destination as? CategoryViewController else { return }
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            // Fetch Note
            
            let currentCategory = fetchedResultsController.object(at: indexPath)
            
        // Configure Destination
        
        
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource


extension CategoriesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let sections = fetchedResultsController.sections else { return 0 }
        
        return sections.count
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // The application returns the number of notes if it has notes to display, otherwise it returns 0
        
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue Reusable Cell
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath) as? CategoryTableViewCell else {
            
            fatalError("Unexpected Index Path")
        }
        
        // Configure Cell by using helper method, configure(_:at:)
        
        configure(cell, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        // Fetch Note
        
        let currentCategory = fetchedResultsController.object(at: indexPath)
        
        // Delete Note
        
        // To delete the managed object, we pass the note to the delete(_:) method of the managed object context to which the note belongs
        
        // Delete Category
        note?.managedObjectContext?.delete(currentCategory)
    }
}

// MARK: - UITableViewDelegate

extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Fetch Category
        let category = fetchedResultsController.object(at: indexPath)
        
        // Update Note
        note?.category = category
        
        
        // Pop View Controller From Navigation Stack
        let _ = navigationController?.popViewController(animated: true)
        
    }
}




