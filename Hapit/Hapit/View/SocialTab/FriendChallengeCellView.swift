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
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var messageManager: MessageManager
    @State var challengeWithMe: [Challenge] = []
    @State var challenge: Challenge
    @State var friendId: String
    @State var receiverFCMToken: String = ""
    
    @State private var notificationContent: String = ""
    @ObservedObject private var datas = fcmManager

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 1){
                VStack(alignment: .leading, spacing: 2){
                    Text(challenge.createdDate)
                        .font(.custom("IMHyemin-Regular", size: 13))
                        .foregroundColor(.gray)
                    HStack {
                        Text(challenge.challengeTitle)
                            .font(.custom("IMHyemin-Bold", size: 22))
                        Button{
                            self.datas.sendFirebaseMessageToUser(
                                datas: self.datas,
                                // 받을 사람의 FCMToken
                                to: receiverFCMToken,
                                title: "Test" ,
                                body: "Test"
                            )
                            self.notificationContent = ""
                            Task{
                                try await messageManager.sendMessage(
                                    Message(id: UUID().uuidString, messageType: "knock", sendTime: Date(), senderID: userInfoManager.currentUserInfo?.id ?? "", receiverID: friendId))
                            }
                        } label: {
                            Image(systemName: "hand.tap.fill")
                        }
                    }
                }//VStack
                
                HStack(spacing: 5){
                    Text(Image(systemName: "flame.fill"))
                        .foregroundColor(.orange)
                    Text("연속 \(challenge.count)일째")
                    Spacer()
                    
                    ForEach(challengeWithMe){ challenge in
                        if challenge.id == self.challenge.id {
                            Text("함께 챌린지 중")
                                .foregroundColor(Color("AccentColor"))
                                .font(.custom("IMHyemin-Bold", size: 12))
                        }
                    }
                }
                .font(.custom("IMHyemin-Regular", size: 15))//HStack
                
            }//VStack
            Spacer()
            
        }//HStack
        .padding(20)
        .foregroundColor(.black)
        .background(.white)
        .cornerRadius(20)
        .padding(.horizontal)
        .task {
            do {
                let currentUser = userInfoManager.currentUserInfo?.id ?? ""
                challengeWithMe.removeAll()
                
                for challenge in habitManager.challenges {
                    for mate in challenge.mateArray {
                        if mate == currentUser {
                            challengeWithMe.append(challenge)
                        }
                        receiverFCMToken = try await authManager.getFCMToken(uid: friendId)
                    }
                }
            } catch {
                
            }
        }
    }
}

//struct FriendChallengeCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendChallengeCellView(challenge: Challenge(id: "", creator: "박진주", mateArray: [], challengeTitle: "책 읽기", createdAt: Date(), count: 1, isChecked: false, uid: ""))
//    }
//}
