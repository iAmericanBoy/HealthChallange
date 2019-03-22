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
                // relaunch the app
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
}
