//
//  FriendChallengeCellView.swift
//  Hapit
//
//  Created by 김예원 on 2023/02/07.
//

import SwiftUI

let ReceiverFCMToken = "d2Fzp0SUCk2hh5aOenaMFF:APA91bF-IozEiFodJmBoSHxBhODZZkaEuW5z3wWPdF_zsdkT1a_ARXhn-zBP7f3LvFuPYGOi3LxTxXhgMW2YRdchMdrcM4ojdRnyOEQwpuChldgiZhK2o_29KLRsJKcYt4VL7S1Tk6Oa"

struct FriendChallengeCellView: View {
    @EnvironmentObject var userInfoManager: UserInfoManager
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var habitManager: HabitManager

    @State var challengeWithMe: [Challenge] = []
    @State var challenge: Challenge
    
    @State private var notificationContent: String = ""
    @ObservedObject private var datas = fcmManager

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 1){
                VStack(alignment: .leading, spacing: 2){
                    Text(challenge.createdDate)
                        .font(.custom("IMHyemin-Regular", size: 13))
                        .foregroundColor(.gray)
                    HStack {
                        Text(challenge.challengeTitle)
                            .font(.custom("IMHyemin-Bold", size: 22))
                        Button{
                            self.datas.sendMessageTouser(datas: self.datas,to: ReceiverFCMToken, title: "Test" , body: "Test")
                            self.notificationContent = ""
                        } label: {
                            Image(systemName: "hand.tap.fill")
                        }
                    }
                }//VStack
                
                HStack(spacing: 5){
                    Text(Image(systemName: "flame.fill"))
                        .foregroundColor(.orange)
                    Text("연속 \(challenge.count)일째")
                    Spacer()
                    
                    ForEach(challengeWithMe){ challenge in
                        if challenge.id == self.challenge.id {
                            Text("함께 챌린지 중")
                                .foregroundColor(Color("AccentColor"))
                                .font(.custom("IMHyemin-Bold", size: 12))
                        }
                    }
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
        .onAppear {
            do{
                Task{
                    let current = authManager.firebaseAuth
                   let currentUser = current.currentUser?.uid

                    for challenge in habitManager.challenges {
                        for mate in challenge.mateArray{
                            if mate == currentUser{
                                challengeWithMe.append(challenge)
                            }
                        }
                    }
                }
            }
            catch{

            }
        }
    }
}

//struct FriendChallengeCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendChallengeCellView(challenge: Challenge(id: "", creator: "박진주", mateArray: [], challengeTitle: "책 읽기", createdAt: Date(), count: 1, isChecked: false, uid: ""))
//    }
//}
