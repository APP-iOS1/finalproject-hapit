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
    
    var body: some View {
        ZStack {
            VStack {
                NavigationLink {
                    AddFriendView()
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
                
                ScrollView {
                    // TODO: 본인 표시 해줘야함 -> 셀 색깔로?
                    ForEach(Array(friends.enumerated()), id: \.1) { (index, friend) in
                        FriendsEditRow(friend: friend, isRemoveOrAdd: true)
                    }
                }
            }
        }.background(Color("BackgroundColor"))
            .onAppear {
                Task {
                    // 여기서 바로 패치안됨;
                    await userInfoManager.fetchUserInfo()
                }
            }
    }
}

//struct EditFriendView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditFriendView(friends: [User]())
//    }
//}
