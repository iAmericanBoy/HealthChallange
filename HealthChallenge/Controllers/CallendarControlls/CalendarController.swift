//
//  CalendarController.swift
//  HealthChallenge
//
//  Created by RYAN GREENBURG on 3/12/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation

class CalendarController {
    
    
    var numOfDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var monthsArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var shortMonthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var currentMonthIndex = 0
    var currentYear = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0
    var currentCalendar = Calendar.current
    
    func initializeCurrentCalendar() {
        currentMonthIndex = currentCalendar.component(.month, from: Date())
        currentYear = currentCalendar.component(.year, from: Date())
        todaysDate = currentCalendar.component(.day, from: Date())
        firstWeekDayOfMonth = getFirstWeekDay()
        
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex - 1] = 29
        }
        
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear
    }
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        return day == 7 ? 1 : day
    }
    
    func didChangeMonthUp(monthIndex: Int, year: Int) {
        currentMonthIndex = monthIndex + 1
        currentYear = year
        
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        firstWeekDayOfMonth = getFirstWeekDay()
    }
    
    func didChangeMonthDown(monthIndex: Int, year: Int) {
        currentMonthIndex = monthIndex - 1
        currentYear = year
        
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        firstWeekDayOfMonth = getFirstWeekDay()
    }
}

extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var ignoreDate: Date {
        return Date(timeIntervalSince1970: 0)
    }
    
    var firstDayOfTheMonth: Date {
        let day = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        return day
    }
    
    func stripTimestamp() -> Date {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
}

extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
