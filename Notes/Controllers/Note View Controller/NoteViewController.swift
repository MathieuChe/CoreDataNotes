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
        
        setupNotificationHandling()
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
    
    // MARK: - Helper Methods
    
    private func setupNotificationHandling(){
        
        let notificationCenter = NotificationCenter.default
        
        // Adding the note view controller as an observer of the NSManagedObjectContextObjectsDidChange notification.
        // When the note view controller receives such a notification, the managedObjectContextObjectsDidChange(_:) method is invoked.
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: note?.managedObjectContext)
    }
    
    // MARK: - Notification Handling
    
    @objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
        
        // Making sure that the userInfo dictionary of the notification isn’t equal to nil
        guard let userInfo = notification.userInfo else { return }
        
        // Making sure that it contains a value for the NSUpdatedObjectsKey key
        guard let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> else { return }
        
        // Making sure the note of the note view controller is one of the managed objects that was updated by filtering the updates set of managed objects.
        // If the resulting set contains any managed objects, we invoke updateCategoryLabel()
        if (updates.filter { return $0 == note }).count > 0 {
            updateCategoryLabel()
        }
    }
    
    // Updating the category label
    private func updateCategoryLabel() {
        
        // Configure Category Label
        categoryLabel.text = note?.category?.name ?? "No Category"
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
