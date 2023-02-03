//
//  InvitedMateView.swift
//  Hapit
//
//  Created by 김예원 on 2023/02/02.
//

import SwiftUI

struct InvitedMateView: View {
    @EnvironmentObject var habitManager: HabitManager
    @Binding var tempMate: [ChallengeMate]
    var body: some View {
        ScrollView(.horizontal){
            HStack{
                ForEach(habitManager.seletedMate){ mate in
                    if mate.isChecked{
                        AddChallengeMateProfileView(mateName: mate.name)
                    }
                }
            }.padding(.horizontal,20)
        }
//        .onChange(of: tempMate) { newValue in
//            habitManager.seletedMate = []
//        }
    }
}

struct InvitedMateView_Previews: PreviewProvider {
    static var previews: some View {
        InvitedMateView( tempMate: .constant([ChallengeMate(name: "dddd")]))
    }
}
