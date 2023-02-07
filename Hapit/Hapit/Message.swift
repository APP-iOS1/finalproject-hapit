//
//  Message.swift
//  Hapit
//
//  Created by 이주희 on 2023/02/07.
//

import Foundation

struct Message: Hashable, Codable, Identifiable {
    var id: String
    var messageType: String
    var sendTime: Date
    var senderID: String
    var receiverID: String
}
