//
//  ChallengeFriendsView.swift
//  Hapit
//
//  Created by 김예원 on 2023/02/03.
//

import SwiftUI

struct ChallengeFriendsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var userInfoManager: UserInfoManager
    
    @State var tempFriends: [User] = []
    
    var body: some View {
        ZStack {
            Spacer()
            VStack {
                ScrollView {
                    ForEach(userInfoManager.friendArray, id: \.self) { friend in
                        ChallengeFriendsCellView(selectedFriend: friend, tempFriends: $tempFriends)
                        }
                        .padding(.top, 20)
                }
                
                Button{
                    habitManager.selectedFriends = tempFriends
                    tempFriends = []
                    dismiss()
                }label: {
                    Text("함께할 친구 추가하기")
                        .font(.custom("IMHyemin-Bold", size: 16))
                        .foregroundColor(.white)
                        .frame(width: 330,height: 50)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                        }
                }//Button
                .padding(.bottom, 10)
            }//VStack
        }//ZStack
        .background(Color("BackgroundColor").ignoresSafeArea())
        .navigationBarTitle("함께할 친구 고르기")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    habitManager.selectedFriends.removeAll()
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                } // label
            } // ToolbarIte
        } // toolbar
    }
}
