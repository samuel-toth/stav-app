//
//  DateExtension.swift
//  Stav
//
//  Created by Samuel Tóth on 09/11/2022.
//

import Foundation

extension Date {

    func getDifferenceLocalized() -> (Int, String) {
        if isPast() {
            return pastDifferenceLocalized()
        } else {
            return futureDifferenceLocalized()
        }
    }


    func pastDifferenceLocalized() -> (Int, String) {
        let calendar = Calendar.current
        let now = Date()


        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: now)!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: now)!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: now)!

        if minuteAgo < self {
            return (0, "justNow")
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            if diff <= 1 {
                return (diff, NSLocalizedString("minute", comment: ""))
            } else {
                return (diff, NSLocalizedString("minutes", comment: ""))
            }
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            if diff <= 1 {
                return (diff, NSLocalizedString("hour", comment: ""))
            } else {
                return (diff, NSLocalizedString("hours", comment: ""))
            }
        } else {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            if diff <= 1 {
                return (diff, NSLocalizedString("day", comment: ""))
            } else {
                return (diff, NSLocalizedString("days", comment: ""))
            }
        }
    }

    func futureDifferenceLocalized() -> (Int, String) {
        let calendar = Calendar.current
        let now = Date()
        
        let minuteRemaining = calendar.date(byAdding: .minute, value: 1, to: now)!
        let hourRemaining = calendar.date(byAdding: .hour, value: 1, to: now)!
        let dayRemaining = calendar.date(byAdding: .day, value: 1, to: now)!
        
        if minuteRemaining > self {
            return (0, "justNow")
        } else if hourRemaining > self {
            let diff = Calendar.current.dateComponents([.minute], from: Date(), to: self).minute ?? 0
            if diff <= 1 {
                return (diff, NSLocalizedString("minute", comment: ""))
            } else {
                return (diff, NSLocalizedString("minutes", comment: ""))
            }
        } else if dayRemaining > self {
            let diff = Calendar.current.dateComponents([.hour], from: Date(), to: self).hour ?? 0
            if diff <= 1 {
                return (diff, NSLocalizedString("hour", comment: ""))
            } else {
                return (diff, NSLocalizedString("hours", comment: ""))
            }
        } else {
            let diff = Calendar.current.dateComponents([.day], from: Date(), to: self).day ?? 0
            if diff <= 1 {
                return (diff, NSLocalizedString("day", comment: ""))
            } else {
                return (diff, NSLocalizedString("days", comment: ""))
            }
        }
    }

    func localizedTimeDifference() -> String {
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < self {
            return NSLocalizedString("justNow", comment: "")
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return String(format: NSLocalizedString("minAgo", comment: ""), "\(diff)")
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return String(format: NSLocalizedString("hourAgo", comment: ""), "\(diff)")
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return String(format: NSLocalizedString("dayAgo", comment: ""), "\(diff)")
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return String(format: NSLocalizedString("weekAgo", comment: ""), "\(diff)")
    }

    func localizedTimeRemaining() -> String {
        let daysReminder = Calendar.current.dateComponents([.day], from: Date(), to: self).day!
        let hourReminder = Calendar.current.dateComponents([.hour], from: Date(), to: self).hour!
        let minuteReminder = Calendar.current.dateComponents([.minute], from: Date(), to: self).minute!
        if daysReminder > 0 {
            return String(format: NSLocalizedString("dayRemaining", comment: ""), "\(daysReminder)")
        } else if hourReminder > 0 {
            return String(format: NSLocalizedString("hourRemaining", comment: ""), "\(hourReminder)")
        } else if minuteReminder > 0 {
            return String(format: NSLocalizedString("minRemaining", comment: ""), "\(minuteReminder)")
        } else if minuteReminder < 1 && minuteReminder > 0  {
            return NSLocalizedString("lessThanMin", comment: "")
        }
        return NSLocalizedString("expired", comment: "")
    }
    
    func dateToFormattedDatetime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd.MM.YY"
        return dateFormatter.string(from: self)
    }
    
    func dateToFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY"
        return dateFormatter.string(from: self)
    }
    
    func current() -> Date {
        let calendar = Calendar.current

        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = 00
        components.minute = 00
        components.second = 00

        return calendar.date(from: components)!
    }

    func isPast() -> Bool {
        self < Date()
    }


}
