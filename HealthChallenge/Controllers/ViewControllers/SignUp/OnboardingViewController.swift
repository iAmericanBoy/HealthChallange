//
//  NewChallengeViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class OnboardingViewController: UIPageViewController {
    
    let onboardingViewControllers = [
        UIStoryboard(name: "HealthKitAccess", bundle: nil).instantiateViewController(withIdentifier: "HealthKitAccess"),
        UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
    ]

    var isPresentingSignUpVC = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if isPresentingSignUpVC {
            setViewControllers([onboardingViewControllers[1]], direction: .forward, animated: true, completion: nil)
        } else {
            setViewControllers([onboardingViewControllers.first!], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted), object: nil, queue: .main) { (notification) in
            print("Second Notification Accepted")
            self.presentAlert()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted))
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = onboardingViewControllers.firstIndex(of: viewController) else { return UIViewController() }
        
        if index == 0 {
            return nil
        }
        let newIndex = index - 1
        return onboardingViewControllers[newIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = onboardingViewControllers.firstIndex(of: viewController) else { return UIViewController() }
        if index == onboardingViewControllers.count - 1 {
            return nil
        }
        let newIndex = index + 1
        return onboardingViewControllers[newIndex]
    }
}
