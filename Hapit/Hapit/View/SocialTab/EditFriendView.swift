//
//  EditFriendView.swift
//  Hapit
//
//  Created by 이주희 on 2023/02/04.
//

import SwiftUI

struct EditFriendView: View {
    @EnvironmentObject var userInfoManager: UserInfoManager
    @Binding var friends: [User]
    @State private var isAddAlert = false
    @State private var isAddedAlert = false
    @State private var isRemoveAlert = false
    @State private var friendOrNot = false
    @State private var isAdded = false
    @State private var selectedFriend = User(id: "", name: "", email: "", pw: "", proImage: "", badge: [""], friends: [""], loginMethod: "", fcmToken: "")
    
    var body: some View {
        ZStack {
            VStack {
                NavigationLink {
                    AddFriendView(isAddAlert: $isAddAlert, isAddedAlert: $isAddedAlert,
                                  isRemoveAlert: $isRemoveAlert, friendOrNot: $friendOrNot,
                                  isAdded: $isAdded, selectedFriend: $selectedFriend)
                } label: {
                    Text("새로운 친구 추가하기")
                        .font(.custom("IMHyemin-Bold", size: 17))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.accentColor)
                                .frame(width: 350, height: 50))
                }
                
                if friends.isEmpty {
                    Image(systemName: "arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .padding(.top, 20)
                    Text("친구를 추가해보세요")
                        .font(.custom("IMHyemin-Bold", size: 20))
                }
                
                ScrollView {
                    ForEach(Array(friends.enumerated()), id: \.1) { (index, friend) in
                        FriendsEditRow(isAddAlert: $isAddAlert, isAddedAlert: $isAddedAlert, isRemoveAlert: $isRemoveAlert, friendOrNot: $friendOrNot, isAdded: $isAdded, selectedFriend: $selectedFriend, friend: friend, isRemoveOrAdd: true)
                    }
                }
                .padding(.top, 10)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity)
        .background(Color("BackgroundColor"))
        .task {
            await userInfoManager.fetchUserInfo()
        }
        .customAlert(isPresented: $isRemoveAlert,
                     title: "정말 삭제하실 건가요?",
                     message: "삭제해도 메시지는 가지 않아요❗️",
                     primaryButtonTitle: "삭제",
                     primaryAction: { Task {
            try await userInfoManager.removeFriendData(userID: userInfoManager.currentUserInfo?.id ?? "",
                                                       friendID: selectedFriend.id)
        }},
                     withCancelButton: true)
    }
}
