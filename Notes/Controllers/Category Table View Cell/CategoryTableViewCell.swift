//
//  CategoryTableViewCell.swift
//  Notes
//
//  Created by Mathieu CHELIM on 03/11/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CategoryTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
