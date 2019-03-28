//
//  DishController.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/18/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit

class DishController {
    
    static let shared = DishController()
    
    var dishes: [String : [Dish]] = [:]
    
    func createDish(name: String, index: Int, ingredients: [Ingredient], inFoodEntry foodEntry: FoodEntry, completion: @escaping (Bool) -> Void) {
        var dishType: DishType?
        switch index {
        case 0:
            dishType = .Breakfast
        case 1:
            dishType = .Lunch
        case 2:
            dishType = .Dinner
        case 3:
            dishType = .Snack
            default:
            return
        }
        guard let userID = UserController.shared.appleUserID else {completion(false);return}
        
        let dish = Dish(dishName: name, creator: CKRecord.Reference(recordID: userID, action: .none), ingredients: ingredients, dishType: dishType!, foodEntryReference: [CKRecord.Reference(recordID: foodEntry.recordID, action: .none)])
        
        saveDishToCloudKit(dish: dish, forFoodEntry: foodEntry) { (success) in
            if success {
                print("😛😛😛😛😛😛😛😛😛😛😛😛😛😛😛😛😛😛😛😛😛😛😛😛😛😛😛")
                print("saved To CloudKit saved Successfully")
                completion(true)
            } else {
                print("not saved to cloudkit")
                completion(false)
            }
        }
        
        dump(dish)
        dishes[dishType!.rawValue]?.append(dish)

    }
    
    func saveDishToCloudKit(dish: Dish, forFoodEntry foodEntry: FoodEntry, completion: @escaping (Bool) -> Void) {
        var recordsToSave: [CKRecord] = []
        
        dish.ingredients.forEach({ (ingredient) in
            ingredient.dishRef = CKRecord.Reference(recordID: dish.ckRecordID, action: .deleteSelf)
            let recordToSave = CKRecord(ingredient: ingredient)
            recordsToSave.append(recordToSave)
        })
        
        let dishToSave = CKRecord(dish: dish)
        
        recordsToSave.append(dishToSave)
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.publicDB, recordsToUpdate: recordsToSave, purchasesToDelete: []) { (success, records, _) in
            if success {
                if self.dishes[foodEntry.recordID.recordName]  == nil {
                    self.dishes[foodEntry.recordID.recordName] = [dish]
                } else {
                    self.dishes[foodEntry.recordID.recordName]! += [dish]
                }
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    //Fetches all the Dishes of a Food Entry and appendes them to the dishes dictionary.
    func fetchDishes(forFoodEntry foodEntry: FoodEntry, completion: @escaping (Bool) -> Void) {
        let foodReference = CKRecord.Reference(recordID: foodEntry.recordID, action: .none)
        
        let predicate = NSPredicate(format: "%K CONTAINS %@", argumentArray: [Dish.foodEntriesRefsKey,foodReference])
        let query = CKQuery(recordType: Dish.typeKey, predicate: predicate)
        CloudKitController.shared.findRecords(withQuery: query, inDataBase: CloudKitController.shared.publicDB) { (isSuccess, foundRecords) in
            if isSuccess {
                foundRecords.forEach({ (record) in
                    guard let dish = Dish(record: record) else {completion(false);return}
                    if self.dishes[foodEntry.recordID.recordName]  == nil {
                        self.dishes[foodEntry.recordID.recordName] = [dish]
                    } else {
                        self.dishes[foodEntry.recordID.recordName]! += [dish]
                    }
                })
                completion(true)
            } else {
                //no dishes found in the database.
                completion(false)
            }
        }
    }
}
