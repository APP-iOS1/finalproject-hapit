//
//  FriendChallengeCellView.swift
//  Hapit
//
//  Created by 김예원 on 2023/02/07.
//

import SwiftUI

struct FriendChallengeCellView: View {
    @EnvironmentObject var userInfoManager: UserInfoManager
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var messageManager: MessageManager
    @State var challenge: Challenge
    @State var friendId: String
    @State private var receiverFCMToken: String = ""
    @State private var notificationContent: String = ""
    @ObservedObject private var datas = fcmManager

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 1){
                VStack(alignment: .leading, spacing: 2){
                    Text(challenge.createdDate)
                        .font(.custom("IMHyemin-Regular", size: 13))
                        .foregroundColor(Color("GrayFontColor"))
                    HStack {
                        Text(challenge.challengeTitle)
                            .font(.custom("IMHyemin-Bold", size: 22))
                        Button{
                            // FCM 전송
                            self.datas.sendFirebaseMessageToUser(
                                datas: self.datas,
                                // 받을 사람의 FCMToken
                                to: receiverFCMToken,
                                title: "\(userInfoManager.currentUserInfo?.name ?? "친구")님이 콕 찔렀어요.",
                                body: "\(challenge.challengeTitle) 챌린지를 수행하세요!"
                            )
                            self.notificationContent = ""
                            
                            // 앱 내 메시지 전송
                            Task{
                                try await messageManager.sendMessage(
                                    Message(id: UUID().uuidString,
                                            messageType: "knock",
                                            sendTime: Date(),
                                            senderID: userInfoManager.currentUserInfo?.id ?? "",
                                            receiverID: friendId,
                                            isRead: false,
                                            challengeID: challenge.id))
                            }
                        } label: {
                            Image(systemName: "hand.tap.fill")
                        }
                    }
                }
                
                HStack(spacing: 5){
                    Text(Image(systemName: "flame.fill"))
                        .foregroundColor(.orange)
                    Text("연속 \(challenge.count)일째")
                    Spacer()
                    
                    if challenge.mateArray.contains(userInfoManager.currentUserInfo?.id ?? "") {
                        Text("함께 챌린지 중")
                            .foregroundColor(Color("AccentColor"))
                            .font(.custom("IMHyemin-Bold", size: 12))
                    }
                }
                .font(.custom("IMHyemin-Regular", size: 15))//HStack
                
            }
            Spacer()
            
        }
        .padding(20)
        .background(Color("CellColor"))
        .cornerRadius(20)
        .padding(.horizontal)
        .task {
            do {
                receiverFCMToken = try await authManager.getFCMToken(uid: friendId)
            } catch {
            }
        }
    }
}
