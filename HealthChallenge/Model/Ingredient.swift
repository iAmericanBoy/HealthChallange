//
//  Food.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/15/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit

class Ingredient {
    
    let name: String
    let ndbno: String
    var weight: Double?      
    var measure: String? 
    var nutrients: Nutrients?
    var scalar: Double?
    
    var sugar: String?
    var carbs: String?
    var calories: String?
    var fats: String?
    var sodium: String?
    
    var sugarGM: String?
    var carbsGM: String?
    var caloriesGM: String?
    var fatsGM: String?
    var sodiumGM: String?
    var dishRef: CKRecord.Reference?
    var recordID: CKRecord.ID
    
    init?(dictionary: [String: Any]) {
                guard let name = dictionary["name"] as? String,
            let ndbno = dictionary["ndbno"] as? String
            
            else {
                return nil
        }
        self.name = name
        self.ndbno = ndbno
        self.recordID = CKRecord.ID(recordName: UUID().uuidString)
    }
    //record coming back from cloudkit
    init?(record: CKRecord){
     guard let name = record[Ingredient.nameKey] as? String,
        let ndbno = record[Ingredient.ndbnoKey] as? String,
        let weight = record[Ingredient.weightKey] as? Double,
        let measure = record[Ingredient.measureKey] as? String,
        let scalar = record[Ingredient.scalarKey] as? Double,
        let sugar = record[Ingredient.sugarKey] as? String,
        let carbs = record[Ingredient.carbsKey] as? String,
        let calories = record[Ingredient.caloriesKey] as? String,
        let fats = record[Ingredient.fatsKey] as? String,
        let sodium = record[Ingredient.sodiumKey] as? String,
        let sugarGM = record[Ingredient.sugarGMKey] as? String,
        let carbsGM = record[Ingredient.carbsGMKey] as? String,
        let caloriesGM = record[Ingredient.caloriesGMKey] as? String,
        let fatsGM = record[Ingredient.fatsGMKey] as? String,
        let sodiumGM = record[Ingredient.sodiumGMKey] as? String else {return nil}
        
        self.name = name
        self.ndbno = ndbno
        self.weight = weight
        self.measure = measure
        self.scalar = scalar
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
        self.recordID = record.recordID
        self.nutrients = Nutrients(sugar: sugar, carbs: carbs, calories: calories, fats: fats, sodium: sodium, sugarGM: sugarGM, carbsGM: carbsGM, caloriesGM: caloriesGM, fatsGM: fatsGM, sodiumGM: sodiumGM)
    }
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name == rhs.name && lhs.ndbno == rhs.ndbno
            &&  lhs.weight == rhs.weight && lhs.measure == rhs.measure
    }
}
// build record for cloudkit
extension CKRecord {
    convenience init(ingredient: Ingredient) {
        self.init(recordType: Ingredient.typeKey, recordID: ingredient.recordID)
        
        self.setValue(ingredient.dishRef, forKey: Ingredient.dishRefKey)
        self.setValue(ingredient.name, forKey: Ingredient.nameKey)
        self.setValue(ingredient.ndbno, forKey: Ingredient.ndbnoKey)
        self.setValue(ingredient.weight, forKey: Ingredient.weightKey)
        self.setValue(ingredient.measure, forKey: Ingredient.measureKey)
        self.setValue(ingredient.scalar, forKey: Ingredient.scalarKey)
        self.setValue(ingredient.nutrients?.sugar, forKey: Ingredient.sugarKey)
        self.setValue(ingredient.nutrients?.carbs, forKeyPath: Ingredient.carbsKey)
        self.setValue(ingredient.nutrients?.calories, forKeyPath: Ingredient.caloriesKey)
        self.setValue(ingredient.nutrients?.fats, forKey: Ingredient.fatsKey)
        self.setValue(ingredient.nutrients?.sodium, forKey: Ingredient.sodiumKey)
        self.setValue(ingredient.nutrients?.sugarGM, forKeyPath: Ingredient.sugarGMKey)
        self.setValue(ingredient.nutrients?.carbsGM, forKeyPath: Ingredient.carbsGMKey)
        self.setValue(ingredient.nutrients?.caloriesGM, forKeyPath: Ingredient.caloriesGMKey)
        self.setValue(ingredient.nutrients?.fatsGM, forKeyPath: Ingredient.fatsGMKey)
        self.setValue(ingredient.nutrients?.sodiumGM, forKeyPath: Ingredient.sodiumGMKey)
        
    }
}

//create Key for each varable
//create an ckrecord extension
//only save nutVal to CK
// failabl;e  init taking in  a record
//-> create Nutriuents object from the nutrient values in CK

