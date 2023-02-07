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
                    NavigationLink {
                        
                        //  ChallengeCellView(challenge: dummyChallenge)
                    } label: {
                        VStack{
                            ForEach(habitManager.challenges) { challenge in
                                if challenge.uid == friend.id {
                                    FriendChallengeCellView(challenge: challenge)
                                }
                            }
                            
                            ForEach(habitManager.challenges) { challenge in
                                ForEach(challenge.mateArray, id: \.self){ mate in
                                    if mate == friend.id{
                                        FriendChallengeCellView(challenge: challenge)
                                    }
                                }
                            }
                        }
                    }
                }
            }.background(Color("BackgroundColor"))
        }
    }
}
struct FriendChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        FriendChallengeView(friend: User(id: "", name: "yewon", email: "yewon", pw: "", proImage: "", badge: [""], friends: [""]))
        
    }
}
