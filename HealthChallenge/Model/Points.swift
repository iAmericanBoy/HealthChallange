//
//  Points.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/22/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit


class Points {
    let appleUserRef: CKRecord.Reference
    let challengeRef: CKRecord.Reference
    var workOutPoints: Int
    var weeklyGoalPoints: Int
    var monthlyGoalPoints: Int
    var foodTrackingPoints: Int
    var recordID:CKRecord.ID
    
    var totalPoints: Int {
        return workOutPoints + weeklyGoalPoints + monthlyGoalPoints + foodTrackingPoints
    }
    
    init(appleUserRef: CKRecord.Reference, challengeRef: CKRecord.Reference, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), workOutPoints: Int = 0, monthlyGoalPoints: Int = 0, foodTrackingPoints: Int = 0, weeklyGoalPoints: Int = 0) {
        self.recordID = recordID
        self.appleUserRef = appleUserRef
        self.challengeRef = challengeRef
        self.workOutPoints = workOutPoints
        self.weeklyGoalPoints = weeklyGoalPoints
        self.monthlyGoalPoints = monthlyGoalPoints
        self.foodTrackingPoints = foodTrackingPoints
    }
    
    init?(record: CKRecord) {
        guard let challengeRef = record[Points.challengeRefKey] as? CKRecord.Reference,
            let appleUserRef = record[Points.appleUserRefKey] as? CKRecord.Reference,
            let weeklyGoalPoints = record[Points.weeklyGoalPointsKey] as? Int,
            let monthlyGoalPoints = record[Points.monthlyGoalPointsKey] as? Int,
            let foodTrackingPoints = record[Points.foodTrackingPointsKey] as? Int,
            let workOutPoints = record[Points.workOutPointsKey] as? Int else {return nil}
        
        self.recordID = record.recordID
        self.appleUserRef = appleUserRef
        self.challengeRef = challengeRef
        self.workOutPoints = workOutPoints
        self.weeklyGoalPoints = weeklyGoalPoints
        self.monthlyGoalPoints = monthlyGoalPoints
        self.foodTrackingPoints = foodTrackingPoints
    }
}

extension CKRecord {
    convenience init(points: Points) {
        self.init(recordType: Points.typeKey, recordID: points.recordID)
        
        self.setValue(points.appleUserRef, forKey: Points.appleUserRefKey)
        self.setValue(points.challengeRef, forKey: Points.challengeRefKey)
        self.setValue(points.workOutPoints, forKey: Points.workOutPointsKey)
        self.setValue(points.weeklyGoalPoints, forKey: Points.weeklyGoalPointsKey)
        self.setValue(points.monthlyGoalPoints, forKey: Points.monthlyGoalPointsKey)
        self.setValue(points.foodTrackingPoints, forKey: Points.foodTrackingPointsKey)
    }
}
