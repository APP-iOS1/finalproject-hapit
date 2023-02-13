//
//  MessageCell.swift
//  Hapit
//
//  Created by 이주희 on 2023/02/07.
//

import SwiftUI

// TODO: case 별로 View 파일 다 쪼개기
struct MessageCellView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var userInfoManager: UserInfoManager
    @EnvironmentObject var messageManager: MessageManager
    @EnvironmentObject var habitManager: HabitManager
    @State private var senderNickname = ""
    @State private var challengeTitle = ""
    @Binding var isAllRead: Bool
    let msg: Message
    
    var body: some View {
        HStack {
            switch msg.messageType {
                // MARK: 친구 신청 메시지
            case "add":
                VStack {
                    Text("💝")
                        .font(.title)
                    Spacer()
                }
                .padding(.horizontal)
                VStack(alignment: .leading) {
                    Text("\(senderNickname)님이 친구 요청을 보냈습니다")
                        .font(.custom("IMHyemin-Bold", size: 17))
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
                                                                             receiverID: msg.senderID,
                                                                             isRead: false,
                                                                             challengeID: ""))
                                try await messageManager.sendMessage(Message(id: UUID().uuidString,
                                                                             messageType: "match",
                                                                             sendTime: Date(),
                                                                             senderID: msg.senderID,
                                                                             receiverID: msg.receiverID,
                                                                             isRead: false,
                                                                             challengeID: ""))
                                try await messageManager.removeMessage(userID: msg.receiverID,
                                                                       messageID: msg.id)
                            }
                        } label: {
                            Text("수락")
                                .padding(-5)
                                .modifier(FriendButtonModifier())
                        }
                        
                        Button {
                            Task {
                                try await messageManager.removeMessage(userID: msg.receiverID,
                                                                       messageID: msg.id)
                            }
                        } label: {
                            Text("거절")
                                .padding(-5)
                                .modifier(FriendButtonModifier())
                        }
                    }
                    .padding(.bottom, 10)
                }
                
                // MARK: 친구 수락 메시지
            case "accept":
                Text("💖")
                    .font(.title)
                    .padding(.horizontal)
                Text("\(senderNickname)님이 친구 요청을 수락했습니다")
                    .font(.custom("IMHyemin-Bold", size: 17))
                
                // MARK: 친구 매칭 메시지
            case "match":
                Text("💘")
                    .font(.title)
                    .padding(.horizontal)
                Text("\(senderNickname)님과 친구가 되었습니다")
                    .font(.custom("IMHyemin-Bold", size: 17))  
                // MARK: 콕찌르기 메시지
            case "knock":
                Text("💥")
                    .font(.title)
                    .padding(.horizontal)
                Text("\(senderNickname)님이 콕 찔렀습니다")
                    .font(.custom("IMHyemin-Bold", size: 17))
                
            case "invite":
                VStack {
                    Text("🤝")
                        .font(.title)
                    Spacer()
                }.padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text("\(senderNickname)님이 \(challengeTitle) 챌린지에 초대했습니다")
                        .font(.custom("IMHyemin-Bold", size: 17))
                    HStack {
                        Button {
                            Task {
                                habitManager.addChallegeMate(challengeID: msg.challengeID,
                                                             addValue: msg.receiverID)
                                try await messageManager.removeMessage(userID: msg.receiverID,
                                                                       messageID: msg.id)
                            }
                        } label: {
                            Text("수락")
                                .padding(-5)
                                .modifier(FriendButtonModifier())
                        }
                        
                        Button {
                            Task {
                                try await messageManager.removeMessage(userID: msg.receiverID,
                                                                       messageID: msg.id)
                            }
                        } label: {
                            Text("거절")
                                .padding(-5)
                                .modifier(FriendButtonModifier())
                        }
                    }
                    .padding(.bottom, 10)
                }
                
            default:
                Text("")
            }
            Spacer()
            // 새로운 메시지 안읽음 표시
            if !msg.isRead {
                VStack {
                    Text("•")
                        .font(.title)
                        .foregroundColor(Color.accentColor)
                    Spacer()
                }
            }
        }
        .task {
            do {
                self.senderNickname = try await authManager.getNickName(uid: msg.senderID)
                if msg.challengeID != "" {
                    self.challengeTitle = try await habitManager.getChallengeTitle(challengeID: msg.challengeID)
                }
            } catch {
            }
        }
        .onDisappear {
            Task {
                // 메시지 전부 읽음처리
                try await messageManager.updateIsRead(userID: userInfoManager.currentUserInfo?.id ?? "", messageID: msg.id)
                // fetch 후 메시지함 뱃지 제거 (전부 읽음)
                messageManager.fetchMessage(userID: userInfoManager.currentUserInfo?.id ?? "")
                for msg in messageManager.messageArray {
                    if !(msg.isRead) {
                        isAllRead = false
                        break
                    } else {
                        isAllRead = true
                    }
                }
            }
        }
    }
}

struct FriendButtonModifier: ViewModifier {
    let color = ""
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
        MessageCellView(isAllRead: .constant(true), msg: Message(id: "", messageType: "", sendTime: Date(), senderID: "", receiverID: "", isRead: false, challengeID: ""))
    }
}
