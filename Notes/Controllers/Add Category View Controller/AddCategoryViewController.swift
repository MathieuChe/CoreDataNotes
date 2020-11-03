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
    
    //MARK: - Life Cycle
    
    var note: Note?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    @IBAction func saveCategory(_ sender: UIBarButtonItem) {
        
        guard let managedObjectContext = self.note?.managedObjectContext else {return}
        
        // Create Category
        let category = Category(context: managedObjectContext)
        
        // Configure Category
            category.name = nameTextField.text
        
        // Do Catch because .save() is a throw method
        do {
            try managedObjectContext.save()
            
        } catch {
            print("Unable to Save Managed Object Context")
            print("\(error), \(error.localizedDescription)")
        }
        
        // Pop View Controller
        _ = navigationController?.popViewController(animated: true)
    }
}
