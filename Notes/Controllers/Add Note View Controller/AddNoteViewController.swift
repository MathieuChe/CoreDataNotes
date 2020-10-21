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
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    
    // MARK: -
    
    var managedObjectContext: NSManagedObjectContext?
    
    // Creating and populating a note when the user taps the Save button
    // But this save function doesn't push yet the Managed Object Context to the Persistent Store.
    @IBAction func save(_ sender: UIBarButtonItem) {
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
        
        // Pop View Controller
        _ = navigationController?.popViewController(animated: true)
    }
}

