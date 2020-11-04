//
//  TableViewCells.swift
//  Notes
//
//  Created by Mathieu CHELIM on 04/11/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit

class TagTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let reuseIdentifier = "TagTableViewCell"

    // MARK: -

    @IBOutlet weak var nameLabel: UILabel!
    
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
