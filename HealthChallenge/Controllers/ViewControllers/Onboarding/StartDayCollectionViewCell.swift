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

    //MARK: - Properties
    var activeChallenge: Challenge?
    var calendarController = CalendarController()
    var dateRange: [Date] = []
    var delegate: StartDayCollectionViewCellDelegate?
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        findDateRange(from: Date())
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Functions
    func setupViews() {
        setupCollectionView()
    }
    fileprivate func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        calendarCollectionView = UICollectionView(frame: contentView.frame, collectionViewLayout: layout)
        calendarCollectionView?.contentInsetAdjustmentBehavior = .scrollableAxes
        
        calendarCollectionView?.delegate = self
        calendarCollectionView?.dataSource = self
        
        calendarCollectionView?.showsHorizontalScrollIndicator = false
        calendarCollectionView?.clipsToBounds = true
        calendarCollectionView?.register(NewDateCollectionViewCell.self, forCellWithReuseIdentifier: "dateCell")
        contentView.addSubview(calendarCollectionView!)
    }
    
    func findDateRange(from startDate: Date) {
        var dayRange = [startDate]
        var previousDate = startDate
        let emptyCells = startDate.weekday - 1
        
        while dayRange.count != 35 {
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

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate
extension StartDayCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionItems = calendarController.numOfDaysInMonth[calendarController.currentMonthIndex - 1] + calendarController.firstWeekDayOfMonth - 1
        return sectionItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as? NewDateCollectionViewCell
            else { return UICollectionViewCell() }
        let monthIndex = calendarController.currentMonthIndex - 1
        var month = calendarController.shortMonthNames[monthIndex]
        cell.isHidden = false
        
        let date = dateRange[indexPath.row]
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        cell.backgroundColor = .white
        cell.dayLabel.textColor = .black
        cell.cellDate = Date(timeIntervalSince1970: 0)
        
        if date == Date().ignoreDate {
            cell.isHidden = true
        } else {
            cell.dayLabel.attributedText = NSAttributedString(string: "\(date.day)", attributes: FontController.labelFont)
            cell.cellDate = dateRange[indexPath.row]
            let index = date.month
            month = calendarController.shortMonthNames[index - 1]
            cell.monthLabel.attributedText = NSAttributedString(string: "\(month)", attributes: FontController.labelFont)
        }
        
        //logic to color cells of the selected date and the 30 days in the challenge
        if let challengeStartDate = activeChallenge?.startDay {
            if cell.cellDate!.stripTimestamp() == challengeStartDate.stripTimestamp() {
                cell.backgroundColor = .lushGreenColor
            } else if cell.cellDate! <= challengeStartDate.addingTimeInterval(2592000) && cell.cellDate! >= challengeStartDate {
                cell.backgroundColor = UIColor.lushGreenColor.withAlphaComponent(0.1)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NewDateCollectionViewCell else {return}
        
        cell.backgroundColor = UIColor.lushGreenColor
        
        delegate?.save(challenge: activeChallenge, withDate: cell.cellDate)
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
