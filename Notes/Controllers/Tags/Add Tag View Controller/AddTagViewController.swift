//
//  AddTagViewController.swift
//  Notes
//
//  Created by Mathieu CHELIM on 04/11/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit
import CoreData

class AddTagViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet var nameTextField: UITextField!

    // MARK: -
    var managedObjectContext: NSManagedObjectContext?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Tag"

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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save(sender:)))
    }

    // MARK: - Actions
    func save(sender: UIBarButtonItem) {
        guard let managedObjectContext = managedObjectContext else { return }
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(with: "Name Missing", and: "Your tag doesn't have a name.")
            return
        }

        // Create Tag
        let tag = Tag(context: managedObjectContext)

        // Configure Tag
        tag.name = nameTextField.text

        // Pop View Controller
        _ = navigationController?.popViewController(animated: true)
    }
    
}
