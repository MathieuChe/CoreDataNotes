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
    
    // MARK: - Properties

    @IBOutlet weak var nameCategoryLabel: UILabel!
    
    // MARK: - Initialization
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
}
