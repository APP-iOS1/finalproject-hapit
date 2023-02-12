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
    var isRead: Bool
}

// MARK: messageType
// - "add" : "\()님이 친구 요청을 보냈습니다"
// - "accept" : "\()님이 친구 요청을 수락했습니다"
// - "match" : "\()님과 친구가 되었습니다"
// - "cock" : "\()님이 콕 찌르고 갔습니다"
