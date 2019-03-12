//
//  WeekGoal.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/12/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit

class WeeklyGoal {
    var name: String
    var recordID: CKRecord.ID
    var isPublic: Bool
    var reviewForPublic: Bool
    
    init(name: String, isPublic: Bool = false, reviewForPublic: Bool = false, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.isPublic = isPublic
        self.reviewForPublic = reviewForPublic
        self.recordID = recordID
    }
    
    init?(record: CKRecord) {
        guard let name = record[WeeklyGoal.nameKey] as? String,
            let isPublic = record[WeeklyGoal.isPublicKey] as? Bool,
            let reviewForPublic = record[WeeklyGoal.reviewForPublicKey] as? Bool else {return nil}
        
        self.name = name
        self.recordID = record.recordID
        self.isPublic = isPublic
        self.reviewForPublic = reviewForPublic
    }
}
extension CKRecord {
    
    convenience init(weeklyGoal: WeeklyGoal) {
        self.init(recordType: WeeklyGoal.typeKey, recordID: weeklyGoal.recordID)
        
        self.setValue(weeklyGoal.name, forKey: WeeklyGoal.nameKey)
        self.setValue(weeklyGoal.isPublic, forKey: WeeklyGoal.isPublicKey)
        self.setValue(weeklyGoal.reviewForPublic, forKey: WeeklyGoal.reviewForPublicKey)
    }
}
