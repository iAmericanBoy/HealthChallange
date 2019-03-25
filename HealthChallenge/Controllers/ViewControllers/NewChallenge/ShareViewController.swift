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
    
    //MARK: - Properties
    var challengeState = ChallengeState.noActiveChallenge
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        NotificationCenter.default.post(name: NewChallengeParentViewController.pageSwipedNotification, object: nil, userInfo: [NewChallengeParentViewController.pageIndexKey : 3])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let rawValue = UserDefaults.standard.value(forKey: "ChallengeState") as? Int
        challengeState = ChallengeState(rawValue: rawValue ?? 0)!
        switch ChallengeState(rawValue: rawValue ?? 0)! {
        case .isOwnerChallenge:
            updateViewsForOwner()
        case .isParticipantChallenge:
            updateViewsForParticipant()
        case .noActiveChallenge:
            updateViewsForOwner()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted), object: nil, queue: .main) { (notification) in
            print("Second Notification Accepted")
            self.presentAlert()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted))
    }
    
    //MARK: - Actions
    @IBAction func shareButtonTapped(_ sender: Any) {
        challengeState == .isOwnerChallenge ? shareCurrentChallengeAsOwner() : updateViewsForParticipant()
    }
    @IBAction func goToMainViewButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "ActiveChallengeController")
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - Private Functions
    func updateViewsForOwner() {
    }
    
    func updateViewsForParticipant() {
        shareButton.isHidden = true
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func shareCurrentChallengeAsOwner(){
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
    
    private func shareCurrentChallengeAsParticipant(){
        
    }
    
    
} // end class

//MARK: - UICloudSharingControllerDelegate
extension ShareViewController: UICloudSharingControllerDelegate {
    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
        guard let url = csc.share?.url, let challenge = ChallengeController.shared.currentChallenge else {return}
        ChallengeController.shared.add(stringURL: url.absoluteString, toChallenge: challenge) { (isSuccess) in
            if isSuccess {
                print("Succesfully added Url to Challenge")
                print(url)
            }
        }
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

//MARK: - CollectionViewDelegate
extension ShareViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserController.shared.currentUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as? UserCollectionViewCell
        
        cell?.user = UserController.shared.currentUsers[indexPath.row]
        
        return cell ?? UICollectionViewCell()
    }
}
