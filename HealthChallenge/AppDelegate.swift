//
//  AppDelegate.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    
    func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        
        let acceptSharing: CKAcceptSharesOperation = CKAcceptSharesOperation(shareMetadatas: [cloudKitShareMetadata])
        
        acceptSharing.qualityOfService = .userInteractive
        acceptSharing.perShareCompletionBlock = {meta, share, error in
            if let error = error {
                print("An error accepting a CKShare has occured: \(error), \(error.localizedDescription)")
            }
            
            CloudKitController.shared.fetchRecordZonesInTheSharedDataBase(completion: { (isSuccess, foundZones) in
                if isSuccess {
                    foundZones?.forEach({ (zone) in
                        ChallengeController.shared.fetchCurrentChallenge(inDataBase: CloudKitController.shared.shareDB, inZoneWithID: zone.zoneID, { (isSuccess) in
                            if isSuccess {
                                print("Shared Challenge is now current Challenge")
                                let challengeFound = Notification(name: Notification.Name(rawValue: NotificationStrings.challengeFound), object: nil, userInfo: nil)
                                NotificationCenter.default.post(challengeFound)
                            }
                        })
                    })
                }
            })

            print("successfully shared")
        }
        acceptSharing.acceptSharesCompletionBlock = { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        CKContainer(identifier: cloudKitShareMetadata.containerIdentifier).add(acceptSharing)
    }
}

