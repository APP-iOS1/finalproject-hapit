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
    @Binding var isRemoveAlert: Bool
    @Binding var friendOrNot: Bool
    @Binding var selectedFriend: User
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
                        selectedFriend = friend
                        isRemoveAlert = true
                    } else {
                    // 추가 셀
                        // TODO: 이미 친구인 상태면 Alert 띄우고 신청 못하게 하기
                        if let friendArray = userInfoManager.currentUserInfo?.friends {
                            if friendArray.contains(friend.id) {
                                friendOrNot = true
                                isAddAlert = true
                            }
                        }
                        try await messageManager.sendMessage(Message(id: UUID().uuidString, messageType: "add", sendTime: Date(), senderID: userInfoManager.currentUserInfo?.id ?? "", receiverID: friend.id))
                        isAddAlert = true
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
