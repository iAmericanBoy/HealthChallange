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
    
    //MARK: - CRUD
    ///Creates a new Challenge with a start date.
    /// - parameter date: The start date of the challenge.
    /// - parameter completion: Handler for when the challenge was created.
    /// - parameter isSuccess: Confirms that the challenge was created.
    func createNewChallenge(withStartDate date: Date, _ completion: @escaping (_ isSuccess: Bool) -> Void) {
        let newChallenge = Challenge(startDay: date)
        guard let record = CKRecord(challenge: newChallenge) else {completion(false);return}
        
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
    /// - parameter completion: Handler for when the challenge was found.
    /// - parameter isSuccess: Confirms that the challenge was found.
    func fetchCurrentChallenge(inDataBase database: CKDatabase = CloudKitController.shared.privateDB, inZoneWithID zoneID: CKRecordZone.ID = CKRecordZone.ID(zoneName: "private"),_ completion: @escaping (_ isSuccess: Bool) -> Void) {
        let currentDay = Date()
        let olderThenStart = NSPredicate(format: "%K >= %@ ", argumentArray: [Challenge.startDayKey,currentDay])
//        let youngerThenFinish = NSPredicate(format: "%K <= %@ ", argumentArray: [Challenge.finishDayKey,currentDay.addingTimeInterval(2592000)])
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [olderThenStart])
        
        let query = CKQuery(recordType: Challenge.typeKey, predicate: predicate)
        CloudKitController.shared.findRecords(withQuery: query, inDataBase: database, inZoneWith: zoneID) { (isSuccess, foundRecords) in
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
        
        guard let record = CKRecord(challenge: challenge) else {completion(false);return}

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
        guard let recordID = CKRecord(challenge: challenge)?.recordID else {completion(false);return}

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
