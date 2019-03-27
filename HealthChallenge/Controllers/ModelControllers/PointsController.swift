//
//  PointsController.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/22/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit

class PointsController {
    //MARK: - Singleton
    static let shared = PointsController()
    
    //MARK: - Properties
    ///All the goals a user created.
    var usersPoints: Points?
    
    //MARK: - CRUD
    ///Creates a points instance for a user in a specific challenge.
    /// - parameter userID: RecordID of the User.
    /// - parameter challenge: The Challenge of the points
    /// - parameter completion: Handler for when the points where created, saved to CK and set as the current points.
    /// - parameter isSuccess: Confirms that points where created, saved to CK and set as the current points.
    func createPoints(forUserWith userID: CKRecord.ID, inChallenge challenge: Challenge, completion: @escaping (_ isSuccess:Bool) -> Void) {
        let appleUSerRef = CKRecord.Reference(recordID: userID, action: .none)
        let challengeRef = CKRecord.Reference(recordID: challenge.recordID, action: .none)
        
        let points = Points(appleUserRef: appleUSerRef, challengeRef: challengeRef)
        let record = CKRecord(points: points)
        
        CloudKitController.shared.create(record: record, inDataBase: CloudKitController.shared.publicDB) { (isSuccess, newRecord) in
            if isSuccess {
                guard let newRecord = newRecord, newRecord == record else {completion(false);return}
                self.usersPoints = points
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    ///fetches the points of a user and for a given challenge
    /// - parameter userID: RecordID of the User.
    /// - parameter challenge: The Challenge of the points
    /// - parameter completion: Handler for when the points where found.
    /// - parameter isSuccess: Confirms that points where found
    /// - parameter points: The found Points.
    func fetchPoints(ofUserWith userID: CKRecord.ID, forChallenge challenge: Challenge, completion: @escaping (_ isSuccess:Bool, _ points: Points?) -> Void) {
        let appleUserRef = CKRecord.Reference(recordID: userID, action: .none)
        let challengeRef = CKRecord.Reference(recordID: challenge.recordID, action: .none)
        
        let userPredicate = NSPredicate(format: "%K == %@", argumentArray: [Points.appleUserRefKey,appleUserRef])
        let challengePredicate = NSPredicate(format: "%K == %@", argumentArray: [Points.challengeRefKey,challengeRef])
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate,challengePredicate])
        let query = CKQuery(recordType: Points.typeKey, predicate: compoundPredicate)
        CloudKitController.shared.findRecords(withQuery: query, inDataBase: CloudKitController.shared.publicDB) { (isSuccess, foundRecords) in
            if isSuccess {
                guard let foundRecord = foundRecords.first, let points = Points(record: foundRecord) else {completion(false, nil);return}
                completion(true,points)
            } else {
                completion(false, nil)
            }
        }
    }
    
    ///Sets the WorkoutPoints of Points.
    /// - parameter workOutPoints: The new Workout Points of the User for this challenge
    /// - parameter points: The points that have new WorkoutPoints now.
    /// - parameter completion: Handler for when the points where updated.
    /// - parameter isSuccess: Confirms that points where updated.
    func set(workOutPoints: Int, toPoints points: Points, completion: @escaping (_ isSuccess:Bool) -> Void) {
        points.workOutPoints = workOutPoints
        
        let record = CKRecord(points: points)
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.publicDB, recordsToUpdate: [record], purchasesToDelete: []) { (isSuccess, updatedRecords, _) in
            if isSuccess {
                guard let updatedRecord = updatedRecords?.first, updatedRecord.recordID == record.recordID else {completion(false); return}
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    ///Adds the foodTrackerPoints to the Points.
    /// - parameter foodTrackerPoints: The new foodTrackerPoints to be added to the points of the User for this challenge.
    /// - parameter points: The points that have new foodTrackerPoints now.
    /// - parameter completion: Handler for when the points where updated.
    /// - parameter isSuccess: Confirms that points where updated.
    func add(newfoodTrackerPoints foodTrackerPoints: Int, toPoints points: Points, completion: @escaping (_ isSuccess:Bool) -> Void) {
        points.foodTrackingPoints += foodTrackerPoints
        
        let record = CKRecord(points: points)
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.publicDB, recordsToUpdate: [record], purchasesToDelete: []) { (isSuccess, updatedRecords, _) in
            if isSuccess {
                guard let updatedRecord = updatedRecords?.first, updatedRecord.recordID == record.recordID else {completion(false); return}
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    ///Sets the weeklyGoalPoints of Points.
    /// - parameter weeklyGoalPoints: The new weeklyGoalPoints of the User for this challenge
    /// - parameter points: The points that have new weeklyGoalPoints now.
    /// - parameter completion: Handler for when the points where updated.
    /// - parameter isSuccess: Confirms that points where updated.
    func set(weeklyGoalPoints: Int, forGoalWeek goalWeek: GoalType, toPoints points: Points, completion: @escaping (_ isSuccess:Bool) -> Void) {
        
        switch goalWeek {
        case .weekOne:
            points.goalOnePoints = weeklyGoalPoints
        case .weekTwo:
            points.goalTwoPoints = weeklyGoalPoints
        case .weekThree:
            points.goalThreePoints = weeklyGoalPoints
        case .weekFour:
            points.goalFourPoints = weeklyGoalPoints
        }
        
        
        
        let record = CKRecord(points: points)
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.publicDB, recordsToUpdate: [record], purchasesToDelete: []) { (isSuccess, updatedRecords, _) in
            if isSuccess {
                guard let updatedRecord = updatedRecords?.first, updatedRecord.recordID == record.recordID else {completion(false); return}
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    ///Sets the monthlyGoalPoints of Points.
    /// - parameter monthlyGoalPoints: The new monthlyGoalPoints of the User for this challenge
    /// - parameter points: The points that have new monthlyGoalPoints now.
    /// - parameter completion: Handler for when the points where updated.
    /// - parameter isSuccess: Confirms that points where updated.
    func set(monthlyGoalPoints: Int, toPoints points: Points, completion: @escaping (_ isSuccess:Bool) -> Void) {
        points.monthlyGoalPoints = monthlyGoalPoints
        
        let record = CKRecord(points: points)
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.publicDB, recordsToUpdate: [record], purchasesToDelete: []) { (isSuccess, updatedRecords, _) in
            if isSuccess {
                guard let updatedRecord = updatedRecords?.first, updatedRecord.recordID == record.recordID else {completion(false); return}
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

enum GoalType {
    case weekOne
    case weekTwo
    case weekThree
    case weekFour
}
