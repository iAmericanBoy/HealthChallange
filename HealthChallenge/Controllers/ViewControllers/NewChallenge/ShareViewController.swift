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
    
    
    //MARK: - Private Functions
    private func shareCurrentChallenge(){

        guard let challenge = ChallengeController.shared.currentChallenge else {return}
        
        
        
        let sharingViewController = UICloudSharingController { (controller, completion: @escaping (CKShare?, CKContainer?, Error?) -> Void) in
            
            CloudKitController.shared.share(rootRecord: CKRecord(challenge: challenge), completion)
        }
        
        
        sharingViewController.delegate = self
        
        self.present(sharingViewController, animated: true)
        
    }
    
    
} // end class

extension ShareViewController: UICloudSharingControllerDelegate {
    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
        print("saved successfully")
    }
    
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("failed to save: \(error.localizedDescription)")
    }
    
    func itemThumbnailData(for csc: UICloudSharingController) -> Data? {
        return nil //You can set a hero image in your share sheet. Nil uses the default.
    }
    
    func itemTitle(for csc: UICloudSharingController) -> String? {
        return ChallengeController.shared.currentChallenge?.name
    }
}
