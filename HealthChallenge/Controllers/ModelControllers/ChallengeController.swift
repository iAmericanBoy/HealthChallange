//
//  ChallengeController.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/12/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit

class ChallengeController {
    //MARK: - Singleton
    static let shared = UserController()
    
    //MARK: - Properties
    ///The current Challenge
    var currentChallenge: Challenge?
    
    //MARK: - CRUD
    ///Creates a new Challenge with a start date.
    /// - parameter date: The start date of the challenge.
    /// - parameter completion: Handler for when the challenge was created.
    /// - parameter isSuccess: Confirms that the challenge was created.
    func createNewChallenge(withStartDate date: Date, _ completion: @escaping (_ isSuccess: Bool) -> Void) {
        let newChallenge = Challenge(startDay: date)
        let record = CKRecord(challenge: newChallenge)
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.privateDB, recordsToUpdate: [record], purchasesToDelete: []) { (isSuccess, updatedRecords, _) in
            if isSuccess {
                guard let updatedRecord = updatedRecords?.first, updatedRecord.recordID == record.recordID, let newChallenge = Challenge(record: record) else {completion(false); return}
                self.currentChallenge = newChallenge
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    ///Fetches the current Challenge from CK and assigns the current Challenge to the property.
    /// - parameter completion: Handler for when the challenge was created.
    /// - parameter isSuccess: Confirms that the challenge was created.
    func fetchCurrentChallenge(_ completion: @escaping (_ isSuccess: Bool) -> Void) {
        let currentDay = Date()
        let olderThenStart = NSPredicate(format: "%@ >= %@ ", argumentArray: [Challenge.startDayKey,currentDay])
        let youngerThenFinish = NSPredicate(format: "%@ <= %@ ", argumentArray: [Challenge.finishDayKey,currentDay])

        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [olderThenStart,youngerThenFinish])
        
        let query = CKQuery(recordType: Challenge.typeKey, predicate: predicate)
        CloudKitController.shared.findRecords(withQuery: query, inDataBase: CloudKitController.shared.privateDB) { (isSuccess, foundRecords) in
            if isSuccess {
                guard let foundRecord = foundRecords.first, let currentChallenge = Challenge(record: foundRecord) else {completion(false);return}
                self.currentChallenge = currentChallenge
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    ///Updates the challenge with a new date.
    /// - parameter challenge: The challenge to update.
    /// - parameter date: The new date of the challenge.
    /// - parameter completion: Handler for when the challenge was updated
    /// - parameter isSuccess: Confirms that the challenge was updated.
    func update(challenge: Challenge, withNewStartDate date: Date, _ completion: @escaping (_ isSuccess: Bool) -> Void) {
        challenge.startDay = date
        
        let record = CKRecord(challenge: challenge)
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.privateDB, recordsToUpdate: [record], purchasesToDelete: []) { (isSuccess, updatedRecords, _) in
            if isSuccess {
                guard let updatedRecord = updatedRecords?.first, updatedRecord.recordID == record.recordID, let updatedChallenge = Challenge(record: updatedRecord) else {completion(false);return}
                self.currentChallenge = updatedChallenge
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func add(weeklyGoals goals: [Goal], toChallange challenge: Challenge) {
        
    }
    
    func add(monthlyGoal goal: Goal, forChallenge challenge: Challenge, ofParticipent user: User) {
        
    }
    
    func delete(challenge: Challenge) {
        
    }
}
