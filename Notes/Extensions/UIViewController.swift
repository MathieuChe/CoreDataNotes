//
//  UIViewController.swift
//  Notes
//
//  Created by Mathieu CHELIM on 04/11/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit

extension UIViewController {
        
    func showAlert(with title: String, and message: String){
        
        // Initialize Alert Controllert
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Configure Alert Controller
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present Alert Controller
        
        present(alertController, animated: true, completion: nil)
    }
}
