//
//  Workout.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/20/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit

class Workout {
    
    var start: Date
    var end: Date
    var duration: TimeInterval
    var activity: String
    var caloriesBurned: Double?
    var reference: CKRecord.Reference?
    var recordID: CKRecord.ID
    
    init(start: Date, end: Date, duration: TimeInterval, activity: String, caloriesBurned: Double?, reference: CKRecord.Reference?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.start = start
        self.end = end
        self.duration = duration
        self.activity = activity
        self.caloriesBurned = caloriesBurned
        self.recordID = recordID
        self.reference = reference
    }

    init?(record: CKRecord) {
        guard let start = record[Workout.startKey] as? Date,
            let end = record[Workout.endKey] as? Date,
            let duration = record[Workout.durationKey] as? TimeInterval,
            let activity = record[Workout.activityKey] as? String,
            let reference = record[Workout.referenceKey] as? CKRecord.Reference
            else { return nil }
        
        self.recordID = record.recordID
        self.reference = reference
        self.start = start
        self.end = end
        self.duration = duration
        self.activity = activity
        self.caloriesBurned = record[Workout.caloriesBurnedKey] as? Double
    }
}

extension Workout: Equatable {
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

extension CKRecord {
    convenience init(workout: Workout) {
        self.init(recordType: Workout.typeKey, recordID: workout.recordID)
        
        self.setValue(workout.start, forKey: Workout.startKey)
        self.setValue(workout.end, forKey: Workout.endKey)
        self.setValue(workout.duration, forKey: Workout.durationKey)
        self.setValue(workout.activity, forKey: Workout.activityKey)
        self.setValue(workout.caloriesBurned, forKey: Workout.caloriesBurnedKey)
        self.setValue(workout.reference, forKey: Workout.referenceKey)
    }
}
