//
//  Category.swift
//  Notes
//
//  Created by Mathieu CHELIM on 04/11/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit
import Foundation

extension Category {

    var color: UIColor? {
        get {
            guard let hex = colorAsHex else { return nil }
            return UIColor(hex: hex)
        }
        set(newColor) {
            if let newColor = newColor {
                colorAsHex = newColor.toHex
            }
        }
    }

}
