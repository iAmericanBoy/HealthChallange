//
//  SettingsTableViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/17/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, PhotoSelectorViewControllerDelegate {
    
    var user = UserController.shared.loggedInUser
    var profilePhoto: UIImage?
    
    @IBOutlet weak var challengeOptionsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteChallengeButton: UIButton!
    @IBOutlet weak var deleteProfileButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var lifestyleSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        saveButton.setAttributedTitle(NSAttributedString(string: "Save Changes", attributes: FontController.tableViewRowFontGREEN), for: .normal)
        deleteProfileButton.setAttributedTitle(NSAttributedString(string: "Delete Profile", attributes: FontController.tableViewRowFontRED), for: .normal)
        deleteChallengeButton.setAttributedTitle(NSAttributedString(string: "Leave Challenge", attributes: FontController.tableViewRowFontRED), for: .normal)
        challengeOptionsButton.setAttributedTitle(NSAttributedString(string: "Challenge Options", attributes: FontController.tableViewRowFontGREEN), for: .normal)
        shareButton.setAttributedTitle(NSAttributedString(string: "Share Challenge", attributes: FontController.tableViewRowFontGREEN), for: .normal)
        
        if let user = user {
            profilePhoto = user.photo
            usernameTextField.attributedText = NSAttributedString(string: "\(user.userName)", attributes: FontController.tableViewRowFont)
        }
    }
    
    @IBAction func challengeOptionsButtonTapped(_ sender: Any) {
        jumpToOnboarding(screen: 2)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        jumpToOnboarding(screen: 5)
    }
    
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty, let profilePhoto = profilePhoto else { return }
        
        let strengthValue = lifestyleSegmentedControl.selectedSegmentIndex

        if let user = user {
            //update
            UserController.shared.update(user: user, withNewName: username, andWithNewPhoto: profilePhoto, newStrengthValue: strengthValue) { (isSuccess) in
                if isSuccess {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NotificationStrings.profileImageChanged, object: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        } else {
            //save new user
            UserController.shared.createUserWith(userName: username, userPhoto: profilePhoto, strengthValue: strengthValue) { (isSuccess) in
                if isSuccess {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NotificationStrings.profileImageChanged, object: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func deleteProfileButtonTapped(_ sender: Any) {
        guard let user = user else { return }
        let alert = UIAlertController(title: "Delete Profile?", message: "Deleting your profile will remove all asociated data. Do you wish to proceed?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            UserController.shared.delete(User: user) { (success) in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteChallengeButtonTapped(_ sender: Any) {
        guard let challenge = ChallengeController.shared.currentChallenge else { return }
        let alert = UIAlertController(title: "Leave Challenge?", message: "Leaving the challenge will delete all current progress. Do you wish to proceed?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Leave", style: .destructive) { (_) in
            ChallengeController.shared.delete(challenge: challenge) { (success) in
                DispatchQueue.main.async {
                    self.restartApp()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func photoSelectorViewControllerSelected(image: UIImage) {
        self.profilePhoto = image
        //SHRINE TO FRANK
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoSelectSegue" {
            let destinationVC = segue.destination as? PhotoSelectorViewController
            destinationVC?.delegate = self
            destinationVC?.user = user
        }
    }
    
    func restartApp() {
        let viewController = InitialViewController()
        let navControl = UINavigationController(rootViewController: viewController)
        
        guard let window = UIApplication.shared.keyWindow,
            let rootViewController = window.rootViewController else { return }
        
        navControl.view.frame = rootViewController.view.frame
        navControl.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil) { (success) in
            if success {
                window.rootViewController = navControl
            }
        }
    }
    
    func jumpToOnboarding(screen: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navController = storyboard.instantiateViewController(withIdentifier: "onboardingV2") as? UINavigationController,
            let onboarding = navController.viewControllers.first as? OnboardingViewController,
            let window = UIApplication.shared.keyWindow,
            let rootViewController = window.rootViewController else { return }
        
        onboarding.position = screen
        onboarding.screenCount = 5
        
        navController.view.frame = rootViewController.view.frame
        navController.view.layoutIfNeeded()
    
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil) { (success) in
            if success {
                window.rootViewController = navController
            }
        }
    }
}

//MARK: - UITextViewDelegate
extension SettingsTableViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
