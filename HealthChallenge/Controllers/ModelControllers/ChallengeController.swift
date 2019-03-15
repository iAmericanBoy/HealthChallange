//
//  ChallengeController.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/12/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit
import NotificationCenter

class ChallengeController {
    //MARK: - Singleton
    static let shared = ChallengeController()
    
    //MARK: - Properties
    ///The current Challenge
    var currentChallenge: Challenge?
    
    ///The weekGoals of the current Challenge
    var currentChallengeWeekGoals: [Goal] = []

    //MARK: - init
    init() {
        fetchCurrentChallenge { (isSuccess) in
            if isSuccess {
                let challengeFound = Notification(name: Notification.Name(rawValue: NotificationStrings.challengeFound), object: nil, userInfo: nil)
                NotificationCenter.default.post(challengeFound)
                
                let challengeReference = CKRecord.Reference(recordID: self.currentChallenge!.recordID, action: .none)
                GoalController.shared.fetchGoals(withChallengeReference: challengeReference, completion: { (isSuccess) in
                    if isSuccess {
                        let weekGoalsOfChallengeFound = Notification(name: Notification.Name(rawValue: NotificationStrings.weekGoalsFound), object: nil, userInfo: nil)
                        NotificationCenter.default.post(weekGoalsOfChallengeFound)
                    }
                })
            }
        }
    }
    
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
        let olderThenStart = NSPredicate(format: "%K >= %@ ", argumentArray: [Challenge.startDayKey,currentDay])
//        let youngerThenFinish = NSPredicate(format: "%K <= %@ ", argumentArray: [Challenge.finishDayKey,currentDay.addingTimeInterval(2592000)])
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [olderThenStart])
        
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
    
    ///fetches the goals of a Challenge
    /// - parameter challenge: The challenge.
    /// - parameter completion: Handler for when the challenge was created.
    /// - parameter isSuccess: Confirms that the challenge was created.
    func fetchGoals(ofChallenge challenge: Challenge, _ completion: @escaping (_ isSuccess: Bool) -> Void) {
        var goals: [CKRecord.Reference?] = []
        goals.append(challenge.weekOneGoal)
        goals.append(challenge.weekTwoGoal)
        goals.append(challenge.weekThreeGoal)
        goals.append(challenge.weekFourGoal)
        let dispatchGroup = DispatchGroup()
        goals.forEach { (reference) in
            guard let goalReference = reference else {completion(false);return}
            
            let predicate = NSPredicate(format: "%K == %@", argumentArray: ["recordID", goalReference.recordID])
            let query = CKQuery(recordType: Goal.typeKey, predicate: predicate)
            dispatchGroup.enter()
            CloudKitController.shared.findRecords(withQuery: query, inDataBase: CloudKitController.shared.publicDB, { (isSuccess, foundRecords) in
                if isSuccess {
                    let foundGoals = foundRecords.compactMap({ Goal(record: $0)})
                    guard let goal = foundGoals.first else {completion(false);return}
                    self.currentChallengeWeekGoals.append(goal)
                    dispatchGroup.leave()
                } else {
                    dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            if self.currentChallengeWeekGoals.count == 4 {
                print(self.currentChallengeWeekGoals)
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
    
    ///Adds Weekly Goals to Challenge. goals[0] will be challenge for week 1 and so on...
    /// - parameter goals: The weekly goals for the Challenge.
    /// - parameter completion: Handler for when the challenge was updated
    /// - parameter isSuccess: Confirms that the challenge was updated.
    func add(weeklyGoals goals: [Goal], toChallange challenge: Challenge, _ completion: @escaping (_ isSuccess: Bool) -> Void) {
        let goalReference = goals.compactMap({ CKRecord.Reference(recordID: $0.recordID, action: .none)})
        challenge.weekOneGoal = goalReference[0]
        challenge.weekTwoGoal = goalReference[1]
        challenge.weekThreeGoal = goalReference[2]
        challenge.weekFourGoal = goalReference[3]

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
    
    ///Deletes the given Challenge.
    /// - parameter challenge: The challenge to delete.
    /// - parameter completion: Handler for when the challenge was deleted
    /// - parameter isSuccess: Confirms that the challenge was deleted.
    func delete(challenge: Challenge, completion: @escaping (_ isSuccess:Bool) -> Void) {
        let recordID = CKRecord(challenge: challenge).recordID
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.publicDB, recordsToUpdate: [], purchasesToDelete: [recordID]) { (isSuccess, _, deletedRecords) in
            if isSuccess {
                guard let deletedRecordID = deletedRecords?.first, deletedRecordID == recordID else {completion(false); return}
                self.currentChallenge = nil
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
