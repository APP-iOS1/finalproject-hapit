//
//  FriendChallengeView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/18.
//

import SwiftUI

struct FriendChallengeView: View {
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var userInfoManager: UserInfoManager
    @EnvironmentObject var authManager: AuthManager
    // 친구의 User 정보
    @State var friend: User
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView{
                    VStack{
                        ForEach(habitManager.challenges) { challenge in
                            // 친구가 진행 중인 챌린지 보여주기
                            if challenge.mateArray.contains(friend.id) {
                                FriendChallengeCellView(challenge: challenge, friendId: friend.id)
                            }
                        }
                    }
                }
            }.background(Color("BackgroundColor"))
        }
    }
}
