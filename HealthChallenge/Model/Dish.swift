//
//  Dish.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/15/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import UIKit


class Dish {
    
    var dishName: String
    var dish: [Food]?
    var photo: UIImage?
    
    init(dishName: String,dish: [Food], photo: UIImage?) {
        self.dishName = dishName
        self.dish = dish
        self.photo = photo
    }
}
// dish model
//name
// array of ingredients
//photo ?
