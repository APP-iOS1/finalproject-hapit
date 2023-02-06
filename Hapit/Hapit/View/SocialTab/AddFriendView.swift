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
    
    var body: some View {
        VStack {
            // MARK: Title Image
            Image("fourbears")
                .resizable()
                .frame(width: 120, height: 90)
            
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

                        FriendsEditRow(friend: user, isRemoveOrAdd: false)
                            .padding(-5)
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            // 여기서는 패치되어있음
//            print(userInfoManager.userInfoArray)
            users = userInfoManager.userInfoArray
        }
    }
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendView()
    }
}
