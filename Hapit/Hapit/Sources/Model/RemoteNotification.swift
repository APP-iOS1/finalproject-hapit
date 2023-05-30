//
//  RemoteNotification.swift
//  Hapit
//
//  Created by 추현호 on 2023/02/10.
//

import Foundation

struct RemoteNotification: Identifiable {
    var id: String
    var userID: String
    var content: String
    var date: String
}

func makeToday() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter.string(from: date)
}
