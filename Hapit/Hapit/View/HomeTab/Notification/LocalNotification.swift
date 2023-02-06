//
//  LocalNotification.swift
//  Hapit
//
//  Created by 박민주 on 2023/02/05.
//

import Foundation

struct LocalNotification {
    internal init(identifier: String,
                  title: String,
                  body: String,
                  timeInterval: Double,
                  repeats: Bool) {
        self.identifier = identifier
        self.scheduleType = .time
        self.title = title
        self.body = body
        self.timeInterval = timeInterval
        self.dateComponents = nil
        self.repeats = repeats
    }
    
    internal init(identifier: String,
                  title: String,
                  body: String,
                  dateComponents: DateComponents,
                  repeats: Bool) {
        self.identifier = identifier
        self.scheduleType = .calendar
        self.title = title
        self.body = body
        self.timeInterval = nil
        self.dateComponents = dateComponents
        self.repeats = repeats
    }
    
    enum ScheduleType {
        case time, calendar
    }
    
    var identifier: String
    var scheduleType: ScheduleType
    var title: String
    var body: String
    var subtitle: String?
    var bundleImageName: String?
    var userInfo: [AnyHashable: Any]?
    var timeInterval: Double?
    var dateComponents: DateComponents?
    var repeats: Bool
    var categoryIdentifier: String?
}
