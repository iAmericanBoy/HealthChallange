//
//  SignUpCollectionViewCell.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/23/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

protocol SignUpCollectionViewCellDelegate {
    func saveUser(withName name: String, andUserPhoto photo: UIImage?, andLifeStyleValue value: Int)
}

class SignUpCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    fileprivate var saveButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Save", attributes: FontController.buttonFont), for: .normal)
        button.setTitleColor(UIColor.green, for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate var containerView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = .blue
        return view
    }()
    
    fileprivate var userNameTextField: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Add Username..."
        textField.defaultTextAttributes = FontController.textFieldFont
        
        return textField
    }()
    
    fileprivate var lifeStyleSegmentedControl: UISegmentedControl = {
        var segmentedControl = UISegmentedControl(items: ["Sedentary","Moderate","Active"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.setTitleTextAttributes(FontController.labelFont, for: .normal)
        segmentedControl.setEnabled(true, forSegmentAt: 1)
        segmentedControl.tintColor = UIColor.lushGreenColor
        return segmentedControl
    }()
    
    fileprivate var userNameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Username:", attributes: FontController.labelFont)
        return label
    }()
    
    fileprivate var lifeStyleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Lifestyle:", attributes: FontController.labelFont)
        return label
    }()
    
    //MARK: - Properties
    var delegate: SignUpCollectionViewCellDelegate?
    var user: User? {
        didSet{
            self.updateViews()
        }
    }
    
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
    @objc func saveButtonTapped() {
        guard let name = userNameTextField.text else {return}
        delegate?.saveUser(withName: name, andUserPhoto: nil, andLifeStyleValue: lifeStyleSegmentedControl.selectedSegmentIndex)
    }
    
    //MARK: - Private Functions
    func updateViews() {
        guard let user = user else {return}
        lifeStyleSegmentedControl.setEnabled(true, forSegmentAt: user.strengthValue)
        userNameTextField.text = user.userName
        userNameLabel.text = "Hello"
    }
    
    func setupViews() {
        
        contentView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: contentView.frame.height / 16).isActive = true
        containerView.heightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
        containerView.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
        containerView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        
        
        let saveButtonStackView = UIStackView(arrangedSubviews: [saveButton])
        saveButtonStackView.axis = .horizontal
        saveButtonStackView.alignment = .fill
        saveButtonStackView.alignment = .fill

        let userNameStackView = UIStackView(arrangedSubviews: [userNameLabel,userNameTextField])
        userNameStackView.axis = .vertical
        userNameStackView.spacing = 10
        
        let lifeStyleStackView = UIStackView(arrangedSubviews: [lifeStyleLabel,lifeStyleSegmentedControl])
        lifeStyleStackView.axis = .vertical
        lifeStyleStackView.spacing = 10
        
        
        let signUpStackView = UIStackView(arrangedSubviews: [saveButtonStackView,userNameStackView,lifeStyleStackView])
        signUpStackView.translatesAutoresizingMaskIntoConstraints = false
        signUpStackView.axis = .vertical
        signUpStackView.spacing = 15
        
        contentView.addSubview(signUpStackView)
        signUpStackView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        signUpStackView.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        signUpStackView.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor).isActive = true

        
        
    }
}
