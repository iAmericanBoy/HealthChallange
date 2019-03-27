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
    var foodTrackingPoints: Int
    var recordID:CKRecord.ID
    
    var goalOnePoints: Int?
    var goalOneDate: Date?
    
    var goalTwoPoints: Int?
    var goalTwoDate: Date?

    var goalThreePoints: Int?
    var goalThreeDate: Date?

    var goalFourPoints: Int?
    var goalFourDate: Date?

    var monthlyGoalPoints: Int?
    var monthGoalDate: Date?
    

    
    var totalPoints: Int {
//        return workOutPoints + goalOnePoints + goalTwoPoints + goalThreePoints + goalFourPoints + monthlyGoalPoints + foodTrackingPoints
        return 10
    }
    
    init(appleUserRef: CKRecord.Reference, challengeRef: CKRecord.Reference, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), workOutPoints: Int = 0, foodTrackingPoints: Int = 0) {
        self.recordID = recordID
        self.appleUserRef = appleUserRef
        self.challengeRef = challengeRef
        self.workOutPoints = workOutPoints
        self.foodTrackingPoints = foodTrackingPoints
    }
    
    init?(record: CKRecord) {
        guard let challengeRef = record[Points.challengeRefKey] as? CKRecord.Reference,
            let appleUserRef = record[Points.appleUserRefKey] as? CKRecord.Reference,
            let foodTrackingPoints = record[Points.foodTrackingPointsKey] as? Int,
            let workOutPoints = record[Points.workOutPointsKey] as? Int else {return nil}
        
        self.recordID = record.recordID
        self.appleUserRef = appleUserRef
        self.challengeRef = challengeRef
        self.workOutPoints = workOutPoints
        
        self.goalOnePoints = record[Points.goalOnePointsKey] as? Int
        self.goalTwoPoints = record[Points.goalTwoPointsKey] as? Int
        self.goalThreePoints = record[Points.goalThreePointsKey] as? Int
        self.goalFourPoints = record[Points.goalFourPointsKey] as? Int
        self.monthlyGoalPoints = record[Points.monthlyGoalPointsKey] as? Int
        
        self.goalOneDate = record[Points.goalOneDateKey] as? Date
        self.goalTwoDate = record[Points.goalTwoDateKey] as? Date
        self.goalThreeDate = record[Points.goalThreeDateKey] as? Date
        self.goalFourDate = record[Points.goalFourDateKey] as? Date
        self.monthGoalDate = record[Points.monthGoalDateKey] as? Date

        self.foodTrackingPoints = foodTrackingPoints
    }
}

extension CKRecord {
    convenience init(points: Points) {
        self.init(recordType: Points.typeKey, recordID: points.recordID)
        
        self.setValue(points.appleUserRef, forKey: Points.appleUserRefKey)
        self.setValue(points.challengeRef, forKey: Points.challengeRefKey)
        self.setValue(points.workOutPoints, forKey: Points.workOutPointsKey)
        self.setValue(points.foodTrackingPoints, forKey: Points.foodTrackingPointsKey)
        
        self.setValue(points.goalOnePoints, forKey: Points.goalOnePointsKey)
        self.setValue(points.goalTwoPoints, forKey: Points.goalTwoPointsKey)
        self.setValue(points.goalThreePoints, forKey: Points.goalThreePointsKey)
        self.setValue(points.goalFourPoints, forKey: Points.goalFourPointsKey)
        self.setValue(points.monthlyGoalPoints, forKey: Points.monthlyGoalPointsKey)
        
        self.setValue(points.goalOneDate, forKey: Points.goalOneDateKey)
        self.setValue(points.goalTwoDate, forKey: Points.goalTwoDateKey)
        self.setValue(points.goalThreeDate, forKey: Points.goalThreeDateKey)
        self.setValue(points.goalFourDate, forKey: Points.goalFourDateKey)
        self.setValue(points.monthGoalDate, forKey: Points.monthGoalDateKey)
    }
}
