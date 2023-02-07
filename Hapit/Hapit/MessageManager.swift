//
//  MessageManager.swift
//  Hapit
//
//  Created by 이주희 on 2023/02/07.
//

import SwiftUI
import FirebaseFirestore


final class MessageManager: ObservableObject {
    @Published var messageArray = [Message]()
    let database = Firestore.firestore()
    
    // MARK: 메시지 보내기 (CREATE)
    // - 친구 신청, 친구 수락, 친구 완료, 콕찌르기
    func sendMessage(_ msg: Message) async throws -> Void {
        do {
            try await database.collection("User")
                .document(msg.receiverID)
                .collection("Message")
                .document(msg.id)
                .setData([
                    "alarmType": msg.messageType,
                    "sendTime": msg.sendTime,
                    "senderID": msg.senderID,
                    "receiverID": msg.receiverID
                ])
        } catch {
            throw(error)
        }
    }
    
    // MARK: 메시지 삭제
    // - 친구 수락, 친구 거절, 일정 시간 초과, x버튼
    func removeMessage(userID: String, messageID: String) async throws -> Void {
        do {
            try await database.collection("User")
                .document(userID)
                .collection("Message")
                .document(messageID).delete()
            fetchMessage(userID: userID)
        } catch {
            throw(error)
        }
    }
    
    // TODO: async
    func fetchMessage(userID: String) {
        database.collection("User")
            .document(userID).collection("Message")
            .order(by: "sendTime", descending: true)
            .getDocuments { (snapshot, error) in
                self.messageArray.removeAll()
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        let docData = document.data()
                        let messageType: String = docData["alarmType"] as? String ?? ""
                        let senderID: String = docData["senderID"] as? String ?? ""
                        let receiverID: String = docData["receiverID"] as? String ?? ""
                        if let sendStamp = docData["sendTime"] as? Timestamp {
                            let sendTime = sendStamp.dateValue()
                            let msgData: Message = Message(id: id, messageType: messageType, sendTime: sendTime, senderID: senderID, receiverID: receiverID)
                            self.messageArray.append(msgData)
                        }
                    }
                }
            }
    }
}
