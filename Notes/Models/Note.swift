//
//  Note.swift
//  Notes
//
//  Created by Mathieu on 16/10/2020.
//  Copyright © 2020 Mathieu. All rights reserved.
//

import UIKit

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
    
    // MARK: - Tags
    var alphabetizedTags: [Tag]? {
        guard let tags = tags as? Set<Tag> else {
            return nil
        }

        return tags.sorted(by: {
            guard let tag0 = $0.name else { return true }
            guard let tag1 = $1.name else { return true }
            return tag0 < tag1
        })
    }

    var alphabetizedTagsAsString: String? {
        guard let tags = alphabetizedTags, tags.count > 0 else {
            return nil
        }

        let names = tags.compactMap { $0.name }
        return names.joined(separator: ", ")
    }

}

