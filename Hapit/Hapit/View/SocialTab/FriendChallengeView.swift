//
//  FriendChallengeView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/18.
//

import SwiftUI

struct FriendChallengeView: View {
    // TODO: 나중에 Binding 값으로
    // MARK: 더미 데이터
    @State var dummyChallenge: Challenge = Challenge(id: UUID().uuidString, creator: "박진주", mateArray: [], challengeTitle: "책 읽기", createdAt: Date(), count: 1, isChecked: false)

    var body: some View {
        ZStack {
            ScrollView{
                NavigationLink {
                    Text("디테일이 들어가는 곳")
                } label: {
                    ChallengeCellView(challenge: $dummyChallenge)
                }
                
                NavigationLink {
                    Text("디테일이 들어가는 곳")
                } label: {
                    ChallengeCellView(challenge: $dummyChallenge)
                }
            }
        }.background(Color("BackgroundColor"))
    }
}


struct FriendChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        FriendChallengeView()
    }
}
