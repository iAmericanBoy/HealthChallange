//
//  WeekGoal.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/12/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit

class Goal {
    var name: String
    var recordID: CKRecord.ID
    var isPublic: Bool
    var reviewForPublic: Bool
    var strengthValue: Int
    var creatorReference: CKRecord.Reference?
    var usersMonthlyGoals: [CKRecord.Reference]
    var challengesWeeklyGoals: [CKRecord.Reference]
    
    init(name: String, creator: CKRecord.Reference? ,isPublic: Bool = false, reviewForPublic: Bool = false, strengthValue: Int = 1,recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.isPublic = isPublic
        self.reviewForPublic = reviewForPublic
        self.recordID = recordID
        self.strengthValue = strengthValue
        self.creatorReference = creator
        self.usersMonthlyGoals = []
        self.challengesWeeklyGoals = []
    }
    
    init?(record: CKRecord) {
        guard let name = record[Goal.nameKey] as? String,
            let isPublic = record[Goal.isPublicKey] as? Bool,
            let strengthValue = record[Goal.strengthValueKey] as? Int,
            let challengeReferences = record[Goal.challengeReferencesKey] as? [CKRecord.Reference],
            let userReferences = record[Goal.userReferencesKey] as? [CKRecord.Reference],
            let reviewForPublic = record[Goal.reviewForPublicKey] as? Bool else {return nil}
        
        self.name = name
        self.recordID = record.recordID
        self.isPublic = isPublic
        self.reviewForPublic = reviewForPublic
        self.strengthValue = strengthValue
        self.challengesWeeklyGoals = challengeReferences
        self.usersMonthlyGoals = userReferences
        self.creatorReference = record[Goal.creatorReferenceKey] as? CKRecord.Reference

    }
}

extension Goal: Equatable {
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

extension CKRecord {
    
    convenience init(goal: Goal) {
        self.init(recordType: Goal.typeKey, recordID: goal.recordID)
        
        self.setValue(goal.name, forKey: Goal.nameKey)
        self.setValue(goal.strengthValue, forKey: Goal.strengthValueKey)
        self.setValue(goal.challengesWeeklyGoals, forKey: Goal.challengeReferencesKey)
        self.setValue(goal.usersMonthlyGoals, forKey: Goal.userReferencesKey)
        self.setValue(goal.creatorReference, forKey: Goal.creatorReferenceKey)
        self.setValue(goal.isPublic, forKey: Goal.isPublicKey)
        self.setValue(goal.reviewForPublic, forKey: Goal.reviewForPublicKey)
    }
}
