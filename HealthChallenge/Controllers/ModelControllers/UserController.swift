//
//  UserController.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit
import CloudKit

class UserController {
    //MARK: - Singleton
    static let shared = UserController()
    
    //MARK: - SourceOfTruth
    ///The current logged in user
    var loggedInUser: User?
    
    ///The ID of the icloudUser
    var appleUserID: CKRecord.ID?
    
    //MARK: - init
    init() {
        fetchUserLoggedInUser { (_) in
        }
    }
    
    //MARK: - CRUD
    ///Creates a User With userName and Profile Picture
    /// - parameter name: UserName of the user.
    /// - parameter strengthValue: StrengthValue of the user.
    /// - parameter photo: UserPhoto of the user.
    /// - parameter completion: Handler for when the user was created and uploaded.
    /// - parameter isSuccess: Confirms that the user was created and uploaded.
    func createUserWith(userName name: String, userPhoto photo: UIImage, strengthValue: Int, completion: @escaping (_ isSuccess:Bool) -> Void) {
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error {
                print("There was an error fetching users appleID from cloudkit: \(error)")
                completion(false)
                return
            }
            guard let appleUserID = appleUserRecordID else {completion(false); return}
            
            self.appleUserID = appleUserID
            let reference = CKRecord.Reference(recordID: appleUserID, action: .deleteSelf)
            let newUser = User(userName: name, photo: photo, strengthValue: strengthValue, appleUserRef: reference)
            
            CloudKitController.shared.create(record: CKRecord(user: newUser), inDataBase: CloudKitController.shared.publicDB, completion: { (isSuccess, newRecord) in
                if isSuccess {
                    guard let record = newRecord else {completion(false); return}
                    self.loggedInUser = User(record: record)
                    completion(true)
                }
            })
        }
    }
    
    ///Fetches the Logged in User in the publicDB and assigns it to loggedInUser.
    /// - parameter completion: Handler for when the logged in user could be found.
    /// - parameter isSuccess: Confirms that the Logged in User was found in the PublicDB.
    /// - parameter completion: Handler for when the user was found in the publicDB and added to the property.
    /// - parameter isSuccess: Confirms that the user was found and added to the property.
    func fetchUserLoggedInUser(completion: @escaping (_ isSuccess:Bool) -> Void) {
        
        CloudKitController.shared.fetchUserRecordID { (isSuccess, appleUserRecordID) in
            if isSuccess {
                //load logged in users name and image
                guard let appleUserID = appleUserRecordID else {completion(false);return}
                self.appleUserID = appleUserID

                let reference = CKRecord.Reference(recordID: appleUserID, action: .deleteSelf)
                let predicate = NSPredicate(format: "%K == %@", argumentArray: [User.appleUserRefKey,reference])
                let query = CKQuery(recordType: User.typeKey, predicate: predicate)
                CloudKitController.shared.findRecords(withQuery: query, inDataBase: CloudKitController.shared.publicDB, { (isSuccess, records) in
                    if isSuccess {
                        //set logged in User to found record.
                        guard let record = records.first else {completion(false); return }
                        self.loggedInUser = User(record: record)
                        completion(true)
                    } else {
                        //no public user found in the database.
                        completion(false)
                    }
                })
            } else {
                completion(false)
            }
        }
    }
    
    ///Updates the name or the Photo of a User and saves the change to CK.
    /// - parameter user: The user to be updated.
    /// - parameter newStrengthValue: StrengthValue of the user.
    /// - parameter name: Updated UserName of the user.
    /// - parameter photo: Updated UserPhoto of the user.
    /// - parameter completion: Handler for when the user was updated.
    /// - parameter isSuccess: Confirms that the update has synced to CloudKit.
    func update(user:User, withNewName name: String, andWithNewPhoto photo: UIImage, newStrengthValue: Int, _ completion: @escaping (_ isSuccess:Bool) -> Void) {
        user.photo = photo
        user.userName = name
        user.strengthValue = newStrengthValue
        let updatedRecord = CKRecord(user: user)
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.publicDB, recordsToUpdate: [updatedRecord], purchasesToDelete: []) { (isSuccess, updatedRecords, _) in
            if isSuccess {
                guard let record = updatedRecords?.first, updatedRecord.recordID == record.recordID else {completion(false);return}
                completion(true)
            }
        }
    }
    
    ///Sets the monthly goal for a particular challenge of a user.
    /// - parameter goal: The goal that will be the new monthly challange of the user.
    /// - parameter challenge: the Challange the monthly goal is getting set for.
    /// - parameter user: The user that will have a new monthly goal
    /// - parameter completion: Handler for when the user was updated.
    /// - parameter isSuccess: Confirms that the update has synced to CloudKit.
    func set(monthlyGoal goal: Goal, inChallenge challenge: Challenge, forUser user: User,_ completion: @escaping (_ isSuccess:Bool) -> Void) {
        user.monthlyChallanges[CKRecord.Reference(recordID: challenge.recordID, action: .none)] = CKRecord.Reference(recordID: goal.recordID, action: .none)
        let record = CKRecord(user: user)
        
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.publicDB, recordsToUpdate: [record], purchasesToDelete: []) { (isSuccess, updatedRecords, _) in
            if isSuccess {
                guard let updatedRecord = updatedRecords?.first, updatedRecord.recordID == record.recordID else {completion(false); return}
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    ///Deletes the user from CK and removes the loggedInUser Reference.
    /// - parameter user: The user that will be deleted
    /// - parameter completion: Handler for when the user was deleted.
    /// - parameter isSuccess: Confirms that the delete has synced to CloudKit.
    func delete(User user: User , _ completion: @escaping (_ isSuccess:Bool) -> Void) {
        let deletedRecord = CKRecord(user: user)
        CloudKitController.shared.saveChangestoCK(inDataBase: CloudKitController.shared.publicDB, recordsToUpdate: [], purchasesToDelete: [deletedRecord.recordID]) { (isSuccess, _, purchasesToDelete) in
            if isSuccess {
                guard let recordID = purchasesToDelete?.first, deletedRecord.recordID == recordID else {completion(false);return}
                self.loggedInUser = nil
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
