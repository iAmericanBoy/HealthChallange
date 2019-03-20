//
//  InviteOthersViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit
import CloudKit


class ShareViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var inviteOthersLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NewChallengeParentViewController.pageSwipedNotification, object: nil, userInfo: [NewChallengeParentViewController.pageIndexKey : 3])
    }
    
    //MARK: - Actions
    @IBAction func shareButtonTapped(_ sender: Any) {
        shareCurrentChallenge()
    }
    @IBAction func goToMainViewButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "ActiveChallengeController")
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - Private Functions
    private func shareCurrentChallenge(){

        guard let challenge = ChallengeController.shared.currentChallenge, let record = CKRecord(challenge: challenge) else {return}
        let share = CKShare(rootRecord: record)
        share.publicPermission = .readWrite
        
        let sharingViewController = UICloudSharingController(preparationHandler: {(UICloudSharingController, handler: @escaping (CKShare?, CKContainer?, Error?) -> Void) in
            let operation = CKModifyRecordsOperation(recordsToSave: [record,share], recordIDsToDelete: nil)
            operation.savePolicy = .changedKeys

            operation.modifyRecordsCompletionBlock = { (savedRecord, _,error) in
                handler(share, CKContainer.default(), error)
            }
            
            
            operation.perRecordCompletionBlock = { (savedRecord,error) in
                if let error = error {
                    print(error)
                }
            }
            
            CloudKitController.shared.privateDB.add(operation)
        })
        
        
        
        sharingViewController.delegate = self
        
        self.present(sharingViewController, animated: true)
        
    }
    
    
} // end class

extension ShareViewController: UICloudSharingControllerDelegate {
    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
        print(csc.share?.url)
        print("CKShare saved successfully")
    }
    
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("failed to save ckshare: \(error),\(error.localizedDescription)")
    }
    
    func itemThumbnailData(for csc: UICloudSharingController) -> Data? {
        return nil //You can set a hero image in your share sheet. Nil uses the default.
    }
    
    func itemTitle(for csc: UICloudSharingController) -> String? {
        return ChallengeController.shared.currentChallenge?.name
    }
}
