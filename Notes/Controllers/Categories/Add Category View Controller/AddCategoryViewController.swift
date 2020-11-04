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
    
    @IBOutlet private weak var nameTextField: UITextField!
    
    // MARK: -
    var managedObjectContext: NSManagedObjectContext?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Add Category"
        
        setupView()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Show Keyboard
        nameTextField.becomeFirstResponder()
    }
    
    // MARK: - View Methods
    fileprivate func setupView() {
        setupBarButtonItems()
    }
    
    // MARK: -
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveCategory(sender:)))
    }
    
    
    // MARK: - Actions
    
    @objc func saveCategory(sender: UIBarButtonItem) {
        
        //Get the managedObjectContext from note
        guard let managedObjectContext = managedObjectContext else {return}
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(with: "Name Missing", and: "Your category doesn't have a name.")
            return
        }
        
        // Create Category
        let category = Category(context: managedObjectContext)
        
        // Configure Category
        category.name = nameTextField.text
        
        // Pop View Controller
        _ = navigationController?.popViewController(animated: true)
    }
}
