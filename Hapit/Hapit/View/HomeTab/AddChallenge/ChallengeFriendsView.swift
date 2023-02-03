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
    @State var isChecked: Bool = false
    
    //친구 더미 데이터
    @State var friends: [ChallengeFriends]
    //친구 데이터 임시 저장
    @Binding var temeFriend: [ChallengeFriends]
    
    var body: some View {
        ZStack {
            Spacer()
            VStack {
                ScrollView {
                        ForEach(friends, id: \.self) { friend in
                            let mate = ChallengeFriends(uid: friend.uid, proImage: friend.proImage ,name: friend.name)
                            ChallengeFriendsCellView(challengeFriends: mate,temeFriend: $temeFriend)
                        }.padding(.top,20)
                    
                }
                Button{
                    habitManager.seletedFriends = temeFriend
                    temeFriend = []
                    dismiss()
                }label: {
                    Text("함께할 친구 추가하기")
                        .foregroundColor(.white)
                        .frame(width: 330,height: 50)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                        }
                }//Button
            }//VStack
        }//ZStack
        .background(Color("BackgroundColor").ignoresSafeArea())
        .navigationBarTitle("함께할 친구 고르기")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "multiply")
                        .foregroundColor(.gray)
                } // label
            } // ToolbarIte
        } // toolbar
    }
}

struct ChallengeFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeFriendsView(friends: [ChallengeFriends(uid: "1", proImage: "",name: "김예원"),ChallengeFriends(uid: "2", proImage: "",name: "박민주"),ChallengeFriends(uid: "3", proImage: "",name: "신현준"),ChallengeFriends(uid: "4", proImage: "",name: "이주희"),ChallengeFriends(uid: "5", proImage: "",name: "김응관"),ChallengeFriends(uid: "6", proImage: "",name: "추현호")],temeFriend: .constant([ChallengeFriends(uid: "1", proImage: "",name: "김예원")]))
    }
}
