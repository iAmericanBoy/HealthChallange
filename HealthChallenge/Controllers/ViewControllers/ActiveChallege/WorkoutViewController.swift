//
//  WorkoutViewController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/14/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit
import HealthKit

class WorkoutViewController: UIViewController {
    
    // Calendar instance
    let calendarController = CalendarController()
    
    // Properties
    var selectedDay: Date = Date().stripTimestamp()
    var workouts: [Workout] = [] {
        didSet{
            updateViews()
        }
    }
    var dayWorkouts: [Workout] = []
    var dateRange: [Date] = []
    var challengeDates: [Date] = []

    // MARK: - Outlets
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sunLabel: UILabel!
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var tueLabel: UILabel!
    @IBOutlet weak var wedLabel: UILabel!
    @IBOutlet weak var thuLabel: UILabel!
    @IBOutlet weak var friLabel: UILabel!
    @IBOutlet weak var satLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let challenge = ChallengeController.shared.currentChallenge else { return }
        workouts = WorkoutController.shared.workouts
        // call class functions
        findDateRange(from: challenge.startDay)
        setPoints()
        setSettingsButton()
        // set delegates etc.
        calendarController.initializeCurrentCalendar()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        // set fonts, text, etc
        self.navigationController?.navigationBar.titleTextAttributes = FontController.titleFont
        monthLabel.text = "\(challenge.name)"
        monthLabel.attributedText = NSAttributedString(string: "\(challenge.name)", attributes: FontController.disabledButtonFont)
        calendarCollectionView.backgroundColor = .clear
        sunLabel.attributedText = NSAttributedString(string: "Sun", attributes: FontController.labelTitleFont)
        monLabel.attributedText = NSAttributedString(string: "Mon", attributes: FontController.labelTitleFont)
        tueLabel.attributedText = NSAttributedString(string: "Tue", attributes: FontController.labelTitleFont)
        wedLabel.attributedText = NSAttributedString(string: "Wed", attributes: FontController.labelTitleFont)
        thuLabel.attributedText = NSAttributedString(string: "Thu", attributes: FontController.labelTitleFont)
        friLabel.attributedText = NSAttributedString(string: "Fri", attributes: FontController.labelTitleFont)
        satLabel.attributedText = NSAttributedString(string: "Sat", attributes: FontController.labelTitleFont)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateViews()
        setSettingsButton()
        // animations?
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
    
    // MARK: - Class functions
    func findDateRange(from startDate: Date) {
        var dayRange = [startDate]
        var dates = [startDate]
        var previousDate = startDate
        let emptyCells = startDate.weekday - 1
        
        while dayRange.count != 30 {
            let date = previousDate.addingTimeInterval(86400)
            dayRange.append(date)
            dates.append(date)
            previousDate = date
        }
        
        if emptyCells == 0 {
            dateRange = dayRange
        } else {
            for _ in 1...emptyCells {
                dayRange.insert(Date().ignoreDate, at: 0)
            }
        }
        challengeDates = dates
        dateRange = dayRange
    }
    
    func setPoints() {
        guard let userPoints = PointsController.shared.usersPoints else { return }
        var totalPoints: Int = 0
        
        let weekOne = challengeDates[0]...challengeDates[7]
        let weekTwo = challengeDates[8]...challengeDates[13]
        let weekThree = challengeDates[14]...challengeDates[20]
        let weekFour = challengeDates[21]...challengeDates[29]

        let weekOneWorkouts = workouts.filter({ weekOne.contains($0.end) }).count
        let weekTwoWorkouts = workouts.filter({ weekTwo.contains($0.end) }).count
        let weekThreeWorkouts = workouts.filter({ weekThree.contains($0.end) }).count
        let weekFourWorkouts = workouts.filter({ weekFour.contains($0.end) }).count
        
        totalPoints += min(3, weekOneWorkouts)
        totalPoints += min(3, weekTwoWorkouts)
        totalPoints += min(3, weekThreeWorkouts)
        totalPoints += min(3, weekFourWorkouts)
        
        PointsController.shared.set(workOutPoints: totalPoints, toPoints: userPoints) { (success) in
            //handle
        }
    }
    
    func updateViews() {
        dayWorkouts = workouts.filter({ $0.end.stripTimestamp().format() == selectedDay.format() })
        DispatchQueue.main.async {
            self.calendarCollectionView.reloadData()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // only perform segue if selected day workouts is empty, and the selected day is within the past week.
        if segue.identifier == "toWorkoutsVC" {
            let destinationVC = segue.destination as? AddWorkoutsViewController
            destinationVC?.sourceDate = selectedDay
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toWorkoutsVC"{
            return dayWorkouts.count == 0
        }else {
            return true
        }
    }
}

// MARK: - CollectionView DataSource
extension WorkoutViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateRange.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as? DateCollectionViewCell
            else { return UICollectionViewCell() }
        cell.delegate = self
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        cell.backgroundColor = .white
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.layer.cornerRadius).cgPath
        cell.isHidden = false
        cell.dayLabel.textColor = .black
        cell.monthLabel.textColor = .black
        
        let date = dateRange[indexPath.row]
        let today = Date()
        let monthIndex = calendarController.currentMonthIndex - 1
        var month = calendarController.shortMonthNames[monthIndex]
        
        // Set cell text label and date value.
        if date == Date().ignoreDate {
            cell.isHidden = true 
        } else {
            cell.dayLabel.attributedText = NSAttributedString(string: "\(date.day)", attributes: FontController.labelTitleFont)
            cell.cellDate = dateRange[indexPath.row]
            let index = date.month
            month = calendarController.shortMonthNames[index - 1]
            cell.monthLabel.attributedText = NSAttributedString(string: "\(month)", attributes: FontController.subTitleLabelFont)
        }
        
        // Change color of dates with a workout
        if workouts.filter({ $0.end.stripTimestamp().format() == date.stripTimestamp().format() }).count > 0 {
            cell.backgroundColor = .lushGreenColor
        }
        
        if date.stripTimestamp() == today.stripTimestamp() {
            cell.dayLabel.textColor = .purple
            cell.monthLabel.textColor = .purple
        }
        
        // Allow user to select past days to see their workouts.
        if date <= today {
            cell.isUserInteractionEnabled = true
        } else {
            cell.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 7) - 2, height: (collectionView.frame.width / 7) - 2)
    }
}


// MARK: - TableView DataSource/Delegate
extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as? WorkoutDetailTableViewCell
        cell?.delegate = self
        let workout = dayWorkouts[indexPath.row]
        
        cell?.activityLabel.attributedText = NSAttributedString(string: "\(workout.activity)", attributes: FontController.labelTitleFont)
        cell?.durationLabel.attributedText = NSAttributedString(string: format(duration: workout.duration), attributes: FontController.tableViewRowFont)
        cell?.dateLabel.attributedText = NSAttributedString(string: "\(workout.end.month)/\(workout.end.day)", attributes: FontController.tableViewRowFont)
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let workoutToDelete = dayWorkouts[indexPath.row]
            WorkoutController.shared.delete(workout: workoutToDelete) { (success) in
                DispatchQueue.main.async {
                    self.dayWorkouts.remove(at: indexPath.row)
                    self.workouts.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.updateViews()
                }
            }
        }
    }
    
    func format(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        
        return formatter.string(from: duration) ?? "No Duration Available"
    }
}

// Conform to DateCollectionViewCellDelegate and perform segue
extension WorkoutViewController: DateCollectionViewCellDelegate, WorkoutDetailTableViewCellDelegate {
    func collectionViewCell(_ cell: UICollectionViewCell, buttonTapped: UIButton) {
        if HKHealthStore.isHealthDataAvailable() == false {
            HealthKitController.shared.authorizeHK { (success) in
                if success {
                    print("HealthKit auth granted.")
                }
            }
        }
        
//        if dayWorkouts.count == 0 {
//            newWorkoutButton.isHidden = false
//        } else {
//            newWorkoutButton.isHidden = true
//        }
        
        let dateCell = cell as! DateCollectionViewCell
        self.selectedDay = dateCell.cellDate!
        updateViews()
    }
}

// MARK: - Set settings view, fonts, and colors
extension WorkoutViewController {
    
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
