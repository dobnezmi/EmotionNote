//
//  Date+Util.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/17.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import Foundation

extension Date {
    
    static func at(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        return calendar.date(era: 1, year: year, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: 0)!
    }
    
    var year: Int {
        return calendarComponents(unitflags: [.year]).year!
    }
    
    var month: Int {
        return calendarComponents(unitflags: [.month]).month!
    }
    
    var day: Int {
        return calendarComponents(unitflags: [.day]).day!
    }
    
    var hour: Int {
        return calendarComponents(unitflags: [.hour]).hour!
    }
    
    var weekday: Int {
        return calendarComponents(unitflags: [.weekday]).weekday!
    }
    
    func add(month: Int) -> Date {
        let comps = calendarComponents(unitflags: [.year, .month, .day, .hour, .minute, .second])
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        var m = comps.month! + 1
        m = m > 12 ? m : 1
        return calendar!.date(era: 1, year: comps.year!, month: m, day: comps.day!,
                              hour: comps.hour!, minute: comps.minute!, second: comps.second!, nanosecond: 0)!
    }
    
    func add(week: Int) -> Date {
        let oneDay = 60 * 60 * 24
        return self.addingTimeInterval(TimeInterval(oneDay * week * 7))
    }
    
    func add(days:Int) -> Date {
        let oneDay = 60 * 60 * 24
        return self.addingTimeInterval(TimeInterval(oneDay * days))
    }
    
    private func calendarComponents(unitflags: NSCalendar.Unit) -> DateComponents {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        return calendar.components(unitflags, from: self as Date)
    }
}
