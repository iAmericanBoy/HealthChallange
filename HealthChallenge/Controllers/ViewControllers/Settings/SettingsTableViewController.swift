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
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteChallengeButton: UIButton!
    @IBOutlet weak var deleteProfileButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var lifestyleSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = user else { return }
        profilePhoto = user.photo
        saveButton.setAttributedTitle(NSAttributedString(string: "Save Changes", attributes: FontController.tableViewRowFontGREEN), for: .normal)
        deleteProfileButton.setAttributedTitle(NSAttributedString(string: "Delete Profile", attributes: FontController.tableViewRowFontRED), for: .normal)
        deleteChallengeButton.setAttributedTitle(NSAttributedString(string: "Leave Challenge", attributes: FontController.tableViewRowFontRED), for: .normal)
        usernameTextField.attributedText = NSAttributedString(string: "\(user.userName)", attributes: FontController.tableViewRowFont)
    }
    
    
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        guard let user = user,
            let username = usernameTextField.text, !username.isEmpty,
            let profilePhoto = profilePhoto
            else { return }
        
        let strengthValue = lifestyleSegmentedControl.selectedSegmentIndex
        UserController.shared.update(user: user, withNewName: username, andWithNewPhoto: profilePhoto, newStrengthValue: strengthValue) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func deleteProfileButtonTapped(_ sender: Any) {
        guard let user = user else { return }
        let alert = UIAlertController(title: "Delete Profile?", message: "Deleting your profile will remove all asociated data. Do you wish to proceed?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            UserController.shared.delete(User: user) { (success) in
                if success {
                    self.restartApp()
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
}
