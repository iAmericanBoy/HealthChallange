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
    
    ///All the publicly available Goals.
    var allPublicGoals: [Goal] = []
    
    ///The weekly goals of the current Challenge
    var weeklyGoals: [Goal] = []
    
    ///The month goal of the current Challenge for the current User
    var monthGoal: Goal?
    
    ///All Goals from CK
    var allGoalsFromCK: [[Goal]] {
        get {
            return [usersGoals,allPublicGoals]
        }
    }
    
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
    /// - parameter challenge: The challenge of the goal.
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
                self.allPublicGoals = foundGoals
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    ///Fetches the Weekly goals of a Challenge
    func fetchGoals(withChallengeReference challengeReference: CKRecord.Reference, completion: @escaping (_ isSuccess:Bool) -> Void) {
        
        let predicate = NSPredicate(format: "%K CONTAINS %@", argumentArray: [Goal.challengeReferencesKey,challengeReference])
        let query = CKQuery(recordType: Goal.typeKey, predicate: predicate)
        CloudKitController.shared.findRecords(withQuery: query, inDataBase: CloudKitController.shared.publicDB) { (isSuccess, foundRecords) in
            if isSuccess {
                if isSuccess {
                    let foundGoals = foundRecords.compactMap({ Goal(record: $0)})
                    self.weeklyGoals = foundGoals
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    ///Fetches the Monthly goal
    func fetchUsersMonthGoal(withUserReference userReference: CKRecord.Reference, andChallengeReference challengeReference: CKRecord.Reference, completion: @escaping (_ isSuccess:Bool) -> Void) {
        
        let predicate = NSPredicate(format: "%K CONTAINS %@", argumentArray: [Goal.userReferencesKey,userReference])
        let query = CKQuery(recordType: Goal.typeKey, predicate: predicate)
        CloudKitController.shared.findRecords(withQuery: query, inDataBase: CloudKitController.shared.publicDB) { (isSuccess, foundRecords) in
            
            if isSuccess {
                guard let foundRecord = foundRecords.first, let foundGoal = Goal(record: foundRecord) else {completion(false); return}
                self.monthGoal = foundGoal
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
    /// - parameter isSuccess: Confirms that the goal was updated.
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
    
    ///Adds a Challenge Reference to the challengeReferenceArray of the given goal
    /// - parameter goal: The goal to update.
    /// - parameter challenge: The challenge to reference.
    /// - parameter completion: Handler for when the goal was updated
    /// - parameter isSuccess: Confirms that the goal was updated.
    func add(newChallenge challenge: Challenge, toGoal goal: Goal, _ completion: @escaping (_ isSuccess: Bool) -> Void) {
        let challengeReference = CKRecord.Reference(recordID: challenge.recordID, action: .none)
        goal.challengesWeeklyGoals.append(challengeReference)
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.publicDB, recordsToUpdate: [CKRecord(goal: goal)], purchasesToDelete: []) { (isSuccess, updatedRecords, _) in
            if isSuccess {
                guard let updatedRecord = updatedRecords?.first, updatedRecord.recordID == goal.recordID else {completion(false); return}
                self.weeklyGoals.append(goal)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    ///removes the reference from a Challenge in the challengeReferenceArray of the given goal
    /// - parameter goal: The goal to update.
    /// - parameter challenge: The challenge to remove the reference of.
    /// - parameter completion: Handler for when the goal was updated
    /// - parameter isSuccess: Confirms that the goal was updated.
    func remove(challenge: Challenge, fromGoal goal: Goal, _ completion: @escaping (_ isSuccess: Bool) -> Void) {
        let challengeReference = CKRecord.Reference(recordID: challenge.recordID, action: .none)
        guard let index = goal.challengesWeeklyGoals.index(of: challengeReference) else {return}
        goal.challengesWeeklyGoals.remove(at: index)
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.publicDB, recordsToUpdate: [CKRecord(goal: goal)], purchasesToDelete: []) { (isSuccess, updatedRecords, _) in
            if isSuccess {
                guard let updatedRecord = updatedRecords?.first, updatedRecord.recordID == goal.recordID else {completion(false); return}
                guard let index = self.weeklyGoals.index(of: goal) else {completion(false);return}
                self.weeklyGoals.remove(at: index)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    ///Adds a user Reference to the userreference Array of the given goal
    /// - parameter goal: The goal to update.
    /// - parameter user: The User to reference.
    /// - parameter completion: Handler for when the goal was updated
    /// - parameter isSuccess: Confirms that the goal was updated.
    func add(newUser user: User, toGoal goal: Goal, _ completion: @escaping (_ isSuccess: Bool) -> Void) {
        let userReference = CKRecord.Reference(recordID: user.appleUserRef.recordID, action: .none)
        goal.usersMonthlyGoals.append(userReference)
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.publicDB, recordsToUpdate: [CKRecord(goal: goal)], purchasesToDelete: []) { (isSuccess, updatedRecords, _) in
            if isSuccess {
                guard let updatedRecord = updatedRecords?.first, updatedRecord.recordID == goal.recordID else {completion(false); return}
                self.monthGoal = goal
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    ///removes the reference from a user in the userReferenceArray of the given goal
    /// - parameter goal: The goal to update.
    /// - parameter user: The User to remove the reference of.
    /// - parameter completion: Handler for when the goal was updated
    /// - parameter isSuccess: Confirms that the goal was updated.
    func remove(user: User, fromGoal goal: Goal, _ completion: @escaping (_ isSuccess: Bool) -> Void) {
        let userReference = CKRecord.Reference(recordID: user.appleUserRef.recordID, action: .none)
        guard let index = goal.usersMonthlyGoals.index(of: userReference) else {return}
        goal.usersMonthlyGoals.remove(at: index)
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.publicDB, recordsToUpdate: [CKRecord(goal: goal)], purchasesToDelete: []) { (isSuccess, updatedRecords, _) in
            if isSuccess {
                guard let updatedRecord = updatedRecords?.first, updatedRecord.recordID == goal.recordID else {completion(false); return}
                self.monthGoal = nil
                completion(true)
            } else {
                completion(false)
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
                if let userGoalIndex = self.usersGoals.index(of: goal) {
                    self.usersGoals.remove(at: userGoalIndex)
                }
                if let weeklyGoalIndex = self.weeklyGoals.index(of: goal) {
                    self.weeklyGoals.remove(at: weeklyGoalIndex)
                }
                if self.monthGoal?.recordID == goal.recordID {
                    self.monthGoal = nil
                }
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
