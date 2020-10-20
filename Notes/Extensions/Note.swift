//
//  Note.swift
//  Notes
//
//  Created by Mathieu on 16/10/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import Foundation


// Creating an extension for the Note class and define computed properties for the updatedAt and createdAt properties, which return a Date instance
extension Note {
    var updatedAtAsDate: Date {
        guard let updatedAt = updatedAt else {return Date()}
        return Date(timeIntervalSince1970: updatedAt.timeIntervalSince1970)
    }
    var createdAtAsDate: Date {
        guard let createdAt = createdAt else {return Date()}
        return Date(timeIntervalSince1970: createdAt.timeIntervalSince1970)
    }
}
