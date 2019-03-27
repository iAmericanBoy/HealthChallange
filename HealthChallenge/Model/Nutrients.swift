//
//  Nutrients.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/15/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
//MARK: - saving the constant macros in 100 grams and the multiplier
 //MARK: - SugarGM is the amount of each macro for 100 grams
class Nutrients {
    
    var sugar: String
    var carbs: String
    var calories: String
    var fats: String
    var sodium: String
    var sugarGM: String
    var carbsGM: String
    var caloriesGM: String
    var fatsGM: String
    var sodiumGM: String
    
    
    init(sugar: String, carbs: String, calories: String, fats: String, sodium: String, sugarGM: String,
                     carbsGM: String, caloriesGM: String, fatsGM: String, sodiumGM: String) {
        
        self.sugar = sugar
        self.carbs = carbs
        self.calories = calories
        self.fats = fats
        self.sodium = sodium
        self.sugarGM = sugarGM
        self.carbsGM = carbsGM
        self.caloriesGM = caloriesGM
        self.fatsGM = fatsGM
        self.sodiumGM = sodiumGM
    }
    
    init?(dictionary: [[String: Any]] , weight:Double) {
        
        
        var sugar: String = ""
        var carbs: String = ""
        var calories: String = ""
        var fats: String = ""
        var sodium: String = ""
        var sugarGM: String = ""
        var carbsGM: String = ""
        var carloriesGM: String = ""
        var fatsGM: String = ""
        var sodiumGM: String = ""
        
//        print("-------")
//        print(dictionary)
//        print("-------")
        
        var count = 0
        
        for js in dictionary{
            if let value = js["gm"] as? Double  {
           
                if count == 0 {
                    calories = String (value * (weight/100))
                    carloriesGM = String(value)
                } else if count == 1{
                    sodium = String(value * (weight/100))
                    sodiumGM = String(value)
                }else if count == 2 {
                    sugar = String(value * (weight/100))
                    sugarGM = String(value)
                }else if count == 3 {
                    fats = String(value * (weight/100))
                    fatsGM = String(value)
                } else if count == 4 {
                    carbs = String(value * (weight/100))
                    carbsGM = String(value)
                }
                
            } else {
                
                if count == 0 {
                    calories = "0"
                } else if count == 1{
                    sodium = "0"
                }else if count == 2 {
                    sugar = "0"
                }else if count == 3 {
                    fats = "0"
                } else if count == 4 {
                    carbs = "0"
                }
              
            }
            count += 1
        }
        
        self.sugar = sugar
        self.carbs = carbs
        self.calories = calories
        self.fats = fats
        self.sodium = sodium
        self.sugarGM = sugarGM
        self.carbsGM = carbsGM
        self.caloriesGM = carloriesGM
        self.fatsGM = fatsGM
        self.sodiumGM = sodiumGM
    }
    
    static func == (lhs: Nutrients, rhs: Nutrients) -> Bool {
        return lhs.sugar == rhs.sugar && lhs.carbs == rhs.carbs
            && lhs.calories == rhs.calories && lhs.fats == rhs.fats
            && lhs.sodium == rhs.sodium
    }
    
}
