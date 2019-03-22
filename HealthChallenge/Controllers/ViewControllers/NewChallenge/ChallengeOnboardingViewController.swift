//
//  ChallengeOnboardingViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/11/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class ChallengeOnboardingViewController: UIPageViewController {

    let onboardingViewControllers = [
        UIStoryboard(name: "StartDate", bundle: nil).instantiateViewController(withIdentifier: "startDateNav"),
        UIStoryboard(name: "WeeklyGoals", bundle: nil).instantiateViewController(withIdentifier: "weeklyGoalsNav"),
        UIStoryboard(name: "MonthlyGoals", bundle: nil).instantiateViewController(withIdentifier: "monthlyGoalsNav"),
        UIStoryboard(name: "InviteOthers", bundle: nil).instantiateViewController(withIdentifier: "shareNav")
    ]
    
    var isPresentingMonthGoalVC = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if isPresentingMonthGoalVC {
            setViewControllers([onboardingViewControllers[2]], direction: .forward, animated: true, completion: nil)
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

extension ChallengeOnboardingViewController: UIPageViewControllerDataSource {
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
