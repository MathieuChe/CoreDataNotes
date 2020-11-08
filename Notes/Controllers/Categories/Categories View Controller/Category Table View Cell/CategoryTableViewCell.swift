//
//  CategoryTableViewCell.swift
//  Notes
//
//  Created by Mathieu CHELIM on 03/11/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "CategoryTableViewCell"
    
    // MARK: -
    
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Initialization
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
        
}
