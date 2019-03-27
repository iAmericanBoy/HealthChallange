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
    
    //MARK: - place this mock Data inside either meal array below to test whether date is working:     Dish(dishName: "dfsfds", ingredients: [], dishType: .Breakfast, timeStamp: Date().addingTimeInterval(24*60*60))
    
    var dishes: [String : [Dish]] = [
        "Breakfast" : [],
        "Lunch" : [],
        "Dinner" : [],
        "Snack" : []
    ]
    
    func createDish(name: String, index: Int, ingredients: [Food], completion: @escaping (Bool) -> Void) {
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
        
        let dish = Dish(dishName: name, creator: nil, ingredients: ingredients, dishType: dishType!, timeStamp: Date())
        
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
}
