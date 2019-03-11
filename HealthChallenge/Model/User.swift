//
//  User.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit
import CloudKit

class User {
    
    var userName: String
    var appleUserRef: CKRecord.Reference
    var recordID:CKRecord.ID
    var photoData: Data?
    var strengthValue: Int
    
    
    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirecotryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirecotryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try photoData?.write(to: fileURL)
            } catch let error {
                print("Error writing to temp url \(error) \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    var photo: UIImage? {
        get{
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        }
        set{
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    
    init(userName: String, photo: UIImage, strengthValue: Int, appleUserRef: CKRecord.Reference, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.userName = userName
        self.appleUserRef = appleUserRef
        self.recordID = recordID
        self.strengthValue = strengthValue
        self.photo = photo
    }
    
    init?(record: CKRecord) {
        guard let name = record[User.usernameKey] as? String,
            let appleUserRef = record[User.appleUserRefKey] as? CKRecord.Reference,
            let strengthValue = record[User.strengthValueKey] as? Int,
            let imageAsset = record[User.photoKey] as? CKAsset else {return nil}
        
        self.appleUserRef = appleUserRef
        self.userName = name
        self.recordID = record.recordID
        self.strengthValue = strengthValue
        
        do {
            try self.photoData = Data(contentsOf: imageAsset.fileURL)
        } catch {
            print("unable to unwrap photoData from the CKAsset. This is the error:  \(error), \(error.localizedDescription)")
        }
    }
}


extension CKRecord {
    
    convenience init(user: User) {
        self.init(recordType: User.typeKey, recordID: user.recordID)
        
        self.setValue(user.userName, forKey: User.usernameKey)
        self.setValue(user.appleUserRef, forKey: User.appleUserRefKey)
        self.setValue(user.imageAsset, forKey: User.photoKey)
    }
}
