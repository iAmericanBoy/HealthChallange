//
//  GoalController.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/12/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit

class GoalController {
    //MARK: - Singleton
    static let shared = GoalController()
    
    //MARK: - Properties
    ///All the goals a user created.
    var usersGoals: [Goal] = []
    
    ///All the publicly availabel Goals.
    var allPublicGoals: [Goal] = []
    
    //MARK: - init
    init() {
        fetchUsersGoals { (_) in
        }
        fetchAllPublicGoals { (_) in
        }
    }
    
    //MARK: - CRUD
    ///Creates a Goal with name and a boolean indicating if the goal should be available publicly. After the Goal was created it will be appended to the usersGoals.
    /// - parameter name: name of the goal.
    /// - parameter reviewForPublic: Boolean to indicate if the goal should be reviewed for Public
    /// - parameter completion: Handler for when the goal was created and appended.
    /// - parameter isSuccess: Confirms that the goal was created and appended.
    func createGoalWith(goalName name: String, reviewForPublic: Bool = false, completion: @escaping (_ isSuccess:Bool) -> Void) {

        CloudKitController.shared.fetchUserRecordID { (isSuccess, userRecordID) in
            let newGoal = Goal(name: name, creator: nil, reviewForPublic: reviewForPublic)

            if isSuccess {
                guard let userRecordID = userRecordID else {completion(false); return}
                newGoal.creatorReference = CKRecord.Reference(recordID: userRecordID, action: .deleteSelf)
            }
            
            let record = CKRecord(goal: newGoal)
            CloudKitController.shared.create(record: record, inDataBase: CloudKitController.shared.publicDB) { (isSuccess, newRecord) in
                if isSuccess {
                    guard let newRecord = newRecord, newRecord.recordID == record.recordID else {completion(false); return}
                    self.usersGoals.append(newGoal)
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    ///finds the user and finds all the goals the user has created and adds the goals to usersGoals.
    /// - parameter completion: Handler for when the user was found and they're goals where appended to usersGoals.
    /// - parameter isSuccess: Confirms that the user was found and theyre goals where appended to usersGoals.
    func fetchUsersGoals(completion: @escaping (_ isSuccess:Bool) -> Void) {
        
        CloudKitController.shared.fetchUserRecordID { (isSuccess, userRecordID) in
            if isSuccess {
                guard let userRecordID = userRecordID else {completion(false); return}
                
                let predicate = NSPredicate(format: "%K == %@", argumentArray: [Goal.creatorReferenceKey,userRecordID])
                let query = CKQuery(recordType: Goal.typeKey, predicate: predicate)
                
                CloudKitController.shared.findRecords(withQuery: query, inDataBase: CloudKitController.shared.publicDB) { (isSuccess, foundRecords) in
                    if isSuccess {
                        let foundGoals = foundRecords.compactMap({ Goal(record: $0)})
                        self.usersGoals = foundGoals
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            } else {
                completion(false)
            }
        }
    }
    
    ///finds all the goals that are public.
    /// - parameter completion: Handler for when the goals where found.
    /// - parameter isSuccess: Confirms the found goals where appended to allPublicGoals.
    func fetchAllPublicGoals(completion: @escaping (_ isSuccess:Bool) -> Void) {
        
        let predicate = NSPredicate(format: "%K == %@", argumentArray: [Goal.isPublicKey,true])
        let query = CKQuery(recordType: Goal.typeKey, predicate: predicate)
        
        CloudKitController.shared.findRecords(withQuery: query, inDataBase: CloudKitController.shared.publicDB) { (isSuccess, foundRecords) in
            if isSuccess {
                let foundGoals = foundRecords.compactMap({ Goal(record: $0)})
                self.usersGoals = foundGoals
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    ///Updates the goal with a new Name
    /// - parameter goal: The goal to update.
    /// - parameter name: The new name of the Goal.
    /// - parameter completion: Handler for when the goal was updated
    /// - parameter isSuccess: Confirms that the goal was created.
    /// - parameter updatedGoal: The updated Goal or nil.
    func update(goal: Goal, withName name: String, completion: @escaping (_ isSuccess:Bool, _ updatedGoal: Goal?) -> Void) {
        goal.name = name
        let record = CKRecord(goal: goal)
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.publicDB, recordsToUpdate: [record], purchasesToDelete: []) { (isSuccess, updatedRecords, _) in
            if isSuccess {
                guard let updatedRecord = updatedRecords?.first, updatedRecord.recordID == record.recordID else {completion(false,nil); return}
                completion(true, Goal(record: updatedRecord))
            } else {
                completion(false,nil)
            }
        }
    }
    
    ///Delete the given Goal.
    /// - parameter goal: The goal to delete.
    /// - parameter completion: Handler for when the goal was deleted
    /// - parameter isSuccess: Confirms that the goal was deleted.
    func delete(goal: Goal, completion: @escaping (_ isSuccess:Bool) -> Void) {
        let recordID = CKRecord(goal: goal).recordID
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.publicDB, recordsToUpdate: [], purchasesToDelete: [recordID]) { (isSuccess, _, deletedRecords) in
            if isSuccess {
                guard let deletedRecordID = deletedRecords?.first, deletedRecordID == recordID else {completion(false); return}
                self.fetchUsersGoals(completion: { (isSuccess) in
                    if isSuccess {
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            } else {
                completion(false)
            }
        }
    }
}
