//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Mathieu on 16/10/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    // MARK: - Static Properties
    // static let into a class (or struct), that value will be shared among all the instances (or values).
    static let reuseIdentifier = "NoteTableViewCell"
    
    // MARK: - Properties

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    
    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
