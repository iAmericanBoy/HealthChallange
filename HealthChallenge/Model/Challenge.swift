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
    var recordID: CKRecord.ID
    
    var name: String
    
    var finishDay: Date {
        get {
            return Calendar.current.date(byAdding: .day, value: 30, to: startDay)!
        }
    }

    init(startDay: Date, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.startDay = startDay
        self.recordID = recordID
        self.name = ""

        let newName: String
        let startMonth = Calendar.current.monthSymbols[Calendar.current.component(.month, from: startDay)]
        let finishMonth = Calendar.current.monthSymbols[Calendar.current.component(.month, from: finishDay)]
        
        if startMonth != finishMonth {
            newName = "\(startMonth)/\(finishMonth) Challange"
        } else {
            newName = "\(startMonth) Challange"
        }
        self.name = newName
    }
    
    init?(record: CKRecord) {
        guard let name = record[Challenge.nameKey] as? String,
            let startDay = record[Challenge.startDayKey] as? Date,
            let weekGoals = record[Challenge.weekGoalsKey] as? [CKRecord.Reference] else {return nil}
        
        self.name = name
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
    }
}
