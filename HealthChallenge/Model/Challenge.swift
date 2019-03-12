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
    var finishDay: Date
    var weekGoalsReference: [CKRecord.Reference] = []
    var name: String
    var recordID: CKRecord.ID
    
    init(startDay: Date, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        let startMonth = Calendar.current.monthSymbols[Calendar.current.component(.month, from: startDay)]
        self.finishDay = Calendar.current.date(byAdding: .day, value: 30, to: startDay)!
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
            let finishDay = record[Challenge.finishDayKey] as? Date,
            let weekGoals = record[Challenge.weekGoalsKey] as? [CKRecord.Reference] else {return nil}
        
        self.name = name
        self.weekGoalsReference = weekGoals
        self.startDay = startDay
        self.recordID = record.recordID
        self.finishDay = finishDay
    }
}

extension CKRecord {
    
    convenience init(challenge: Challenge) {
        self.init(recordType: Challenge.typeKey, recordID: challenge.recordID)
        
        self.setValue(challenge.name, forKey: Challenge.nameKey)
        self.setValue(challenge.startDay, forKey: Challenge.startDayKey)
        self.setValue(challenge.finishDay, forKey: Challenge.finishDayKey)
        self.setValue(challenge.weekGoalsReference, forKey: Challenge.weekGoalsKey)
    }
}
