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
                        try await userInfoManager.removeFriendData(userID: userInfoManager.currentUserInfo?.id ?? "", friendID: friend.id)
                    } else {
                    // 추가 셀
                        try await messageManager.sendMessage(Message(id: UUID().uuidString, messageType: "add", sendTime: Date(), senderID: userInfoManager.currentUserInfo?.id ?? "", receiverID: friend.id))
                    }
                }
            } label: {
                Text(isRemoveOrAdd ? "삭제" : "추가")
                    .foregroundColor(.white)
                    .bold()
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.accentColor))
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
