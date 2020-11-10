//
//  TagViewController.swift
//  Notes
//
//  Created by Mathieu CHELIM on 04/11/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit

class DetailsTagViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: -
    var tag: Tag?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Tag"

        setupView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Update Tag
        if let name = nameTextField.text, !name.isEmpty {
            tag?.name = name
        }
    }

    // MARK: - View Methods
    fileprivate func setupView() {
        setupNameTextField()
    }

    // MARK: -
    private func setupNameTextField() {
        // Configure Name Text Field
        nameTextField.text = tag?.name
    }

}
