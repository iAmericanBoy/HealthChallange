//
//  DishController.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/18/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation

class DishController {
    
    static let shared = DishController()
    
    var dishes: [Int: [Dish]] = [:]
//    var breakfastDishes: [Dish] {
//    return dishes.filter { $0.dishType == .breakfast}
//    }
//
//    var lunchDishes = dishes.filter { $0.dishType == .lunch }
//    var dinnerDishes = dishes.filter { $0.dishType == .dinner }
//    var snackDishes = dishes.filter { $0.dishType == .snack }
//    var allDishes = [breakfastDishes, lunchDishes, dinnerDishes, snackDishes]
//
//    var sortedDishes: [[Dish]] {
//        let allDishes =
//        return allDishes.filter { $0.count > 0 }
//    }
//
//    switch sortedDishes[section].first?.type {
//        case .breakfast
//    }
    
    func createDish(name: String, type: DishType, ingredients: [Food]) {
        
        let dish = Dish(dishName: name, ingredients: ingredients, dishType: type)
       // dishes[type.rawValue] == nil ? (dishes[type.rawValue] = [dish]) : dishes[type.rawValue].append
        
//        dishes.append(dish)
    }
}
