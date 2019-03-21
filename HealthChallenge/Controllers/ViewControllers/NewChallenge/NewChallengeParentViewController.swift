//
//  NewChallengeParentViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class NewChallengeParentViewController: UIViewController {
    
    static let pageSwipedNotification = Notification.Name(rawValue: "pageSwipedNotification")
    static let pageIndexKey = "pageIndex"
    
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: SignUpParentViewController.pageSwipedNotification, object: nil, queue: .main) { (notification) in
            guard let userInfo = notification.userInfo,
                let currentPageIndex = userInfo[SignUpParentViewController.pageIndexKey] as? Int
                else { return }
            
            self.pageControl.currentPage = currentPageIndex
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted), object: nil, queue: .main) { (notification) in
            print("Second Notification Accepted")
            self.presentAlert()
            
        }
    }
}
