//
//  FoodEntryController.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/27/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit

class FoodEntryController {
    
    //MARK: - Singleton
    static let shared = FoodEntryController()
    
    //MARK: - SourceOfTruth
    /// An Array of FoodEntries of the user
    var currentEntries: [Date:FoodEntry] = [:]
    
    //MARK: - CRUD
    /// creates a new Food Entry for today. also adds the foodEntry to the currentEntries Dictionary
    /// - parameter completion: Handler for when the foodEntry was created and added.
    /// - parameter isSuccess: Confirms that the foodEntry was created and added.
    func createFoodEntry(completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let userID = UserController.shared.appleUserID else {completion(false);return}
        let newFoodEntry = FoodEntry(appleUserRef: CKRecord.Reference(recordID: userID, action: .deleteSelf))
        
        let record = CKRecord(foodEntry: newFoodEntry)
        
        CloudKitController.shared.create(record: record, inDataBase: CloudKitController.shared.publicDB) { (isSuccess, newRecord) in
            if isSuccess {
                guard let newRecord = newRecord, newRecord.recordID == record.recordID else {completion(false); return}
                self.currentEntries[newFoodEntry.date.stripTimestamp()] = newFoodEntry
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    /// Fetches all the Food Entries of the logged in Apple User and adds them to the foodEntry dictionary.
    /// - parameter completion: Handler for when the foodEntries where found and added
    /// - parameter isSuccess: Confirms that the  foodEntries where found and added
    func fetchAllFoodEntries(completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let userID = UserController.shared.appleUserID else {return}
        
        let userReference = CKRecord.Reference(recordID: userID, action: .deleteSelf)
        let predicate = NSPredicate(format: "%K == %@", argumentArray: [FoodEntry.appleUserRefKey, userReference])
        let query = CKQuery(recordType: FoodEntry.typeKey, predicate: predicate)
        CloudKitController.shared.findRecords(withQuery: query, inDataBase: CloudKitController.shared.publicDB) { (isSuccess, foundRecords) in
            if isSuccess {
                let dispachGroup = DispatchGroup()
                foundRecords.forEach({ (record) in
                    dispachGroup.enter()
                    guard let foodEntry = FoodEntry(record: record) else {completion(false);return}
                    
                    self.currentEntries[foodEntry.date.stripTimestamp()] = foodEntry
                    dispachGroup.leave()
                })
                dispachGroup.notify(queue: .main, execute: {
                    completion(true)
                })
            } else {
                //no food Entries found in the database.
                completion(false)
            }
        }
    }
}
