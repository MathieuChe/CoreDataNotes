//
//  NoteViewController.swift
//  Notes
//
//  Created by Mathieu on 19/10/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit
import CoreData


// To update the note view controller
class NoteViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var contentsTextView: UITextView!
    @IBOutlet private weak var categoryLabel: UILabel!
    
    // MARK: - Life Cycle
    // Every stored property of a class or struct needs to have a valid value by the time the instance is created. This leaves us no option but to use an optional
    var note: Note?
    
    override func viewDidLoad() {
        title = "Edit Note"
        
        setupView()
        
        updateCategoryLabelText()
    }
    
    private func updateCategoryLabelText(){
        categoryLabel.text = "No category yet"
    }
    
    // Invoking two other helper methods
    private func setupView(){
        setupTitleTextField()
        setupContentsTextView()
    }
    
    private func setupTitleTextField(){
        // Configure Title Text Field
        titleTextField.text = note?.title
    }
    
    private func setupContentsTextView(){
        // Configure Contents Text View
        contentsTextView.text = note?.contents
    }
    
    // We don’t even need a save button. We simply update the note in the viewWillDisappear(_:)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Update Note
        if let title = titleTextField.text, !title.isEmpty{
            note?.title = title
        }
        note?.updatedAt = Date()
        note?.contents = contentsTextView.text
    }
    
    // IBAction to performSegue to Storyboard Reference
    @IBAction func editButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "NoteToCategories", sender: self)
    }
}
