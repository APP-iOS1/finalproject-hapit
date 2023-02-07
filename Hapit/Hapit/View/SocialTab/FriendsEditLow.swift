//
//  FriendsEditLow.swift
//  Hapit
//
//  Created by 이주희 on 2023/02/06.
//

import SwiftUI
import FirebaseAuth

struct FriendsEditRow: View {
    @EnvironmentObject var userInfoManager: UserInfoManager
    @EnvironmentObject var messageManager: MessageManager
    @State private var isRemoveAlert = false
    @State private var isAddAlert = false
    @State private var friendOrNot = false
    let friend: User
    var isRemoveOrAdd: Bool
    
    var body: some View {
        HStack {
            Image(friend.proImage)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(10)
            
                Text(friend.name)
                    .foregroundColor(.black)
                    .bold()
            
            Spacer()
            
            Button {
                Task {
                    // 삭제 셀
                    if isRemoveOrAdd {
                        isRemoveAlert.toggle()
                    } else {
                    // 추가 셀
                        // TODO: 이미 친구인 상태면 Alert 띄우고 신청 못하게 하기
                        if let friendArray = userInfoManager.currentUserInfo?.friends {
                            if friendArray.contains(friend.id) {
                                friendOrNot = true
                                isAddAlert.toggle()
                            }
                        }
                        try await messageManager.sendMessage(Message(id: UUID().uuidString, messageType: "add", sendTime: Date(), senderID: userInfoManager.currentUserInfo?.id ?? "", receiverID: friend.id))
                        isAddAlert.toggle()
                    }
                }
            } label: {
                Text(isRemoveOrAdd ? "삭제" : "추가")
                    .modifier(FriendButtonModifier())
            }
            .alert(friendOrNot ? "😮" : "친구 신청 완료!", isPresented: $isAddAlert) {
                Button("완료") { }
            } message: {
                Text(friendOrNot ? "이미 친구인 유저예요❗️" : "해피들이 메시지를 전달했어요 💌")
            }
            .alert("😮", isPresented: $friendOrNot) {
                Button("닫기") { }
            } message: {
                Text("이미 친구인 유저예요❗️")
            }
            .alert("정말 삭제하실 건가요?", isPresented: $isRemoveAlert) {
                Button("삭제", role: .destructive) {
                    Task {
                        try await userInfoManager.removeFriendData(userID: userInfoManager.currentUserInfo?.id ?? "", friendID: friend.id)
                    }
                }
                Button("취소", role: .cancel) {}
            } message: {
                Text("삭제해도 메시지는 가지 않아요❗️")
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

struct FriendsEditLow_Previews: PreviewProvider {
    static var previews: some View {
        FriendsEditRow(friend: User(id: "", name: "", email: "", pw: "", proImage: "", badge: [""], friends: [""]), isRemoveOrAdd: true)
    }
}
