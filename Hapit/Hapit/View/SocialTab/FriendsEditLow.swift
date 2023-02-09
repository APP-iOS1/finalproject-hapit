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
    @Binding var isAddAlert: Bool
    @Binding var isAddedAlert: Bool
    @Binding var isRemoveAlert: Bool
    @Binding var friendOrNot: Bool
    @Binding var isAdded: Bool
    @Binding var selectedFriend: User
    let friend: User
    var isRemoveOrAdd: Bool
    @State private var friendMessage: [Message] = [Message]()
    
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
                    messageManager.friendID = friend.id
                    // 삭제 셀
                    if isRemoveOrAdd {
                        selectedFriend = friend
                        isRemoveAlert = true
                    } else {
                    // 추가 셀
                        // MARK: 이미 친구인 상태면 Alert 띄우고 신청 못하게 하기
                        if let friendArray = userInfoManager.currentUserInfo?.friends {
                            if friendArray.contains(friend.id) {
                                friendOrNot = true
                                isAddAlert = true
                            }
                        }
                        
                        // MARK: 친구 메시지 목록 불러와서 신청 메시지 있는지 확인
                        friendMessage = try await messageManager.fetchFriendMessage(userID: friend.id)
                        
                        for message in friendMessage {
                            if message.senderID == userInfoManager.currentUserInfo?.id ?? "" && message.messageType == "add" {
                                selectedFriend = friend
                                isAdded = true
                                isAddedAlert = true
                            }
                        }
                        
                        if !friendOrNot && !isAdded {
                            try await messageManager.sendMessage(Message(id: UUID().uuidString, messageType: "add", sendTime: Date(), senderID: userInfoManager.currentUserInfo?.id ?? "", receiverID: friend.id))
                            selectedFriend = friend
                            isAddAlert = true
                        }
                    }
                }
            } label: {
                Text(isRemoveOrAdd ? "삭제" : "추가")
                    .modifier(FriendButtonModifier())
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

//struct FriendsEditLow_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsEditRow(friend: User(id: "", name: "", email: "", pw: "", proImage: "", badge: [""], friends: [""]), isRemoveOrAdd: true)
//    }
//}
