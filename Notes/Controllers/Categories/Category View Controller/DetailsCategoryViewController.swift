//
//  CategoryViewController.swift
//  Notes
//
//  Created by Mathieu on 31/10/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit
import CoreData

class DetailsCategoryViewController: UIViewController {
    
    // MARK: - Properties
    
    let segueColorViewController = "CategoryToColor"
    
    // MARK: -
    
    
    @IBOutlet private weak var changeColorButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    
    // MARK: -
    var category: Category?
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Edit Category"
        
        setupView()
    }
    
    // We don’t even need a save button. We simply update the note in the viewWillDisappear(_:)
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        // Update Category
        if let name = nameTextField.text, !name.isEmpty{
            
            category?.name = name
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard segue.identifier == segueColorViewController else { return }

            if let destinationViewController = segue.destination as? ColorViewController {
                // Configure Destination View Controller
                destinationViewController.delegate = self
                destinationViewController.color = category?.color ?? .white
            }
        }
    
    // MARK: - View Methods
    // Invoking two other helper methods
    fileprivate func setupView(){
        setupColorView()
        setupNameTextField()
//        setupBarButtonItems()
    }
    
    
    // MARK: -
    private func setupColorView() {
            // Configure Layer Color View
//        changeColorButton.layer.cornerRadius = changeColorButton.frame.height/2
        // 8.0 CGFloat afin de differencier les float et int
        changeColorButton.layer.cornerRadius = 8.0
        //properties resign (la vue ne sortira pas des limites imposées).
        changeColorButton.layer.masksToBounds = true
        
        

            updateColorView()
        }
    
    fileprivate func updateColorView() {
            // Configure Color View
            changeColorButton.backgroundColor = category?.color
        }
    
    // MARK: -
    
    private func setupNameTextField(){
        // Configure Title Text Field
        nameTextField.text = category?.name
    }
    
    // Create an add bar navigation item button
//    private func setupBarButtonItems() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(sender:)))
//    }
    
    // MARK: - Actions
    // After creating the add navigation bar item button, performSegue to AddCategoryViewController
//    @objc func add(sender: UIBarButtonItem) {
//        performSegue(withIdentifier: segueColorViewController, sender: self)
//    }
    
    //
    @IBAction func didTapChangeColorButton() {
        performSegue(withIdentifier: segueColorViewController, sender: self)
    }
}

extension DetailsCategoryViewController: ColorViewControllerDelegate {

    func controller(_ controller: ColorViewController, didPick color: UIColor) {
        // Update Category
        category?.color = color

        // Update View
        updateColorView()
    }
}
