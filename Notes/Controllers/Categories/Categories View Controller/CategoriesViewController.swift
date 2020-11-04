//
//  CategoriesViewController.swift
//  Notes
//
//  Created by Mathieu on 23/10/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController {
    
    // MARK: - Properties
    
    // As we have a tableView, it's absolutly necessary to use the datasource as a variable and the delegate. You could set it up on the storyboard or in the code !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    // Keep the segue identifier in a constant
    private let segueCategoryViewController = "UpdateCategory"
    private let segueAddCategoryViewController = "AddCategory"
    
    // MARK: - Properties
    
    // Private because properties are not accessible from other files
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: -
    
    // No longer need a property for the managed object context because we can access the managed object context through the note property
    
    var note: Note?
    
    // MARK: -
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
        
        // Access the managed object context through the note property
        
        guard let managedObjectContext = self.note?.managedObjectContext else {
            
            fatalError("No Managed Object Context Found")
            
        }
        
        // Create Fetch Request
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        // Configure Fetch Request
        // Order category by alphabetic
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // Create Fetched Results Controller
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
    } ()
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Name the title navigation bar
        
        title = "Categories"
        
        setupView()
        
        // Perform Fetch of the Fetched Results Controller. As performFetch() is a throw method, use the do-catch
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        updateView()
    }
    
    
    // MARK: - Navigation
    
    // When the segue that leads to the add note view controller is about to be performed, we set the managedObjectContext property of the add note view controller.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        // Checked the identifier segue with a switch case
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        
        // Identifiant Segue
        
        case segueAddCategoryViewController:
            
            guard let destinationViewController = segue.destination as? AddCategoryViewController else { return }
            
            // Configure Destination View Controller
            destinationViewController.managedObjectContext = note?.managedObjectContext
            
        case segueCategoryViewController:
            
            guard let destinationViewController = segue.destination as? CategoryViewController else { return }
            
            //Define the cell from CategoryTableViewCell
            guard let cell = sender as? CategoryTableViewCell else { return }
            
            //Define the indexPath
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            // Fetch Category
            let currentCategory = fetchedResultsController.object(at: indexPath)
            
            // Configure Destination
            destinationViewController.category = currentCategory
            
        default:
            break
        }
    }
    
    //MARK: - View Methods
    
    fileprivate func setupView(){
        setupMessageLabelText()
        setupBarButtonItems()
    }
    
    // Implementing a computed property by asking the fetched results controller for the value of its fetchedObjects property
    fileprivate func updateView() {
        var hasCategory: Bool = false
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
            
            tableView.isHidden = !hasCategory
            messageLabel.isHidden = hasCategory
            
            return
        }
        hasCategory = fetchedObjects.count > 0
    }
    
    // MARK: -
    
    private func setupMessageLabelText() {
        
        // Configure Message Label
        messageLabel.text = "No category yet"
        
    }
    
    // MARK: -
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(sender:)))
    }
    
    // MARK: - Actions
    
    @objc func add(sender: UIBarButtonItem) {
        performSegue(withIdentifier: segueAddCategoryViewController, sender: self)
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate

extension CategoriesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        updateView()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell {
                configure(cell, at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        @unknown default:
            fatalError("Undefined error")
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
    // For updates, need to fetch the table view cell that corresponds with the updated managed object and update its contents by using helper method, configure(_:at:)

    func configure(_ cell: CategoryTableViewCell, at indexPath: IndexPath) {
        
        // Fetch Note
        
        let category = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        
        // utilisation of Note extension
        
        cell.nameLabel.text = category.name
        
        if note?.category == category {
            
            cell.nameLabel.textColor = .bitterSweet()
            
        }else{
            
            cell.nameLabel.textColor = .black
            
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        // Fetch Category
        
        let currentCategory = fetchedResultsController.object(at: indexPath)
        
        // Delete Category
        
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
        let currentCategory = fetchedResultsController.object(at: indexPath)
        
        // Update Note
        note?.category = currentCategory
        
        
        // Pop View Controller From Navigation Stack
        let _ = navigationController?.popViewController(animated: true)
        
    }
}




