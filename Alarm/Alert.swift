//
//  Alert.swift
//  Alarm
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import Foundation

struct Alert: Codable, Hashable {
    var id: String = UUID().uuidString
    let date: Date
    var isOn: Bool
    
    var time: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        return timeFormatter.string(from: date)
    }
    
    var meridiem: String {
        let meridemFormatter = DateFormatter()
        meridemFormatter.dateFormat = "a"
        meridemFormatter.locale = Locale(identifier: "ko")
        return meridemFormatter.string(from: date)
    }
}
