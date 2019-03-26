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
    var goalOnePoints: Int
    var goalTwoPoints: Int
    var goalThreePoints: Int
    var goalFourPoints: Int
    var monthlyGoalPoints: Int
    var foodTrackingPoints: Int
    var recordID:CKRecord.ID
    
    var totalPoints: Int {
        return workOutPoints + weeklyGoalPoints + monthlyGoalPoints + foodTrackingPoints
    }
    
    init(appleUserRef: CKRecord.Reference, challengeRef: CKRecord.Reference, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), workOutPoints: Int = 0, monthlyGoalPoints: Int = 0, foodTrackingPoints: Int = 0, goalOnePoints: Int = 0, goalTwoPoints: Int = 0, goalThreePoints: Int = 0, goalFourPoints: Int = 0) {
        self.recordID = recordID
        self.appleUserRef = appleUserRef
        self.challengeRef = challengeRef
        self.workOutPoints = workOutPoints
        self.goalOnePoints = goalOnePoints
        self.goalTwoPoints = goalTwoPoints
        self.goalThreePoints = goalThreePoints
        self.goalFourPoints = goalFourPoints
        self.monthlyGoalPoints = monthlyGoalPoints
        self.foodTrackingPoints = foodTrackingPoints
    }
    
    init?(record: CKRecord) {
        guard let challengeRef = record[Points.challengeRefKey] as? CKRecord.Reference,
            let appleUserRef = record[Points.appleUserRefKey] as? CKRecord.Reference,
            let goalOnePoints = record[Points.goalOnePointsKey] as? Int,
            let goalTwoPoints = record[Points.goalTwoPointsKey] as? Int,
            let goalThreePoints = record[Points.goalThreePointsKey] as? Int,
            let goalFourPoints = record[Points.goalFourPointsKey] as? Int,
            let monthlyGoalPoints = record[Points.monthlyGoalPointsKey] as? Int,
            let foodTrackingPoints = record[Points.foodTrackingPointsKey] as? Int,
            let workOutPoints = record[Points.workOutPointsKey] as? Int else {return nil}
        
        self.recordID = record.recordID
        self.appleUserRef = appleUserRef
        self.challengeRef = challengeRef
        self.workOutPoints = workOutPoints
        self.goalOnePoints = goalOnePoints
        self.goalTwoPoints = goalTwoPoints
        self.goalThreePoints = goalThreePoints
        self.goalFourPoints = goalFourPoints
        self.monthlyGoalPoints = monthlyGoalPoints
        self.foodTrackingPoints = foodTrackingPoints
    }
}

extension CKRecord {
    convenience init(points: Points) {
        self.init(recordType: Points.typeKey, recordID: points.recordID)
        
        self.setValue(points.appleUserRef, forKey: Points.appleUserRefKey)
        self.setValue(points.challengeRef, forKey: Points.challengeRefKey)
        self.setValue(points.goalOnePoints, forKey: Points.goalOnePointsKey)
        self.setValue(points.goalTwoPoints, forKey: Points.goalTwoPointsKey)
        self.setValue(points.goalThreePoints, forKey: Points.goalThreePointsKey)
        self.setValue(points.goalFourPoints, forKey: Points.goalFourPointsKey)
        self.setValue(points.monthlyGoalPoints, forKey: Points.monthlyGoalPointsKey)
        self.setValue(points.foodTrackingPoints, forKey: Points.foodTrackingPointsKey)
    }
}
