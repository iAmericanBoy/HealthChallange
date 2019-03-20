//
//  WorkoutController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/20/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit
import HealthKit

class WorkoutController {
    // singleton
    static let shared = WorkoutController()
    // source of truth
    var workouts: [Workout] = []
    
    // MARK: - CRUD
    
    /**
     Creates a workout with start time, end time, duration, activity, completing with adding workout to workouts array.
     - parameter startTime: Start date of the workout
     - parameter endTime: End date of the workout
     - parameter duration: Total time interval of the workout
     - parameter activity: Activity as input by the user
     - parameter completion: Handler for when the workout is created and appended.
    */
    func createWorkoutWith(startTime: Date, endTime: Date, duration: TimeInterval, activity: String, completion: @escaping (Bool) -> Void) {
        // Add support for tracking calories burned?
        
        CloudKitController.shared.fetchUserRecordID { (success, userRecordID) in
            let newWorkout = Workout(start: startTime, end: endTime, duration: duration, activity: activity, caloriesBurned: nil, reference: nil)
            
            if success {
                guard let userRecordID = userRecordID else { completion(false) ; return }
                newWorkout.reference = CKRecord.Reference(recordID: userRecordID, action: .deleteSelf)
            }
            
            let record = CKRecord(workout: newWorkout)
            CloudKitController.shared.create(record: record, inDataBase: CloudKitController.shared.publicDB, completion: { (success, newRecord) in
                if success {
                    guard let newRecord = newRecord, newRecord.recordID == record.recordID else { completion(false) ; return }
                    self.workouts.append(newWorkout)
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
    }
    
    //fetch
    func fetchUsersWorkouts(completion: @escaping (Bool) -> Void) {
        CloudKitController.shared.fetchUserRecordID { (success, recordID) in
            if success {
                guard let recordID = recordID else { return }
                
                let predicate = NSPredicate(format: "%K === %@", argumentArray: [Workout.referenceKey, recordID])
                let query = CKQuery(recordType: Workout.typeKey, predicate: predicate)
                
                CloudKitController.shared.findRecords(withQuery: query, inDataBase: CloudKitController.shared.publicDB, { (success, foundRecords) in
                    if success {
                        let foundWorkouts = foundRecords.compactMap({ Workout(record: $0)})
                        self.workouts = foundWorkouts
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            } else {
                completion(false)
            }
        }
    }
    
    func transformHKWorkoutsFrom(startDate: Date, endDate: Date) -> [Workout] {
        let healthKitWorkouts = HealthKitController.shared.readWorkoutsFrom(date: startDate, toDate: endDate)
        var transformedWorkouts: [Workout] = []
        var index = 0
        
        for _ in transformedWorkouts {
            let preTransformWorkout = healthKitWorkouts[index]
            let startDate = preTransformWorkout.startDate
            let endDate = preTransformWorkout.endDate
            let duration = preTransformWorkout.duration
            let caloriesBurnedHK = preTransformWorkout.totalEnergyBurned?.doubleValue(for: HKUnit.largeCalorie())
            let activityHK = "Imported Workout: \(preTransformWorkout.workoutActivityType)"
            let workout = Workout(start: startDate, end: endDate, duration: duration, activity: activityHK, caloriesBurned: caloriesBurnedHK, reference: nil)
            transformedWorkouts.append(workout)
            index += 1
        }
        return transformedWorkouts
    }

    // update
    
    // delete
    func delete(workout: Workout, completion: @escaping (Bool) -> Void) {
        let recordID = CKRecord(workout: workout).recordID
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.publicDB, recordsToUpdate: [], purchasesToDelete: [recordID]) { (success, _, deletedRecords) in
            if success {
                guard let deletedRecordID = deletedRecords?.first, deletedRecordID == recordID else { completion(false) ; return }
                if let workoutIndex = self.workouts.index(of: workout) {
                    self.workouts.remove(at: workoutIndex)
                }
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
