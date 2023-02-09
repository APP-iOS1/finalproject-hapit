//
//  FriendChallengeCellView.swift
//  Hapit
//
//  Created by 김예원 on 2023/02/07.
//

import SwiftUI

struct FriendChallengeCellView: View {
    @EnvironmentObject var userInfoManager: UserInfoManager
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var habitManager: HabitManager

    @State var challengeWithMe: Bool = false
    @State var challenge: Challenge
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 1){
                VStack(alignment: .leading, spacing: 2){
                    Text(challenge.createdDate)
                        .font(.custom("IMHyemin-Regular", size: 13))
                        .foregroundColor(.gray)
                    Text(challenge.challengeTitle)
                        .font(.custom("IMHyemin-Bold", size: 22))
                }//VStack
                
                HStack(spacing: 5){
                    Text(Image(systemName: "flame.fill"))
                        .foregroundColor(.orange)
                    Text("연속 \(challenge.count)일째")
                    Spacer()
                //FIXME: - 함께하는 챌린지인 경우 표시해주는 코드가 필요
                 // if challengeWithMe {
                        Text("함께 챌린지 중")
                            .foregroundColor(Color("AccentColor"))
                            .font(.custom("IMHyemin-Bold", size: 12))
                 //  }
                }
                .font(.custom("IMHyemin-Regular", size: 15))//HStack
                
            }//VStack
            Spacer()
            
        }//HStack
        .padding(20)
        .foregroundColor(.black)
        .background(.white)
        .cornerRadius(20)
        .padding(.horizontal)
//FIXME: - 함께하는 챌린지인 경우 표시해주는 코드가 필요
//        .onAppear {
//            do{
//
//                Task{
//
//                    let current = authManager.firebaseAuth
//                   let currentUser = current.currentUser?.uid
//
//                    for challenge in habitManager.challenges {
//                        for mate in challenge.mateArray{
//                            if mate == currentUser{
//                                challengeWithMe.toggle()
//                            }
//                        }
//                    }
//                }
//            }
//            catch{
//
//            }
//        }
    }
}

struct FriendChallengeCellView_Previews: PreviewProvider {
    static var previews: some View {
        FriendChallengeCellView(challenge: Challenge(id: "", creator: "박진주", mateArray: [], challengeTitle: "책 읽기", createdAt: Date(), count: 1, isChecked: false, uid: ""))
    }
}
