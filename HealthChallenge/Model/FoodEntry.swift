//
//  FoodEntry.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/27/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit

class FoodEntry {
    let appleUserRef: CKRecord.Reference
    let date: Date
    let recordID: CKRecord.ID
    
    init(appleUserRef: CKRecord.Reference, date: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.appleUserRef = appleUserRef
        self.date = date
        self.recordID = recordID
    }
    
    init?(record: CKRecord) {
        guard let appleUserRef = record[FoodEntry.appleUserRefKey] as? CKRecord.Reference,
            let date = record[FoodEntry.dateKey] as? Date else {return nil}
        
        self.recordID = record.recordID
        self.appleUserRef = appleUserRef
        self.date = date
    }
}

extension CKRecord {
    convenience init(foodEntry: FoodEntry) {
        self.init(recordType: FoodEntry.typeKey, recordID: foodEntry.recordID)
        
        self.setValue(foodEntry.appleUserRef, forKey: FoodEntry.appleUserRefKey)
        self.setValue(foodEntry.date, forKey: FoodEntry.dateKey)
    }
}
