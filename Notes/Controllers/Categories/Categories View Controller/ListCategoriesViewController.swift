//
//  CategoriesViewController.swift
//  Notes
//
//  Created by Mathieu on 23/10/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit
import CoreData

// NSFetchedResultsControllerDelegate for using a NSFetchedResultsController instance to populate the table view of the categories view controller

class ListCategoriesViewController: UIViewController {
    
    // MARK: - Properties
    
    // As we have a tableView, it's absolutly necessary to use the datasource as a variable and the delegate. You could set it up on the storyboard or in the code !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    // Keep the segue identifier in a constant
    private let segueDetailsCategoryViewController = "UpdateCategory"
    private let segueAddCategoryViewController = "AddCategory"
    
    // MARK: - Properties
    
    // Private because properties are not accessible from other files
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: -
    
    //Estimate the RowHeight of the cell
    private let estimatedRowHeight = CGFloat(44.0)
    
    // instantiation of the Core Data manager in the view controller. It is no longer an optional
    
    private var coreDataManager = CoreDataManager(modelName: "Notes")
    
    // No longer need a property for the managed object context because we can access the managed object context through the note property
    
    var note: Note?
    
    // MARK: -
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
        
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
    
    private var hasCategory: Bool {
        
    guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return false }
        
        return fetchedObjects.count > 0
    }
    
    
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
        
        // Fetching the categories from the persistent store by invoking another helper method, fetchCategories()
        
        setupView()
        
        fetchCategories()
        
        updateView()
    
    }
    
    // Notify the view controller its view was added to a view hierarchy
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        fetchCategories()
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
            
        case segueDetailsCategoryViewController:
            
            guard let destinationViewController = segue.destination as? DetailsCategoryViewController else { return }
            
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
        
        setupTableView()
    }
    
    // Implementing a computed property by asking the fetched results controller for the value of its fetchedObjects property
    private func updateView() {
            
            tableView.isHidden = !hasCategory
            
            messageLabel.isHidden = hasCategory
            
    }
    
    // MARK: -
    
    private func setupMessageLabelText() {
        
        // Configure Message Label
        messageLabel.text = "No category yet"
        
    }
    
    // MARK: -

    // Setup the tableView
    private func setupTableView() {
        tableView.isHidden = true
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // Create a add bar navigation item button
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(sender:)))
    }
    
    // MARK: - Helper Methods
    
    private func fetchCategories(){
        
        
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
    
    // MARK: - Actions
    // After creating the add navigation bar item button, performSegue to AddCategoryViewController
    @objc func add(sender: UIBarButtonItem) {
        performSegue(withIdentifier: segueAddCategoryViewController, sender: self)
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate

extension ListCategoriesViewController: NSFetchedResultsControllerDelegate {
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


// MARK: - TableView Data Source


extension ListCategoriesViewController: UITableViewDataSource {
    
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
    
    // First fetching the category that corresponds with the value of the indexPath parameter.
    
    // Then dequeuing a category table view cell
    
    // And populating the table view cell with the data of the category.
    
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
        
        // Fetch Category
        
        let category = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        
        // utilisation of Category extension
        
        cell.nameCategoryLabel.text = category.name
        
        if note?.category == category {
            
            cell.nameCategoryLabel.textColor = .bitterSweet()
            
        }else{
            
            cell.nameCategoryLabel.textColor = .white
            
        }
    }
    
    // For a deleting note we need to implement the method is tableView(_:commit:forRowAt:)
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Exiting early if the editingStyle's value isn't equal to delete
        
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

extension ListCategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselect the row after touching up
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Fetch Category
        let currentCategory = fetchedResultsController.object(at: indexPath)
        
        // Update Note
        note?.category = currentCategory
        
        
        // Pop View Controller From Navigation Stack
        let _ = navigationController?.popViewController(animated: true)
        
    }
}




