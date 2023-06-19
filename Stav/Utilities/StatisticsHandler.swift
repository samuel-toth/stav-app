//
//  StatisticsHandler.swift
//  Stav
//
//  Created by Samuel Tóth on 10/11/2022.
//

import Foundation

struct GroupData {
    var value: Int
    var date: Date
}

class StatisticsHandler {

    static let shared = StatisticsHandler()
    
    func groupHistoryRecordsForInterval(historyRecords: [HistoryRecord], interval: IntervalRange) -> (average: Double, max: Int, min: Int) {
        switch interval {
        case .daily:
            let groupedData = groupHistoryRecordsByDay(historyRecords: historyRecords)
            return (computeAverage(groupData: groupedData), computeMax(groupData: groupedData), computeMin(groupData: groupedData))
        case .weekly:
            let groupedData = groupHistoryRecordsByWeek(historyRecords: historyRecords)
            return (computeAverage(groupData: groupedData), computeMax(groupData: groupedData), computeMin(groupData: groupedData))
        case .monthly:
            let groupedData = groupHistoryRecordsByMonth(historyRecords: historyRecords)
            return (computeAverage(groupData: groupedData), computeMax(groupData: groupedData), computeMin(groupData: groupedData))
        case .yearly:
            let groupedData = groupHistoryRecordsByYear(historyRecords: historyRecords)
            return (computeAverage(groupData: groupedData), computeMax(groupData: groupedData), computeMin(groupData: groupedData))
        }
    }

    private func groupHistoryRecordsByDay(historyRecords: [HistoryRecord]) -> [GroupData] {

        let empty: [Date: [HistoryRecord]] = [:]
        return historyRecords.reduce(into: empty) { acc, cur in
            let components = Calendar.current.dateComponents([.year, .month, .day], from: cur.timestamp )
                    let date = Calendar.current.date(from: components)!
                    acc[date, default: []].append(cur)
                }
                .mapValues { Int($0.reduce(0) { $0 + $1.value }) }
                .map { GroupData(value: $0.value, date: $0.key) }
    }

    private func groupHistoryRecordsByWeek(historyRecords: [HistoryRecord]) -> [GroupData] {

        let empty: [Date: [HistoryRecord]] = [:]
        return historyRecords.reduce(into: empty) { acc, cur in
            let components = Calendar.current.dateComponents([.year, .month, .weekOfMonth], from: cur.timestamp )
                    let date = Calendar.current.date(from: components)!
                    acc[date, default: []].append(cur)
                }
                .mapValues { Int($0.reduce(0) { $0 + $1.value }) }
                .map { GroupData(value: $0.value, date: $0.key) }
    }

    private func groupHistoryRecordsByMonth(historyRecords: [HistoryRecord]) -> [GroupData] {
        let empty: [Date: [HistoryRecord]] = [:]
        return historyRecords.reduce(into: empty) { acc, cur in
            let components = Calendar.current.dateComponents([.year, .month], from: cur.timestamp )
                    let date = Calendar.current.date(from: components)!
                    acc[date, default: []].append(cur)
                }
                .mapValues { Int($0.reduce(0) { $0 + $1.value }) }
                .map { GroupData(value: $0.value, date: $0.key) }
    }

    private func groupHistoryRecordsByYear(historyRecords: [HistoryRecord]) -> [GroupData] {
        
        let empty: [Date: [HistoryRecord]] = [:]
        return historyRecords.reduce(into: empty) { acc, cur in
            let components = Calendar.current.dateComponents([.year], from: cur.timestamp )
            let date = Calendar.current.date(from: components)!
            acc[date, default: []].append(cur)
        }
        .mapValues { Int($0.reduce(0) { $0 + $1.value }) }
        .map { GroupData(value: $0.value, date: $0.key) }
    }

    private func computeAverage(groupData: [GroupData]) -> Double {
        var sum = 0
        for data in groupData {
            sum += data.value
        }
        return (Double(sum) / Double(groupData.count))
    }

    private func computeMax(groupData: [GroupData]) -> Int {
        var max = 0
        for data in groupData {
            if data.value > max {
                max = data.value
            }
        }
        return max
    }

    private func computeMin(groupData: [GroupData]) -> Int {
        var min = 0
        for data in groupData {
            if data.value < min {
                min = data.value
            }
        }
        return min
    }
}
