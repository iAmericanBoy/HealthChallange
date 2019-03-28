//
//  StartDayCollectionViewCell.swift
//  HealthChallenge
//
//  Created by Dominic Lanzillotta on 3/23/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import UIKit

protocol StartDayCollectionViewCellDelegate {
    func save(challenge: Challenge?, withDate date: Date?)
}

class StartDayCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    var calendarCollectionView: UICollectionView?
    
    fileprivate var monthLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    
    lazy var saveButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Save", attributes: FontController.enabledButtonFont), for: .normal)
        button.setTitleColor(UIColor.green, for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var previousMonthButton: UIButton = {
        var button = UIButton(type: .system)
        button.setAttributedTitle(NSAttributedString(string: "<", attributes: FontController.enabledButtonFont), for: .normal)
        button.addTarget(self, action: #selector(previousMonthButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var nextMonthButton: UIButton = {
        var button = UIButton(type: .system)
        button.setAttributedTitle(NSAttributedString(string: ">", attributes: FontController.enabledButtonFont), for: .normal)
        button.addTarget(self, action: #selector(nextMonthButtonTapped), for: .touchUpInside)
        return button
    }()
    
    fileprivate var sunLabel: UILabel = {
        var label = UILabel()
        label.attributedText = NSAttributedString(string: "SUN", attributes: FontController.labelTitleFont)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate var monLabel: UILabel = {
        var label = UILabel()
        label.attributedText = NSAttributedString(string: "MON", attributes: FontController.labelTitleFont)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate var tueLabel: UILabel = {
        var label = UILabel()
        label.attributedText = NSAttributedString(string: "TUE", attributes: FontController.labelTitleFont)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate var wedLabel: UILabel = {
        var label = UILabel()
        label.attributedText = NSAttributedString(string: "WED", attributes: FontController.labelTitleFont)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate var thuLabel: UILabel = {
        var label = UILabel()
        label.attributedText = NSAttributedString(string: "THU", attributes: FontController.labelTitleFont)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate var friLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "FRI", attributes: FontController.labelTitleFont)
        return label
    }()
    
    fileprivate var satLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "SAT", attributes: FontController.labelTitleFont)
        return label
    }()
    
    //MARK: - Properties
    var activeChallenge: Challenge?
    var challengeStartDate = ChallengeController.shared.currentChallenge?.startDay
    
    var calendarController = CalendarController()
    var dateRange: [Date] = []
    var delegate: StartDayCollectionViewCellDelegate?
    
    var challengeState: ChallengeState? {
        didSet {
            self.updateViews()
        }
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        let components = Calendar.current.dateComponents([.month, .year], from: Date())
        findDateRange(from: Calendar.current.date(from: components)!)
        setupViews()
        updateViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc func previousMonthButtonTapped() {
        let monthIndex = calendarController.currentMonthIndex
        let year = calendarController.currentYear
        calendarController.didChangeMonthDown(monthIndex: monthIndex, year: year)
        let previousMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: dateRange[15])
        let components = Calendar.current.dateComponents([.month, .year], from: previousMonthDate!)
        findDateRange(from: Calendar.current.date(from: components)!)
        updateViews()
    }
    
    @objc func nextMonthButtonTapped() {
        let monthIndex = calendarController.currentMonthIndex
        let year = calendarController.currentYear
        calendarController.didChangeMonthUp(monthIndex: monthIndex, year: year)
        
        let nextMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: dateRange[15])
        let components = Calendar.current.dateComponents([.month, .year], from: nextMonthDate!)
        findDateRange(from: Calendar.current.date(from: components)!)
        updateViews()
    }
    
    @objc func saveButtonTapped() {
        print("save")
        delegate?.save(challenge: activeChallenge, withDate: challengeStartDate)

    }
    
    //MARK: - Private Functions
    
    func updateViewsForOwner() {
        calendarCollectionView?.allowsSelection = true
        saveButton.isHidden = false
    }
    
    func updateViewsForParticipant() {
        calendarCollectionView?.allowsSelection = false
        saveButton.isHidden = true
    }
    
    func updateViews() {
        if  challengeState != nil{
            switch challengeState! {
            case .isOwnerChallenge:
                updateViewsForOwner()
            case .isParticipantChallenge:
                updateViewsForParticipant()
            case .noActiveChallenge:
                updateViewsForOwner()
            }
        }

        previousMonthButton.isEnabled = false
        let monthLabelText =  "\(calendarController.monthsArray[calendarController.currentMonthIndex - 1]) \(calendarController.currentYear)"
        monthLabel.attributedText = NSAttributedString(string: monthLabelText, attributes: FontController.labelTitleFont)
        
        if calendarController.currentMonthIndex == Date().month {
            previousMonthButton.isEnabled = false
        } else {
            previousMonthButton.isEnabled = true
        }
        
        if challengeStartDate == nil {
            saveButton.isEnabled = false
            saveButton.setAttributedTitle(NSAttributedString(string: "Select A Start Day", attributes: FontController.disabledButtonFont), for: .normal)
        } else {
            saveButton.setAttributedTitle(NSAttributedString(string: "Save", attributes: FontController.enabledButtonFont), for: .normal)
            saveButton.isEnabled = true
        }
        
        calendarCollectionView?.reloadData()
    }
    
    func setupViews() {
        let monthLabelStackView = UIStackView(arrangedSubviews: [previousMonthButton,monthLabel,nextMonthButton])
        monthLabelStackView.alignment = .fill
        monthLabelStackView.distribution = .fillEqually
        monthLabelStackView.axis = .horizontal
        
        let weekLabelStackView = UIStackView(arrangedSubviews: [sunLabel,monLabel,tueLabel,wedLabel,thuLabel,friLabel,satLabel])
        weekLabelStackView.alignment = .fill
        weekLabelStackView.distribution = .fillEqually
        weekLabelStackView.axis = .horizontal
        weekLabelStackView.spacing = 3
        
        let topRowStackView = UIStackView(arrangedSubviews: [monthLabelStackView,weekLabelStackView])
        topRowStackView.alignment = .fill
        topRowStackView.distribution = .fill
        topRowStackView.axis = .vertical
        topRowStackView.spacing = 10
        topRowStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(topRowStackView)
        topRowStackView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        topRowStackView.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95).isActive = true
        topRowStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        calendarCollectionView = UICollectionView(frame: contentView.frame, collectionViewLayout: layout)
        
        setupCollectionView()
        
        contentView.addSubview(calendarCollectionView!)
        calendarCollectionView?.topAnchor.constraint(equalTo: topRowStackView.bottomAnchor).isActive = true
        calendarCollectionView?.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        calendarCollectionView?.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95).isActive = true
        calendarCollectionView?.heightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.55).isActive = true
        
        contentView.addSubview(saveButton)
        saveButton.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: calendarCollectionView!.bottomAnchor).isActive = true
        saveButton.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
    }
    
    func setupCollectionView() {
        calendarCollectionView?.contentInsetAdjustmentBehavior = .scrollableAxes
        
        calendarCollectionView?.delegate = self
        calendarCollectionView?.dataSource = self
        
        calendarCollectionView?.backgroundColor = .clear
        calendarCollectionView?.showsHorizontalScrollIndicator = false
        calendarCollectionView?.clipsToBounds = true
        calendarCollectionView?.register(StartDateCollectionViewCell.self, forCellWithReuseIdentifier: "dateCell")
        calendarCollectionView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func findDateRange(from startDate: Date) {
        var dayRange = [startDate]
        var previousDate = startDate
        let emptyCells = startDate.weekday - 1
        
        while dayRange.count != calendarController.numOfDaysInMonth[calendarController.currentMonthIndex - 1] {
            let date = previousDate.addingTimeInterval(86400)
            dayRange.append(date)
            previousDate = date
        }
        
        if emptyCells == 0 {
            dateRange = dayRange
        } else {
            for _ in 1...emptyCells {
                dayRange.insert(Date().ignoreDate, at: 0)
            }
        }
        dateRange = dayRange
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension StartDayCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //TODO: Fix crash when currenday is s
        return dateRange.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as? StartDateCollectionViewCell
            else { return UICollectionViewCell() }
        let today = Date()
        let monthIndex = calendarController.currentMonthIndex - 1
        var month = calendarController.shortMonthNames[monthIndex]
        cell.isHidden = false
        
        let date = dateRange[indexPath.row]
        cell.contentView.layer.cornerRadius = cell.frame.width / 2
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.contentView.backgroundColor = .white
        cell.dayLabel.textColor = .black
        cell.cellDate = Date(timeIntervalSince1970: 0)
        
        if date == Date().ignoreDate {
            cell.isHidden = true
        } else {
            cell.dayLabel.attributedText = NSAttributedString(string: "\(date.day)", attributes: FontController.labelTitleFont)
            cell.cellDate = dateRange[indexPath.row]
            let index = date.month
            month = calendarController.shortMonthNames[index - 1]
            cell.monthLabel.attributedText = NSAttributedString(string: "\(month)", attributes: FontController.subTitleLabelFont)
        }
        
        //logic to color cells of the selected date and the 30 days in the challenge
        if let challengeStartDate = challengeStartDate {
            if cell.cellDate!.stripTimestamp() == challengeStartDate.stripTimestamp() {
                cell.contentView.backgroundColor = .lushGreenColor
            } else if cell.cellDate! <= challengeStartDate.addingTimeInterval(2592000) && cell.cellDate! >= challengeStartDate {
                cell.contentView.backgroundColor = UIColor.lushGreenColor.withAlphaComponent(0.1)
            }
        }
        
        // change background color of cells for past days.
        if date.day < today.day && date.month == today.month {
            cell.dayLabel.textColor = .lightGray
            cell.monthLabel.textColor = .lightGray
            cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? StartDateCollectionViewCell else {return}
        guard let cellDate = cell.cellDate, cellDate.stripTimestamp() >= Date().stripTimestamp() else {return}
            challengeStartDate = cell.cellDate
            cell.contentView.backgroundColor = .lushGreenColor
            updateViews()
            
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.white
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 7) - 2, height: (collectionView.frame.width / 7) - 2)
    }
}
