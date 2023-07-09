//
//  FriendsEditLow.swift
//  Hapit
//
//  Created by 이주희 on 2023/02/06.
//

import SwiftUI
import FirebaseAuth

// MARK: 이 뷰는 EditFriendView와 AddFriendView의 공용 셀뷰입니다
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
                .font(.custom("IMHyemin-Bold", size: 17))
            
            Spacer()
            
            Button {
                Task {
                    // 삭제 셀
                    if isRemoveOrAdd {
                        // MARK: 친구 선택해서 selectedFriend 커스텀 모달로 넘겨주기
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
                        
                        // MARK: 친구상태 아니고 친구신청 보내지 않았으면 친구 추가
                        if !friendOrNot && !isAdded {
                            try await messageManager.sendMessage(Message(id: UUID().uuidString,
                                                                         messageType: "add",
                                                                         sendTime: Date(),
                                                                         senderID: userInfoManager.currentUserInfo?.id ?? "",
                                                                         receiverID: friend.id,
                                                                         isRead: false,
                                                                         challengeID: ""))
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
        .background(Color("CellColor"))
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.bottom, 7)
    }
}

//struct FriendsEditLow_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsEditRow(friend: User(id: "", name: "", email: "", pw: "", proImage: "", badge: [""], friends: [""]), isRemoveOrAdd: true)
//    }
//}
