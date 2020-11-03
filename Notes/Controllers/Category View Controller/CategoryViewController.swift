//
//  CategoryViewController.swift
//  Notes
//
//  Created by Mathieu on 31/10/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {
    
    @IBOutlet private weak var nameTextField: UITextField!
    
    var category: Category?
            
    override func viewDidLoad() {
        title = "Edit Category"
        
        super.viewDidLoad()
    }
    
    // Invoking two other helper methods
    private func setupView(){
        setupNameTextField()
    }
    
    private func setupNameTextField(){
        // Configure Title Text Field
        nameTextField.text = category?.name
    }
    
    // We don’t even need a save button. We simply update the note in the viewWillDisappear(_:)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Update Note
        if let name = nameTextField.text, !name.isEmpty{
            category?.name = name
        }
    }
    
}
