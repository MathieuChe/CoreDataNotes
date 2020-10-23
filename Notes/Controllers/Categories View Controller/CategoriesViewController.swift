//
//  CategoriesViewController.swift
//  Notes
//
//  Created by Mathieu on 23/10/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController {
   
    // MARK: - Properties
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -
    
    var note: Note?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
