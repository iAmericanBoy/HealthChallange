//
//  SignUpViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, PhotoSelectorViewControllerDelegate {
    
    
    // MARK: - Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var lifestyleLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var lifestyleSegmentedControl: UISegmentedControl!
    
    var profilePhoto: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: SignUpParentViewController.pageSwipedNotification, object: nil, userInfo: [SignUpParentViewController.pageIndexKey : 0])
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted), object: nil, queue: .main) { (notification) in
            print("Second Notification Accepted")
            self.presentAlert()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted))
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = usernameTextField.text, !name.isEmpty
             else { return }
        let photo = profilePhoto ?? UIImage(named: "stockPhoto")!
        
        let strengthValue = lifestyleSegmentedControl.selectedSegmentIndex
        UserController.shared.createUserWith(userName: name, userPhoto: photo, strengthValue: strengthValue) { (_) in
            self.resignFirstResponder()
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "NewChallengeParentViewController")
                    self.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func lifestyleSegmentDidChange(_ sender: Any) {
        // animations?
    }
    
    func photoSelectorViewControllerSelected(image: UIImage) {
        self.profilePhoto = image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoSelectSegue" {
            let destinationVC = segue.destination as? PhotoSelectorViewController
            destinationVC?.delegate = self
        }
    }
} // end class
