//
//  CloudKitController.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitController {
    
    //MARK: - Singleton
    /// The shared Instance of CloudKitController.
    static let shared = CloudKitController()
    
    //MARK: - Properties
    /// The private Database of the User.
    let privateDB = CKContainer.default().privateCloudDatabase
    /// The public Database of the User.
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: - INIT
    init() {
        //        createZone(withName: Purchase.privateRecordZoneName) { (isSuccess, newZone) in
        //            if !isSuccess {
        //                print("Could not create new zone.")
        //            }
        //        }
    }
    
    //MARK: - CRUD
    /// Creates new Record in CloudKit.
    /// - parameter record: The record to be created.
    /// - parameter dataBase: The dataBase the record should be created in.
    /// - parameter completion: Handler for when the record has been created.
    /// - parameter isSuccess: Confirms the new purchase was created.
    /// - parameter newRecord: The new Record or nil.
    func create(record: CKRecord, inDataBase dataBase: CKDatabase, completion: @escaping (_ isSuccess: Bool, _ newRecord: CKRecord?) -> Void) {
        
        saveChangestoCK(inDataBase: dataBase, recordsToUpdate: [record], purchasesToDelete: []) { (isSuccess, savedRecords, _) in
            if isSuccess {
                guard let newRecord = savedRecords?.first , newRecord.recordID == record.recordID else {
                    completion(false, nil)
                    return
                }
                completion(true,newRecord)
            } else {
                completion(false, nil)
            }
        }
    }
    
    ///Fetches the UserRecordID.
    /// - parameter completion: Handler for when the UserRecord could be found.
    /// - parameter isSuccess: Confirms the record could be found.
    /// - parameter newRecord: The recordID or nil.
    func fetchUserRecordID(_ completion: @escaping (_ isSuccess:Bool, _ userRecordID: CKRecord.ID?) -> Void) {
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error {
                print("There was an error fetching users appleID from cloudkit: \(error)")
                completion(false,appleUserRecordID)
                return
            }
            guard let appleUserRef = appleUserRecordID else {completion(false,appleUserRecordID); return}
            
            completion(true,appleUserRef)
        }
    }
    
    ///Performs a Query on the given Database.
    /// - parameter query: The Query to be performed.
    /// - parameter dataBase: The dataBase the record should be created in.
    /// - parameter completion: Handler for when the query could be found.
    /// - parameter isSuccess: Confirms the query found records.
    /// - parameter records: The array of found records or empty array.
    func findRecords(withQuery query: CKQuery, inDataBase dataBase: CKDatabase, inZoneWith zoneID: CKRecordZone.ID? = nil , _ completion: @escaping (_ isSuccess:Bool, _ records: [CKRecord]) -> Void) {
        
        dataBase.perform(query, inZoneWith: zoneID) { (foundRecords, error) in
            if let error = error {
                print("There was an error performing the query in cloudkit: \(error)")
                completion(false,[])
                return
            }
            guard let records = foundRecords else {return}
            completion(true,records)
        }
    }
    
    //MARK: - Save
    /// Updates and Deletes changes to CloudKit.
    /// - parameter database: The database where the records should be deleted or updated in.
    /// - parameter records: Records that where updated or created.
    /// - parameter recordIDs: RecordIDs of record that need deleted.
    /// - parameter completion: Handler for when the Record has been deleted or updated/saved.
    /// - parameter isSuccess: Confirms that the change has synced to CloudKit.
    /// - parameter savedRecords: The saved records (can be nil).
    /// - parameter deletedRecordIDs: The deleted recordIDs (can be nil).
    func saveChangestoCK(inDataBase dataBase: CKDatabase, recordsToUpdate records: [CKRecord], purchasesToDelete recordIDs: [CKRecord.ID], completion: @escaping (_ isSuccess: Bool,_ savedRecords: [CKRecord]?, _ deletedRecordIDs: [CKRecord.ID]?) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: recordIDs)
        operation.savePolicy = .changedKeys
        operation.modifyRecordsCompletionBlock = { (savedRecords,deletedRecords,error) in
            if let error = error {
                print("An Error updating CK has occured. \(error), \(error.localizedDescription)")
                completion(false, savedRecords,deletedRecords)
                return
            }
            guard let saved = savedRecords, let deleted = deletedRecords else {completion(false,savedRecords,deletedRecords); return}
            completion(true,saved,deleted)
        }
        dataBase.add(operation)
    }
}
