//
//  AddFriendView.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/18.
//

import SwiftUI

struct AddFriendView: View {
    @EnvironmentObject var userInfoManager: UserInfoManager
    @EnvironmentObject var messageManager: MessageManager
    @State private var friendNameText: String = ""
    @State private var users = [User]()
    @Binding var isAddAlert: Bool
    @Binding var isAddedAlert: Bool
    @Binding var isRemoveAlert: Bool
    @Binding var friendOrNot: Bool
    @Binding var isAdded: Bool
    @Binding var selectedFriend: User
    @State private var isContained = false
    
    var body: some View {
        VStack {
            // MARK: Title Image
            Image("fourbears")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
                
            // MARK: Title
            Text("친구를 찾아보세요! 🔍")
                .font(.custom("IMHyemin-Bold", size: 28))
            
            // MARK: TextField
            TextField("닉네임을 정확하게 입력해주세요 :)", text: $friendNameText)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
                .font(.custom("IMHyemin-Bold", size: 17))
                .padding(EdgeInsets(top: 15, leading: 21, bottom: 15, trailing: 21))
                .background{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentColor, lineWidth: 1)
                }
                .padding()
            
            // MARK: List
            ScrollView {
                ForEach(Array(users.enumerated()), id: \.1) { (index, user) in
                    if user.name.contains(friendNameText) {
                        FriendsEditRow(isAddAlert: $isAddAlert, isAddedAlert: $isAddedAlert,
                                       isRemoveAlert: $isRemoveAlert, friendOrNot: $friendOrNot,
                                       isAdded: $isAdded, selectedFriend: $selectedFriend,
                                       friend: user, isRemoveOrAdd: false)
                    }
                }
            }
            Spacer()
        }
        .background(Color("BackgroundColor"))
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
                     primaryAction: {
            isAddAlert = false
            friendOrNot = false
        },
                     withCancelButton: false)
        .customAlert(isPresented: $isAddedAlert,
                     title: "친구 신청 완료!",
                     message: "해피들이 메시지를 전달했으니 조금만 기다려주세요 💌",
                     primaryButtonTitle: "닫기",
                     primaryAction: {
            isAddedAlert = false
            isAdded = false
        },
                     withCancelButton: false)
    }
}
