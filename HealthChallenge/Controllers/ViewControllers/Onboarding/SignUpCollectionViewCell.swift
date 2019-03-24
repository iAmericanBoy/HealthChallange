//
//  SignUpCollectionViewCell.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/23/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

protocol SignUpCollectionViewCellDelegate {
    func selectPhoto()
    func save(user: User?,withName name: String, andUserPhoto photo: UIImage?, andLifeStyleValue value: Int)
}

class SignUpCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    lazy var saveButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Save", attributes: FontController.buttonFont), for: .normal)
        button.setTitleColor(UIColor.green, for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var photoButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit

        return button
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
        segmentedControl.setTitleTextAttributes(FontController.labelTitleFont, for: .normal)
        segmentedControl.setEnabled(true, forSegmentAt: 1)
        segmentedControl.tintColor = UIColor.lushGreenColor
        return segmentedControl
    }()
    
    fileprivate var userNameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Username:", attributes: FontController.labelTitleFont)
        return label
    }()
    
    fileprivate var lifeStyleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Lifestyle:", attributes: FontController.labelTitleFont)
        return label
    }()
    
    //MARK: - Properties
    var delegate: SignUpCollectionViewCellDelegate?
    var profilePhoto: UIImage? {
        didSet {
            photoButton.setBackgroundImage(profilePhoto, for: .normal)
            photoButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
            self.updateViews()
        }
    }
    var user: User? {
        didSet{
            self.updateViews()
        }
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        userNameTextField.delegate = self
        setupViews()
        updateViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc func saveButtonTapped() {
        userNameTextField.resignFirstResponder()
        guard let name = userNameTextField.text else {return}
        delegate?.save(user: user, withName: name, andUserPhoto: profilePhoto, andLifeStyleValue: lifeStyleSegmentedControl.selectedSegmentIndex)
    }
    
    @objc func photoButtonTapped() {
        delegate?.selectPhoto()
    }
    
    //MARK: - Private Functions
    func updateViews() {
        guard let user = user else {return}
        lifeStyleSegmentedControl.setEnabled(true, forSegmentAt: user.strengthValue)
        userNameTextField.attributedText = NSAttributedString(string: user.userName, attributes: FontController.textFieldFont)
        userNameLabel.attributedText = NSAttributedString(string: "Hello", attributes: FontController.labelTitleFont)
        photoButton.setBackgroundImage(user.photo, for: .normal)
        photoButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
    }
    
    func setupViews() {
        contentView.addSubview(photoButton)
        photoButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: contentView.frame.height / 16).isActive = true
        photoButton.heightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
        photoButton.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
        photoButton.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        
        let saveButtonStackView = UIStackView(arrangedSubviews: [saveButton])
        saveButtonStackView.axis = .horizontal
        saveButtonStackView.alignment = .fill

        let userNameStackView = UIStackView(arrangedSubviews: [userNameLabel,userNameTextField])
        userNameStackView.axis = .vertical
        userNameStackView.spacing = 5
        userNameStackView.alignment = .fill
        userNameStackView.distribution = .fill
        
        let lifeStyleStackView = UIStackView(arrangedSubviews: [lifeStyleLabel,lifeStyleSegmentedControl])
        lifeStyleStackView.axis = .vertical
        lifeStyleStackView.spacing = 5
        lifeStyleStackView.alignment = .fill
        lifeStyleStackView.distribution = .fill
        
        
        let signUpStackView = UIStackView(arrangedSubviews: [userNameStackView,lifeStyleStackView, saveButtonStackView])
        signUpStackView.translatesAutoresizingMaskIntoConstraints = false
        signUpStackView.axis = .vertical
        signUpStackView.spacing = 15
        signUpStackView.alignment = .fill
        signUpStackView.distribution = .fillEqually
        
        contentView.addSubview(signUpStackView)
        signUpStackView.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 0).isActive = true
        signUpStackView.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        signUpStackView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
}

//MARK: - UITextFieldDelegate
extension SignUpCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
