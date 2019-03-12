//
//  Challenge.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/12/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit

class Challenge {
    var startDay: Date
    var weekGoalsReference: [CKRecord.Reference] = []
    var monthlyGoalReference: CKRecord.Reference?
    var name: String
    var recordID: CKRecord.ID
    
    init(startDay: Date, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        let startMonth = Calendar.current.monthSymbols[Calendar.current.component(.month, from: startDay)]
        let finishDay = Calendar.current.date(byAdding: .day, value: 30, to: startDay)!
        let finishMonth = Calendar.current.monthSymbols[Calendar.current.component(.month, from: finishDay)]

        if startMonth != finishMonth {
            self.name = "\(startMonth)/\(finishMonth) Challange"
        } else {
            self.name = "\(startMonth) Challange"
        }
        self.startDay = startDay
        self.recordID = recordID
    }
    
    init?(record: CKRecord) {
        guard let name = record[Challenge.nameKey] as? String,
            let startDay = record[Challenge.startDayKey] as? Date,
            let weekGoals = record[Challenge.weekGoalsKey] as? [CKRecord.Reference],
            let monthlyGoal = record[Challenge.montlyGoalKey] as? CKRecord.Reference else {return nil}
        
        self.name = name
        self.monthlyGoalReference = monthlyGoal
        self.weekGoalsReference = weekGoals
        self.startDay = startDay
        self.recordID = record.recordID
    }
}

extension CKRecord {
    
    convenience init(challenge: Challenge) {
        self.init(recordType: Challenge.typeKey, recordID: challenge.recordID)
        
        self.setValue(challenge.name, forKey: Challenge.nameKey)
        self.setValue(challenge.startDay, forKey: Challenge.startDayKey)
        self.setValue(challenge.weekGoalsReference, forKey: Challenge.weekGoalsKey)
        self.setValue(challenge.monthlyGoalReference!, forKey: Challenge.montlyGoalKey)
    }
}
