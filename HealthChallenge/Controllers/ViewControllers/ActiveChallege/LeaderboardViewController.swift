//
//  LeaderboardViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/14/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {
    
    var users: [User] = []
    var points: [Points] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateViews()
        setSettingsButton()
        NotificationCenter.default.addObserver(self, selector: #selector(setProfileImage), name: NotificationStrings.profileImageChanged, object: nil)
    }
    
    @objc func setProfileImage() {
        let button = navigationItem.rightBarButtonItem?.customView as! UIButton
        button.setBackgroundImage(Settings.shared.imageView.image, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted), object: nil, queue: .main) { (notification) in
            print("Second Notification Accepted")
            self.presentAlert()
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted))
    }
    
    func updateViews() {
        if (ChallengeController.shared.currentShare != nil) {
            users = UserController.shared.currentUsers
            points = UserController.shared.currentPoints
        } else {
            guard let user = UserController.shared.loggedInUser,
                let userPoints = PointsController.shared.usersPoints else { return }
            users.append(user)
            points.append(userPoints)
        }
        tableView.tableFooterView = UIView()
        points.sort { (leader, trailer) -> Bool in
            leader.totalPoints > trailer.totalPoints
        }
    }
}

extension LeaderboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? LeaderboardTableViewCell
        let leader = points[indexPath.row]
        cell?.pointsLabel.text = "0"
        
        if indexPath.row == 0 {
            cell?.placeLabel.text = "1st Place"
        } else if indexPath.row == 1 {
            cell?.placeLabel.text = "2nd Place"
        } else if indexPath.row == 2 {
            cell?.placeLabel.text = "3rd Place"
        } else {
            cell?.placeLabel.text = ""
        }
        
        for _ in points {
            var index = 0
            if leader.appleUserRef.recordID.recordName == users[index].appleUserRef.recordID.recordName {
                cell?.user = users[index]
                cell?.pointsLabel.attributedText = NSAttributedString(string: "\(points[indexPath.row].totalPoints)", attributes: FontController.labelTitleFont)
            } else {
                index += 1
            }
        }
        
        return cell ?? UITableViewCell()
    }
}

// MARK: - Set settings view, fonts, and colors

