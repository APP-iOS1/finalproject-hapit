//
//  InvitedMateView.swift
//  Hapit
//
//  Created by 김예원 on 2023/02/02.
//

import SwiftUI

struct InvitedMateView: View {
    @EnvironmentObject var habitManager: HabitManager

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(habitManager.selectedFriends) { friend in
                        MateProfileView(mateName: friend.name, proImage: friend.proImage)
                } 
            }.padding(.horizontal)
        }
    }
}
