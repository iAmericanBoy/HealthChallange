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
    var weekOneGoal:CKRecord.Reference?
    var weekTwoGoal:CKRecord.Reference?
    var weekThreeGoal:CKRecord.Reference?
    var weekFourGoal:CKRecord.Reference?

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
        let startMonth = Calendar.current.monthSymbols[Calendar.current.component(.month, from: startDay) - 1]
        let finishMonth = Calendar.current.monthSymbols[Calendar.current.component(.month, from: finishDay) - 1]
        
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
            let weekOneGoal = record[Challenge.weekOneGoalKey] as? CKRecord.Reference,
            let weekTwoGoal = record[Challenge.weekTwoGoalKey] as? CKRecord.Reference,
            let weekThreeGoal = record[Challenge.weekThreeGoalKey] as? CKRecord.Reference,
            let weekFourGoal = record[Challenge.weekFourGoalKey] as? CKRecord.Reference else {return nil}
        
        self.name = name
        self.weekOneGoal = weekOneGoal
        self.weekTwoGoal = weekTwoGoal
        self.weekThreeGoal = weekThreeGoal
        self.weekFourGoal = weekFourGoal
        self.startDay = startDay
        self.recordID = record.recordID
    }
}

extension CKRecord {
    
    convenience init(challenge: Challenge) {
        self.init(recordType: Challenge.typeKey, recordID: challenge.recordID)
        
        self.setValue(challenge.name, forKey: Challenge.nameKey)
        self.setValue(challenge.startDay, forKey: Challenge.startDayKey)
        self.setValue(challenge.weekOneGoal, forKey: Challenge.weekOneGoalKey)
        self.setValue(challenge.weekTwoGoal, forKey: Challenge.weekTwoGoalKey)
        self.setValue(challenge.weekThreeGoal, forKey: Challenge.weekThreeGoalKey)
        self.setValue(challenge.weekFourGoal, forKey: Challenge.weekFourGoalKey)
    }
}
