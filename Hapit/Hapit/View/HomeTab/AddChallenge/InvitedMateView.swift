//
//  InvitedMateView.swift
//  Hapit
//
//  Created by 김예원 on 2023/02/02.
//

import SwiftUI

struct InvitedMateView: View {
    @EnvironmentObject var habitManager: HabitManager
    @Binding var temeFriend: [ChallengeFriends]

    var body: some View {
        ScrollView(.horizontal){
            HStack{
                ForEach(habitManager.seletedFriends){ friend in
                    if friend.isChecked{
                        AddChallengeMateProfileView(mateName: friend.name, proImage: friend.proImage)
                    }
                }
            }.padding(.horizontal)
        }
    }
}

struct InvitedMateView_Previews: PreviewProvider {
    static var previews: some View {
        InvitedMateView( temeFriend: .constant([ChallengeFriends(uid: "",proImage: "",name: "dddd")]))
    }
}
