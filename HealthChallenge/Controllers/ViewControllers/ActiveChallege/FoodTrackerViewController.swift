//
//  FoodTrackerViewController.swift
//  HealthChallenge
//
//  Created by Ben Huggins on 3/18/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

class FoodTrackerViewController: UIViewController {
    
    //MARK: - Properties
    var date: Date? {
        didSet {
            guard let date = date else {return}
            dishDateLabel.attributedText = NSAttributedString(string: date.format(), attributes: FontController.disabledButtonFont)
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var dishDateLabel: UILabel!
    @IBOutlet weak var foodTrackerTableView: UITableView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var addMealButton: UIButton!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        date = Date()
        setSettingsButton()
        setupViews()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted), object: nil, queue: .main) { (notification) in
            print("Second Notification Accepted")
            self.presentAlert()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(Notification.Name(rawValue: NotificationStrings.secondChallengeAccepted))
    }
    
    //MARK: - Actions
    @IBAction func previousDayTapped(_ sender: Any) {
        guard let dateNotNil = date else {return}
        date = Calendar.current.date(byAdding: .day, value: -1, to: dateNotNil)!
        updateViews()

    }
    
    @IBAction func nextDayTapped(_ sender: Any) {
        guard let dateNotNil = date else {return}
        date = Calendar.current.date(byAdding: .day, value: 1, to: dateNotNil)
        updateViews()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDishVC" {
            
//            if let index = foodTrackerTableView.indexPathForSelectedRow  {
//                guard let destVC = segue.destination as? DishDetailViewController else {return}
            
                //                let type = dishesKeys[index.section]
//                let dishToSend = DishController.shared.dishes[type]?[index.row]
//                destVC.dish = dishToSend
//            }
        }
    }
    
    //MARK: - Private Functions
    func updateViews() {
        guard let dateNotNil = date else {return}
        
        if dateNotNil.stripTimestamp() == Date().stripTimestamp() {
            nextButton.isHidden = true
        } else {
            nextButton.isHidden = false
        }
        
        //Only allow food to be entered for today or yesterday
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: dateNotNil)!
        if dateNotNil.stripTimestamp() < yesterday.stripTimestamp() {
            addMealButton.isHidden = true
        } else {
            addMealButton.isHidden = false
        }
        
        if FoodEntryController.shared.currentEntries.keys.contains(dateNotNil) {
            //display dishes
        } else {
            //create entry
            FoodEntryController.shared.createFoodEntry { (isSuccess) in
                
            }
        }
    }
    
    func setupViews() {
        self.navigationController?.navigationBar.titleTextAttributes = FontController.titleFont
        nextButton.setAttributedTitle(NSAttributedString(string: ">", attributes: FontController.enabledButtonFont), for: .normal)
        previousButton.setAttributedTitle(NSAttributedString(string: "<", attributes: FontController.enabledButtonFont), for: .normal)
        addMealButton.setAttributedTitle(NSAttributedString(string: "Add Meal", attributes: FontController.tableViewRowFontGREEN), for: .normal)
        dishDateLabel.attributedText = NSAttributedString(string: date!.format(), attributes: FontController.disabledButtonFont)

    }
}

//MARK: - NavigationBarSupport
extension FoodTrackerViewController {
    func setSettingsButton() {
        guard let navBar = self.navigationController?.navigationBar else { return }
        let button = UIButton()
        let image = Settings.shared.imageView
        button.addTarget(self, action: #selector(showSettingsView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        
        self.navigationController?.navigationBar.addSubview(image)
        NSLayoutConstraint.activate([
            image.rightAnchor.constraint(equalTo: navBar.rightAnchor, constant: -10),
            image.topAnchor.constraint(equalTo: navBar.topAnchor, constant: 10),
            image.heightAnchor.constraint(equalToConstant: navBar.frame.height / 2),
            image.widthAnchor.constraint(equalTo: image.heightAnchor)
            ])
        
        self.navigationController?.navigationBar.addSubview(button)
        NSLayoutConstraint.activate([
            button.rightAnchor.constraint(equalTo: navBar.rightAnchor, constant: -10),
            button.topAnchor.constraint(equalTo: navBar.topAnchor, constant: 10),
            button.heightAnchor.constraint(equalToConstant: navBar.frame.height / 2),
            button.widthAnchor.constraint(equalTo: button.heightAnchor)
            ])
        
        image.layer.cornerRadius = navBar.frame.height / 4
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
    }
    
    @objc func showSettingsView() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Settings")
            self.present(viewController, animated: true, completion: nil)
        }
    }
}
