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
    /// The shared Database of the User.
    let shareDB = CKContainer.default().sharedCloudDatabase
    
    /// The the private RecordZone for the Challenge
    var privateRecordZone: CKRecordZone?
    
    //MARK: - INIT
    init() {
        fetchprivateRecordZone { (isSuccess) in
            if isSuccess {
                print("RecordZone Found")
            } else {
                self.createRecordZone(withName: "private", completion: { (isSuccess) in
                    if isSuccess {
                        print("RecordZone created")
                    }
                })
            }
        }
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
    
    
    ///Creates a RecordZone in the PrivateDataBase
    /// - parameter name: The name for the record Zone.
    /// - parameter completion: Handler for when the zone was created.
    /// - parameter isSuccess: Confirms the zone was created.
    func createRecordZone(withName name: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let newRecordZone = CKRecordZone(zoneID: CKRecordZone.ID(zoneName: name))
        
        
        let operation = CKModifyRecordZonesOperation(recordZonesToSave: [newRecordZone])
        operation.modifyRecordZonesCompletionBlock = { (savedZone,_,error) in
            if let error = error {
                print("There was an error creating a recordZone in CK: \(error)")
                completion(false)
                return
            }
            
            guard let recordZone = savedZone?.first, newRecordZone == recordZone else {completion(false); return}
            self.privateRecordZone = newRecordZone
            completion(true)
        }
        
        privateDB.add(operation)
    }
    
    ///Fetches the custum created private RecordZone in the provateDB.
    /// - parameter completion: Handler for when the zone was found.
    /// - parameter isSuccess: Confirms the zone was found.
    func fetchprivateRecordZone(completion: @escaping (_ isSuccess: Bool) -> Void) {
        privateDB.fetch(withRecordZoneID: CKRecordZone.ID(zoneName: "private")) { (foundZone, error) in
            if let error = error {
                print("There was an error fetching the private recordZone in CK: \(error)")
                completion(false)
                return
            }
            if let foundZone = foundZone {
                self.privateRecordZone = foundZone
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    ///Fetches all RecordZones in the sharedDatabase.
    /// - parameter completion: Handler for when the zones where found
    /// - parameter isSuccess: Confirms the zones where found
    /// - parameter foundRecordZones: The found RecordZones
    func fetchRecordZonesInTheSharedDataBase(completion: @escaping (_ isSuccess: Bool, _ foundRecordZones: [CKRecordZone]?) -> Void) {
        shareDB.fetchAllRecordZones { (allRecordZones, error) in
            if let error = error {
                print("There was an error fetching all recordZones: \(error)")
                completion(false,nil)
                return
            }
            completion(true, allRecordZones)
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
    
    ///Fetches the Metadata of a share for a given URL
    /// - parameter daturlaBase: The URL for the CKShare.
    func fetchShareMetadata(forURL url: URL){
    
    let operation = CKFetchShareMetadataOperation(shareURLs: [url])
        operation.perShareMetadataBlock = { (url,meta,error) in
            
        }
        
        operation.fetchShareMetadataCompletionBlock = { error in
            
        }
        CKContainer.default().add(operation)
    }

    
    //MARK: - Share
    /// Shares the RootRecord and save it to the privateDataBase.
    /// - parameter record: The RootRecord to share.
    /// - parameter completion: Handler for when the rootrecord has been shared.
    /// - parameter container: The RootRecord to share.
    func share(rootRecord record: CKRecord, _ completion: @escaping (_ sharedRecord: CKShare?, _ container: CKContainer?, _ error: Error?) -> Void) {
        
        let shareRecord = CKShare(rootRecord: record)
        let container = CKContainer.default()

        
        saveChangestoCK(inDataBase: privateDB, recordsToUpdate: [record, shareRecord], purchasesToDelete: []) { (isSuccess, savedRecords, _) in
            if isSuccess {
                completion(shareRecord, container, nil)
            } else {
                completion(nil, nil, nil)
            }
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
