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
    
    func createDish(name: String, index: Int, ingredients: [Food], inFoodEntry foodEntry: FoodEntry, completion: @escaping (Bool) -> Void) {
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
        
        saveDishToCloudKit(dish: dish) { (success) in
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
    
    func saveDishToCloudKit(dish: Dish, completion: @escaping (Bool) -> Void) {
        var recordsToSave: [CKRecord] = []
        
        dish.ingredients.forEach({ (food) in
            let dishRef = CKRecord.Reference(recordID: dish.ckRecordID, action: .none)
            food.dishRef = dishRef
            let recordToSave = CKRecord(food: food)
            recordsToSave.append(recordToSave)
        })
        
        let dishToSave = CKRecord(dish: dish) //< Freezes
        print("Break points Suck")
        recordsToSave.append(dishToSave)
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.publicDB, recordsToUpdate: recordsToSave, purchasesToDelete: []) { (success, records, _) in
            if success {
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
                let dispachGroup = DispatchGroup()
                foundRecords.forEach({ (record) in
                    dispachGroup.enter()
                    guard let dish = Dish(record: record) else {completion(false);return}
                    
                    self.dishes[foodEntry.recordID.recordName]?.append(dish)
                    dispachGroup.leave()
                })
                dispachGroup.notify(queue: .main, execute: {
                    completion(true)
                })
            } else {
                //no dishes found in the database.
                completion(false)
            }
        }
    }
}
