//
//  Chief.swift
//  GetACook
//
//  Created by Jonathan on 08/06/2017.
//
//

import UIKit

class Chief {
    
    // MARK: Properties
    var name: String
    var photo: UIImage
    var rating: Int
    var tags: [String]
    var bio: String
    var meals: [String]
    
    // MARK: Initialization
    init?(name: String, photo: UIImage, rating: Int, tags: [String], bio: String, meals: [String]) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // The name must not be empty
        guard !tags.isEmpty else {
            return nil
        }
        
        // The name must not be empty
        guard !bio.isEmpty else {
            return nil
        }
        
        // The name must not be empty
        guard !meals.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        self.tags = tags
        self.bio = bio
        self.meals = meals
    }
    
}

