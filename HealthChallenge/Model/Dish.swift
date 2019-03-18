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
    var ingredients: [Food]?
    var photo: UIImage?
    let dishType: DishType
    
    init(dishName: String, ingredients: [Food], dishType: DishType) {
        self.dishName = dishName
        self.ingredients = ingredients
        self.dishType = dishType
    }
}

enum DishType: String {
    case Breakfast
    case Lunch
    case Dinner
    case Snack
}

// dish model
//name
// array of ingredients
//photo ?
