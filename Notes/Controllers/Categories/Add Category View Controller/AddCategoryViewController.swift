//
//  AddCategoryViewController.swift
//  Notes
//
//  Created by Mathieu on 23/10/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit
import CoreData

class AddCategoryViewController: UIViewController {
    
    
    // MARK: - Properties

    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: -
    var managedObjectContext: NSManagedObjectContext?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Add Category"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // Show Keyboard
        nameTextField.becomeFirstResponder()
    }
    
    
    // MARK: - Actions
    
    // Creating and populating a category when the user taps the saveCategory button
    // But this saveCategory function doesn't push yet the Managed Object Context to the Persistent Store.
    @IBAction func saveCategory(_ sender: UIBarButtonItem) {
        //Get the managedObjectContext from note
        guard let managedObjectContext = managedObjectContext else {return}
        // Making sure the title text field isn’t empty. Remember that the name property of the Category entity is not a required property. It can be empty but we don't want.
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(with: "Name Missing", and: "Your category doesn't have a name.")
            return
        }
        
        // Create Category
        let category = Category(context: managedObjectContext)
        
        // Configure Category
        category.name = nameTextField.text
        
        // I need to use the do catch in the AddNoteViewController if I want to save
        // Pushing if the managed object context has changes by invoking save() on the managed object context in a do-catch statement. Remember that save() is a throwing method.
        do {
            try managedObjectContext.save()
        } catch {
            // It isn’t useful to notify the user if the save operation failed. However, that doesn’t mean that you can ignore any errors that are thrown when something goes wrong. It’s recommended to notify the user at some point that a problem occurred.
            print("Unable to Save Managed Object Context")
            print("\(error), \(error.localizedDescription)")
        }
        
        // Pop View Controller
        _ = navigationController?.popViewController(animated: true)
    }
        
}
