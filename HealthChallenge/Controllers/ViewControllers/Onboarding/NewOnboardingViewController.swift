//
//  OnboardingViewController.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/23/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit
import CloudKit


class NewOnboardingViewController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: - Outlets
    var collectionView: UICollectionView?
    let imagePicker = UIImagePickerController()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handelNext), for: .touchUpInside)
        return button
    }()
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handelPrevious), for: .touchUpInside)
        return button
    }()
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = screenCount
        pc.currentPageIndicatorTintColor = UIColor.purple
        pc.pageIndicatorTintColor = .gray
        pc.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        return pc
    }()
    
    //MARK: - Properties
    var screenCount = 1 {
        didSet {
            collectionView?.reloadData()
            pageControl.numberOfPages = screenCount
        }
    }
    var profilePicture: UIImage? = UserController.shared.loggedInUser?.photo
    var challengeState = ChallengeState.noActiveChallenge

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = FontController.titleFont
        
        let rawValue = UserDefaults.standard.value(forKey: "ChallengeState") as? Int
        challengeState = ChallengeState(rawValue: rawValue ?? 0)!

        view.backgroundColor = .white
        imagePicker.delegate = self
        setupCollectionView()
        setupBottonControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentIndex = IndexPath(item: screenCount - 1, section: 0)
        collectionView?.scrollToItem(at: currentIndex,at: .left,animated: false)
        pageControl.currentPage = screenCount - 1
        setTitle()

        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted), object: nil, queue: .main) { (notification) in
            print("Second Notification Accepted")
            self.presentAlert()
        }
        NotificationCenter.default.addObserver(forName: Notification.Name(NotificationStrings.weekGoalsFound), object: nil, queue: .main) { [weak self] (_) in
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.challengeFound), object: nil, queue: nil) { [weak self] (_) in
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.monthGoalFound), object: nil, queue: .main) { [weak self] (_) in
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted))
    }
    
    //MARK: - Actions
    @objc fileprivate func handelNext() {
        let nextIndex = min(pageControl.currentPage + 1, pageControl.numberOfPages - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        setTitle()
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    @objc fileprivate func handelPrevious() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        setTitle()
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    //MARK: - Private Functions
    fileprivate func setTitle() {
        switch pageControl.currentPage {
        case 0:
            self.title = UserController.shared.loggedInUser?.userName ?? "HELLO"
        case 1:
            self.title = "START DAY"
        case 2:
            self.title = "WEEKLY GOALS"
        case 3:
            self.title = "MONTH GOAL"
        case 4:
            self.title = "SHARE"
        default:
            self.title = "\(pageControl.currentPage)"
        }
    }
    
    fileprivate func setupBottonControls() {
        let bottomControlStackView = UIStackView(arrangedSubviews: [previousButton,pageControl,nextButton])
        bottomControlStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlStackView.distribution = .fillEqually
        
        view.addSubview(bottomControlStackView)
        
        bottomControlStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomControlStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        bottomControlStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomControlStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    fileprivate func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView?.contentInsetAdjustmentBehavior = .scrollableAxes
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.clipsToBounds = true
        view.addSubview(collectionView!)
        
        registerCells()
    }
    
    fileprivate func registerCells() {
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView?.register(SignUpCollectionViewCell.self, forCellWithReuseIdentifier: "signUpCell")
        collectionView?.register(StartDayCollectionViewCell.self, forCellWithReuseIdentifier: "startDateCell")
        collectionView?.register(WeeklyGoalsCollectionViewCell.self, forCellWithReuseIdentifier: "weeklyGoalsCell")
        collectionView?.register(MonthGoalCollectionViewCell.self, forCellWithReuseIdentifier: "monthGoalCell")
        collectionView?.register(ShareCollectionViewCell.self, forCellWithReuseIdentifier: "shareCell")
    }
}

//MARK: - UICollectionViewFlowLayout
extension NewOnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension NewOnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
        
        setTitle()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = screenCount
        return screenCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            //signUp
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "signUpCell", for: indexPath) as? SignUpCollectionViewCell
            
            cell?.delegate = self
            profilePicture = UserController.shared.loggedInUser?.photo
            if let profilePicture = profilePicture {
                cell?.profilePhoto = profilePicture
            } else {
                cell?.profilePhoto = UIImage(named: "stockPhoto")
            }
            cell?.user = UserController.shared.loggedInUser
            
            return cell ?? UICollectionViewCell()
        case 1:
            //startDay
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "startDateCell", for: indexPath) as? StartDayCollectionViewCell
            
            cell?.delegate = self
            cell?.activeChallenge = ChallengeController.shared.currentChallenge
            
            return cell ?? UICollectionViewCell()
        case 2:
            //weeklyGoals
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weeklyGoalsCell", for: indexPath) as? WeeklyGoalsCollectionViewCell
            
            cell?.delegate = self
            cell?.challengeState = challengeState
            cell?.selectedGoals = GoalController.shared.weeklyGoals
            
            return cell ?? UICollectionViewCell()
        case 3:
            //monthGoals
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthGoalCell", for: indexPath) as? MonthGoalCollectionViewCell
            
            cell?.delegate = self
            cell?.selectedWeekGoals = GoalController.shared.weeklyGoals
            cell?.selectedGoal = GoalController.shared.monthGoal
            
            return cell ?? UICollectionViewCell()
        case 4:
            //share
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shareCell", for: indexPath) as? ShareCollectionViewCell
            
            cell?.delegate = self
            
            return cell ?? UICollectionViewCell()
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
            return cell
        }
    }
}

//MARK: - SignUpCollectionViewCellDelegate
extension NewOnboardingViewController: SignUpCollectionViewCellDelegate {
    func save(user: User?, withName name: String, andUserPhoto photo: UIImage?, andLifeStyleValue value: Int) {
        let userPhoto = photo ?? UIImage(named: "stockPhoto")!

        if let user = user {
            //update
            UserController.shared.update(user: user, withNewName: name, andWithNewPhoto: userPhoto, newStrengthValue: value) { (isSuccess) in
                
                if isSuccess {
                    DispatchQueue.main.async {
                        self.screenCount = max(2,self.screenCount)
                        self.handelNext()
                    }
                }
            }
        } else {
            //create New
            UserController.shared.createUserWith(userName: name, userPhoto: userPhoto, strengthValue: value) { (isSuccess) in
                if isSuccess {
                    DispatchQueue.main.async {
                        self.screenCount = max(2,self.screenCount)
                        self.handelNext()
                    }
                }
            }
        }
    }
    
    func selectPhoto() {
        let selectImageAlert = UIAlertController(title: "Add a Profile Photo", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.openGallery()
        }
        selectImageAlert.addAction(cancelAction)
        selectImageAlert.addAction(cameraAction)
        selectImageAlert.addAction(photoLibraryAction)
        
        present(selectImageAlert, animated: true, completion: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate
extension NewOnboardingViewController: UIImagePickerControllerDelegate {
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "No Camera Access", message: "Please allow access to the camera to use this feature.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Back", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "No Photos Access", message: "Please allow access to Photos to use this feature.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Back", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePicture = pickedImage
            collectionView?.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - StartDayCollectionViewCellDelegate
extension NewOnboardingViewController: StartDayCollectionViewCellDelegate {
    func save(challenge: Challenge?, withDate date: Date?) {
        guard let date = date else {return}
        
        if let currentChallenge = ChallengeController.shared.currentChallenge {
            //update the date
            ChallengeController.shared.update(challenge: currentChallenge, withNewStartDate: date) { (isSuccess) in
                if isSuccess {
                    // handle
                    let finishDay = ChallengeController.shared.currentChallenge?.finishDay
                    UserDefaults.standard.set(finishDay, forKey: UserDefaultStrings.currentChallengeFinishDay)
                    DispatchQueue.main.async {
                        switch self.challengeState {
                        case .isOwnerChallenge:
                            self.screenCount = max(3,self.screenCount)
                        case .isParticipantChallenge:
                            self.screenCount = max(4,self.screenCount)
                        case .noActiveChallenge:
                            self.screenCount = max(3,self.screenCount)
                        }
                        self.handelNext()
                    }
                }
            }
        } else {
            // create new Challenge with date
            ChallengeController.shared.createNewChallenge(withStartDate: date) { (isSuccess) in
                if isSuccess {
                    // handle
                    let finishDay = ChallengeController.shared.currentChallenge?.finishDay
                    UserDefaults.standard.set(finishDay, forKey: UserDefaultStrings.currentChallengeFinishDay)
                    DispatchQueue.main.async {
                        switch self.challengeState {
                        case .isOwnerChallenge:
                            self.screenCount = max(3,self.screenCount)
                        case .isParticipantChallenge:
                            self.screenCount = max(4,self.screenCount)
                        case .noActiveChallenge:
                            self.screenCount = max(3,self.screenCount)
                        }
                        self.handelNext()
                    }
                }
            }
        }
    }
}

//MARK: - GoalsCollectionViewCellDelegate
extension NewOnboardingViewController: GoalsCollectionViewCellDelegate {
    func save(monthGoal: Goal) {
        guard let userID = UserController.shared.appleUserID, let challengeID = ChallengeController.shared.currentChallenge?.recordID else {return}
        let dispatchGroup = DispatchGroup()
        if let oldGoal = GoalController.shared.monthGoal {
            dispatchGroup.enter()
            GoalController.shared.remove(userRef: CKRecord.Reference(recordID: userID, action: .none), fromGoal: oldGoal ) { (isSuccess) in
                if isSuccess {
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.enter()
        GoalController.shared.add(newUserReference: CKRecord.Reference(recordID: userID, action: .none), toGoal: monthGoal, forChallenge: CKRecord.Reference(recordID: challengeID, action: .none))  { (isSuccess) in
            if isSuccess {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.screenCount = max(5,self.screenCount)
            self.handelNext()
        }
    }
    
    func save(newGoalWithName name: String, toReviewForPublic: Bool) {
        GoalController.shared.createGoalWith(goalName: name, reviewForPublic: toReviewForPublic) { (isSuccess) in
            if isSuccess {
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    func save(weeklyGoals: [Goal]) {
        guard let challenge = ChallengeController.shared.currentChallenge else {return}
        let dispatchGroup = DispatchGroup()
        GoalController.shared.weeklyGoals.forEach { (goal) in
            dispatchGroup.enter()
            GoalController.shared.remove(challenge: challenge, fromGoal: goal, { (isSuccess) in
                if isSuccess {
                    dispatchGroup.leave()
                }
            })
        }
        
        weeklyGoals.forEach { (goal) in
            dispatchGroup.enter()
            GoalController.shared.add(newChallenge: challenge, toGoal: goal, { (isSuccess) in
                if isSuccess {
                    dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            self.handelNext()
        }
    }
}

//MARK: - ShareCollectionViewCellDelegate
extension NewOnboardingViewController: ShareCollectionViewCellDelegate {
    func shareCurrentChallenge() {
        switch challengeState {
        case .isOwnerChallenge:
            if let share = ChallengeController.shared.currentShare {
                let sharingViewController = UICloudSharingController(share: share, container: CKContainer.default())
                sharingViewController.delegate = self
                
                self.present(sharingViewController, animated: true)

            } else {
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
        case .isParticipantChallenge:
            guard let shareURL = ChallengeController.shared.currentShare?.url else {return}
            let activityViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
            present(activityViewController, animated: true, completion: {})

        case .noActiveChallenge:
            break
        }
    }
    
    func mainApp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ActiveChallengeController")
        self.present(viewController, animated: true, completion: nil)
    }
}

//MARK: - UICloudSharingControllerDelegate
extension NewOnboardingViewController: UICloudSharingControllerDelegate {
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
