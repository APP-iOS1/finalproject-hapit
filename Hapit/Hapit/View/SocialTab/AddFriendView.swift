//
//  AddFriendView.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/18.
//

import SwiftUI

struct AddFriendView: View {
    @EnvironmentObject var userInfoManager: UserInfoManager
    @State private var friendNameText: String = ""
    @State private var users = [User]()
    @Binding var isAddAlert: Bool
    @Binding var isRemoveAlert: Bool
    @Binding var friendOrNot: Bool
    @Binding var selectedFriend: User
    @State private var isContained = false
    
    var body: some View {
        VStack {
            // MARK: Title Image
            Image("fourbears")
                .resizable()
                .frame(width: 150, height: 90)
            
            // MARK: Title
            Text("친구를 찾아보세요")
                .font(.custom("IMHyemin-Bold", size: 28))
            
            // MARK: TextField
            TextField("닉네임을 정확하게 입력하세요", text: $friendNameText)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("MiddlePinkColor"))
                }
                .padding()
            
            // MARK: List
            ScrollView {
                ForEach(Array(users.enumerated()), id: \.1) { (index, user) in
                    if user.name.contains(friendNameText) {
                        FriendsEditRow(isAddAlert: $isAddAlert, isRemoveAlert: $isRemoveAlert, friendOrNot: $friendOrNot, selectedFriend: $selectedFriend, friend: user, isRemoveOrAdd: false)
                            .padding(-5)
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            users = userInfoManager.userInfoArray
            // 닉네임 검색 시 본인 안뜨게 본인 정보 삭제
            for (index, user) in users.enumerated() {
                if user.name == userInfoManager.currentUserInfo?.name ?? "" {
                    users.remove(at: index)
                }
            }
        }
        .customAlert(isPresented: $isAddAlert,
                     title: friendOrNot ? "😮" : "친구 신청 완료!",
                     message: friendOrNot ? "이미 친구인 유저예요❗️" : "해피들이 메시지를 전달했어요 💌",
                     primaryButtonTitle: "완료",
                     primaryAction: { isAddAlert = false
            friendOrNot = false
        },
                     withCancelButton: false)
    }
}

//struct AddFriendView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddFriendView()
//    }
//}
