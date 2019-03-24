//
//  OnboardingViewController.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/23/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit


class NewOnboardingViewController: UIViewController {
    //MARK: - Outlets
    var collectionView: UICollectionView?
    
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
        return pc
    }()
    
    //MARK: - Properties
    var screenCount = 1
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .always
        self.title = "\(pageControl.currentPage)"
        view.backgroundColor = .white
        setupCollectionView()
        setupBottonControls()
    }
    
    //MARK: - Actions
    @objc fileprivate func handelNext() {
        let nextIndex = min(pageControl.currentPage + 1, pageControl.numberOfPages - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        self.title = "\(pageControl.currentPage)"
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    @objc fileprivate func handelPrevious() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        self.title = "\(pageControl.currentPage)"
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    //MARK: - Private Functions
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

//MARK: -
extension NewOnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
        
        self.title = "\(pageControl.currentPage)"
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
            cell?.user = UserController.shared.loggedInUser
            return cell ?? UICollectionViewCell()
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
            return cell
        }
    }
}

//MARK: - SignUpCollectionViewCellDelegate
extension NewOnboardingViewController: SignUpCollectionViewCellDelegate {
    func selectPhoto() {
        print("photo")
    }
    
    func saveUser(withName name: String, andUserPhoto photo: UIImage?, andLifeStyleValue value: Int) {
        print("save")
    }
}
