//
//  FriendChallengeView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/18.
//

import SwiftUI

struct FriendChallengeView: View {
    // TODO: 나중에 Binding 값으로
    @State var didHabit: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView{
                NavigationLink {
                    Text("디테일이 들어가는 곳")
                } label: {
                    ChallengeCellView(didHabit: $didHabit)
                }
                
                NavigationLink {
                    Text("디테일이 들어가는 곳")
                } label: {
                    ChallengeCellView(didHabit: $didHabit)
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
