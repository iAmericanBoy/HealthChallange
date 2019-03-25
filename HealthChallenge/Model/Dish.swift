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
    var timeStamp: Date = Date()
    
    var totalcal:Double = 0
    var totalcarbs:Double = 0
    var totalsugars:Double = 0
    var totalfats:Double = 0
    var totalsodium:Double = 0
    
    
    init(dishName: String, ingredients: [Food], dishType: DishType, timeStamp: Date) {
        self.dishName = dishName
        self.ingredients = ingredients
        self.dishType = dishType
        self.timeStamp = timeStamp
        
        var totalcal:Double = 0
        var totalcarbs:Double = 0
        var totalsugars:Double = 0
        var totalfats:Double = 0
        var totalsodium:Double = 0
        
        for ingredient in ingredients{
            
            let nutrients = ingredient.nutrients
            let nutrientCalories = Double( nutrients?.calories ?? "0" )
            let nutrientSugars = Double( nutrients?.sugar ?? "0" )
            let nutrientCarbs = Double( nutrients?.carbs ?? "0" )
            let nutrientFats = Double( nutrients?.fats ?? "0" )
            let nutrientsSodium = Double( nutrients?.sodium ?? "0" )
            
            totalcal += nutrientCalories ?? 0
            totalcarbs += nutrientCarbs  ?? 0
            totalsugars += nutrientSugars ?? 0
            totalfats += nutrientFats ?? 0
            totalsodium += nutrientsSodium ?? 0
            
        }
        
        self.totalcal = totalcal
        self.totalcarbs = totalcarbs
        self.totalsugars = totalsugars
        self.totalfats =  totalfats
        self.totalsodium = totalsodium
        
        /*let roundedFat = Double(round(1000*fats)/1000)
         let roundedCarbs = Double(round(1000*carbs)/1000)
         let roundedSodium = Double(round(1000*sodium)/1000)
         
         caloriesLabel.text = "Calories: \(calories) kcal"
         sugarsLabel.text = "Sugar: \(sugars) g"
         carbsLabel.text = "Carbs: \(roundedCarbs) g"
         fatsLabel.text = "Fat: \(roundedFat) g"
         sodiumLabel.text = "Sodium: \(roundedSodium) mg"*/
        
    }
}

enum DishType: String {
    case Breakfast
    case Lunch
    case Dinner
    case Snack
}

