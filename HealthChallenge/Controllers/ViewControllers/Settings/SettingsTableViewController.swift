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
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var lifestyleSegmentedControl: UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = user else { return }
        profilePhoto = user.photo
        usernameTextField.text = user.userName
    }
    
    
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        guard let user = user,
            let username = usernameTextField.text, !username.isEmpty,
            let profilePhoto = profilePhoto else { return }
        
        let strengthValue = lifestyleSegmentedControl.selectedSegmentIndex
        UserController.shared.update(user: user, withNewName: username, andWithNewPhoto: profilePhoto, newStrengthValue: strengthValue) { (success) in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func deleteProfileButtonTapped(_ sender: Any) {
        guard let user = user else { return }
        UserController.shared.delete(User: user) { (success) in
            if success {
                self.restartApp()
            }
        }
    }
    
    @IBAction func deleteChallengeButtonTapped(_ sender: Any) {
        guard let challenge = ChallengeController.shared.currentChallenge else { return }
        ChallengeController.shared.delete(challenge: challenge) { (success) in
            DispatchQueue.main.async {
                self.restartApp()
            }
        }
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
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
