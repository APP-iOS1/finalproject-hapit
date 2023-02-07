//
//  MessageCell.swift
//  Hapit
//
//  Created by 이주희 on 2023/02/07.
//

import SwiftUI

struct MessageCellView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var userInfoManager: UserInfoManager
    @EnvironmentObject var messageManager: MessageManager
    @State private var senderNickname = ""
    let msg: Message
    
    var body: some View {
        HStack {
            switch msg.messageType {
            case "add":
                Text("\(senderNickname)님이 친구 요청을 보냈습니다💝")
                HStack {
                    Button {
                        Task {
                            // 1. 친구 목록 업데이트, 2.친구수락 메시지 전송, 3.현재 친구신청 메시지 삭제
                            // receiverID: currentUser, senderID: friend
                            try await userInfoManager.updateFriendList(receiverID: msg.receiverID,
                                                                       senderID: msg.senderID)
                            try await messageManager.sendMessage(Message(id: UUID().uuidString,
                                                                         messageType: "accept",
                                                                         sendTime: Date(),
                                                                         senderID: msg.receiverID,
                                                                         receiverID: msg.senderID))
                            try await messageManager.sendMessage(Message(id: UUID().uuidString,
                                                                         messageType: "match",
                                                                         sendTime: Date(),
                                                                         senderID: msg.receiverID,
                                                                         receiverID: msg.senderID))
                            try await messageManager.removeMessage(userID: msg.receiverID,
                                                                   messageID: msg.id)
                        }
                    } label: {
                        Text("수락")
                            .modifier(FriendButtonModifier())
                    }
                    
                    Button {
                        Task {
                            try await messageManager.removeMessage(userID: msg.receiverID,
                                                                   messageID: msg.id)
                        }
                    } label: {
                        Text("거절")
                            .modifier(FriendButtonModifier())
                    }
                }
            case "accept":
                Text("\(senderNickname)님이 친구 요청을 수락했습니다💖")
            case "match":
                Text("\(senderNickname)님과 친구가 되었습니다💘")
            case "cock":
                Text("\(senderNickname)님이 콕 찔렀습니다🫵🏻")
            default:
                Text("")
            }
        }
        .task {
            do {
                self.senderNickname = try await authManager.getNickName(uid: msg.senderID)
            } catch {
            }
        }
    }
}

struct FriendButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.custom("IMHyemin-Bold", size: 17))
            .padding()
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(Color.accentColor))
    }
}

struct MessageCellView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCellView(msg: Message(id: "", messageType: "", sendTime: Date(), senderID: "", receiverID: ""))
    }
}
