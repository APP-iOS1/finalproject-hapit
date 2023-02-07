//
//  MessageCell.swift
//  Hapit
//
//  Created by 이주희 on 2023/02/07.
//

import SwiftUI

struct MessageCellView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var messageManager: MessageManager
    let msg: Message
    @State private var senderNickname = ""
    
    var body: some View {
        VStack {
            switch msg.messageType {
            case "add":
                Text("\(senderNickname)님이 친구 요청을 보냈습니다💝")
            case "accept":
                Text("\(senderNickname)님이 친구 요청을 수락했습니다💖")
            case "match":
                Text("\(senderNickname)님과 친구가 되었습니다💘")
            case "cock":
                Text("\(senderNickname)님이 콕 찔렀습니다🫵🏻")
            default:
                Text("")
            }
            Divider()
        }
        .task {
            do {
                self.senderNickname = try await authManager.getNickName(uid: msg.senderID)
            } catch {
            }
        }
    }
}

struct MessageCellView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCellView(msg: Message(id: "", messageType: "", sendTime: Date(), senderID: "", receiverID: ""))
    }
}
