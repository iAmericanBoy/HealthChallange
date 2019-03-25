//
//  ShareCollectionViewCell.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/24/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

protocol ShareCollectionViewCellDelegate {
    func shareCurrentChallenge()
    func mainApp()
}

class ShareCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    lazy var shareButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Share Challenge", attributes: FontController.enabledButtonFont), for: .normal)
        button.setTitleColor(UIColor.green, for: .normal)
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var _goToMainAppButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "_GO TO MAIN APP", attributes: FontController.enabledButtonFont), for: .normal)
        button.setTitleColor(UIColor.green, for: .normal)
        button.addTarget(self, action: #selector(_goToMainAppButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Properties
    var delegate: ShareCollectionViewCellDelegate?
    var userCollectionView: UICollectionView?
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setupViews()
        updateViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc func shareButtonTapped() {
        print("share")
        delegate?.shareCurrentChallenge()
    }
    
    @objc func _goToMainAppButtonTapped(){
        print("main")
        delegate?.mainApp()
    }
    
    //MARK: - Private Functions
    func updateViews() {
        
    }
    
    func setupViews() {
        let topRowStackView = UIStackView(arrangedSubviews: [shareButton,_goToMainAppButton])
        topRowStackView.axis = .vertical
        topRowStackView.spacing = 5
        topRowStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(topRowStackView)
        topRowStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        topRowStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        topRowStackView.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        
    }
}
