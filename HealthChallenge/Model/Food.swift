//
//  Food.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/15/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit

class Food {
    
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
    //build coming back from cloudkit
    init?(record: CKRecord){
     guard let name = record[Food.nameKey] as? String,
        let ndbno = record[Food.ndbnoKey] as? String,
        let weight = record[Food.weightKey] as? Double,
        let measure = record[Food.measureKey] as? String,
        let scalar = record[Food.scalarKey] as? Double,
        let sugar = record[Food.sugarKey] as? String,
        let carbs = record[Food.carbsKey] as? String,
        let calories = record[Food.caloriesKey] as? String,
        let fats = record[Food.fatsKey] as? String,
        let sodium = record[Food.sodiumKey] as? String,
        let sugarGM = record[Food.sugarGMKey] as? String,
        let carbsGM = record[Food.carbsGMKey] as? String,
        let caloriesGM = record[Food.caloriesGMKey] as? String,
        let fatsGM = record[Food.fatsGMKey] as? String,
        let sodiumGM = record[Food.sodiumGMKey] as? String else {return nil}
        
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
    
    static func == (lhs: Food, rhs: Food) -> Bool {
        return lhs.name == rhs.name && lhs.ndbno == rhs.ndbno
            &&  lhs.weight == rhs.weight && lhs.measure == rhs.measure
    }
}
// build record for cloudkit
extension CKRecord {
    convenience init(food: Food) {
        self.init(recordType: Food.typeKey, recordID: food.recordID)
        
        
        self.setValue(food.name, forKey: Food.nameKey)
        self.setValue(food.ndbno, forKey: Food.ndbnoKey)
        self.setValue(food.weight, forKey: Food.weightKey)
        self.setValue(food.measure, forKey: Food.measureKey)
        self.setValue(food.scalar, forKey: Food.scalarKey)
        self.setValue(food.nutrients?.sugar, forKey: Food.sugarKey)
        self.setValue(food.nutrients?.carbs, forKeyPath: Food.carbsKey)
        self.setValue(food.nutrients?.calories, forKeyPath: Food.caloriesKey)
        self.setValue(food.nutrients?.fats, forKey: Food.fatsKey)
        self.setValue(food.nutrients?.sodium, forKey: Food.sodiumKey)
        self.setValue(food.nutrients?.sugarGM, forKeyPath: Food.sugarGMKey)
        self.setValue(food.nutrients?.carbsGM, forKeyPath: Food.carbsGMKey)
        self.setValue(food.nutrients?.caloriesGM, forKeyPath: Food.caloriesGMKey)
        self.setValue(food.nutrients?.fatsGM, forKeyPath: Food.fatsGMKey)
        self.setValue(food.nutrients?.sodiumGM, forKeyPath: Food.sodiumGMKey)
        
    }
}

//create Key for each varable
//create an ckrecord extension
//only save nutVal to CK
// failabl;e  init taking in  a record
//-> create Nutriuents object from the nutrient values in CK

