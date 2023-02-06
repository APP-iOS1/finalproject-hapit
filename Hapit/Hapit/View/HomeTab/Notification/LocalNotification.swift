//
//  LocalNotification.swift
//  Hapit
//
//  Created by 박민주 on 2023/02/05.
//

import Foundation

struct LocalNotification {
    var identifier: String
    var title: String
    var body: String
    var dateComponents: DateComponents
    var repeats: Bool
}
