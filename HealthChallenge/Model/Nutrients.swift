//
//  Nutrients.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/15/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation


struct Nutrients {
    
    var sugar: String
    var carbs: String
    var calories: String
    var fats: String
    var sodium: String  
    
}
extension Nutrients {
    
    init?(dictionary: [[String: Any]]) {
        
        
        var sugar: String = ""
        var carbs: String = ""
        var calories: String = ""
        var fats: String = ""
        var sodium: String = ""
        
        print("-------")
        print(dictionary)
        print("-------")
        
        var count = 0
        
        for js in dictionary{
            guard let value = js["value"] as? String
                
                else {
                    print("value is wrong")
                    return nil
            }
            
            if count == 0 {
                calories = value
            } else if count == 1{
                sugar = value
            }else if count == 2 {
                fats = value
            }else if count == 3 {
                carbs = value
            } else if count == 4 {
              sodium = value
            }
            count += 1
        }
        
        
        self.sugar = sugar
        self.carbs = carbs
        self.calories = calories
        self.fats = fats
        self.sodium = sodium
    }
    
    static func == (lhs: Nutrients, rhs: Nutrients) -> Bool {
        return lhs.sugar == rhs.sugar && lhs.carbs == rhs.carbs
            && lhs.calories == rhs.calories && lhs.fats == rhs.fats
            && lhs.sodium == rhs.sodium
    }
}

