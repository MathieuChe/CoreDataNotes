//
//  AddViewController.swift
//  Notes
//
//  Created by Mathieu on 14/10/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController {
    
    
    
    // MARK: - Properties
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var contentsTextView: UITextView!
    
    // MARK: -
    
    var managedObjectContext: NSManagedObjectContext?
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Note"
        
        //Define the contentsView's borders
        contentsTextView.layer.borderColor = UIColor.black.cgColor
        contentsTextView.layer.borderWidth = 1
        contentsTextView.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // Show Keyboard
        titleTextField.becomeFirstResponder()
    }
    
    // MARK: - Actions

    // Creating and populating a note when the user taps the saveNote button
    // But this saveNote function doesn't push yet the Managed Object Context to the Persistent Store.
    @IBAction func saveNote(_ sender: UIBarButtonItem) {
        guard let managedObjectContext = managedObjectContext else { return }
        // Making sure the title text field isn’t empty. Remember that the title property of the Note entity is a required property. It can’t be empty.
        guard let title = titleTextField.text, !title.isEmpty else {
            // If the title text field is empty we show an alert to the user by invoking a helper method, showAlert(with:and:)
            showAlert(with: "Title Missing", and: "Your note doesn't have a title.")
            return
        }
        // Create Note
        let note = Note(context: managedObjectContext)
        
        // Configure Note
        note.createdAt = Date()
        note.updatedAt = Date()
        note.title = titleTextField.text
        note.contents = contentsTextView.text
        
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
