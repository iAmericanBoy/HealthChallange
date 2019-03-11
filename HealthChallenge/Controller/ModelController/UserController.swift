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
    var loggedInUser: User?
    
    //MARK: - CRUD
    ///Creates a User With userName and Profile Picture
    /// - parameter name: UserName of the user.
    /// - parameter photo: UserPhoto of the user.
    func createUserWith(userName name: String, userPhoto photo: UIImage, completion: @escaping (Bool) -> Void) {
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error {
                print("There was an error fetching users appleID from cloudkit: \(error)")
                completion(false)
                return
            }
            guard let appleUserRef = appleUserRecordID else {completion(false); return}
            
            let reference = CKRecord.Reference(recordID: appleUserRef, action: .deleteSelf)
            
            let newUser = User(userName: name, photo: photo, appleUserRef: reference)
            
            CloudKitController.shared.create(record: CKRecord(user: newUser), inDataBase: CloudKitController.shared.publicDB, completion: { (isSuccess, newRecord) in
                if isSuccess {
                    guard let record = newRecord else {completion(false); return}
                    self.loggedInUser = User(record: record)
                    completion(true)
                }
            })
        }
    }
    
    ///Fetches the Logged in User
    /// - parameter completion: Handler for when
    /// - parameter isSuccess: Confirms that the change has synced to CloudKit.
    func fetchUser(completion: @escaping (_ isSuccess:Bool) -> Void) {
        
        CloudKitController.shared.fetchUserRecordID { (isSuccess, appleUserRef) in
            if isSuccess {
                //load logged in users name and image
                guard let userRef = appleUserRef else {completion(false);return}
                
                let reference = CKRecord.Reference(recordID: userRef, action: .deleteSelf)
                let predicate = NSPredicate(format: "%K == %@", argumentArray: [User.appleUserRefKey,reference])
                let query = CKQuery(recordType: User.typeKey, predicate: predicate)
                CloudKitController.shared.findRecords(withQuery: query, inDataBase: CloudKitController.shared.publicDB, { (isSuccess, records) in
                    if isSuccess {
                        //set logged in User to found record
                        guard let record = records.first else {completion(false); return }
                        self.loggedInUser = User(record: record)
                        completion(true)
                    } else {
                        //no public user found
                        completion(false)
                    }
                })
            }
        }
    }
}
