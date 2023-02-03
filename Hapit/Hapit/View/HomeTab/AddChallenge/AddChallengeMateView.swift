//
//  AddChallengeMateView.swift
//  Hapit
//
//  Created by 김예원 on 2023/01/31.
//

import SwiftUI

// 모델로 빼기
struct ChallengeMate: Identifiable,Hashable{
    var id = UUID()
    var isChecked: Bool = false
    var name: String

 }

struct AddChallengeMateView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var authManager: AuthManager
    
    // 더미 데이터 - 현재 친구 리스트 addChallengeView에서 바인딩
    var myFriendArray: [String]
    //친구리스트 임시저장
    @Binding var tempMate: [ChallengeMate]
    
    var body: some View {
        ZStack {
            Spacer()
            VStack {
                ScrollView {
                        ForEach(myFriendArray, id: \.self) { myFriend in
                            let mate = ChallengeMate(name: myFriend)
                            AddChallengeMateCellView(tempMate: $tempMate, selectedMateArray: mate)
                        }.padding(.top,20)
                }
                Button{
                    habitManager.seletedMate = tempMate
                    tempMate = []
                    dismiss()
                }label: {
                    Text("초대하기")
                        .foregroundColor(.white)
                        .frame(width: 330,height: 50)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                        }
                }//Button
            }//VStack
        }//ZStack
            .background(Color("BackgroundColor").ignoresSafeArea())
            .navigationBarTitle("친구초대")
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

struct AddChallengeMateView_Previews: PreviewProvider {
    static var previews: some View {
        AddChallengeMateView(myFriendArray: ["dummy","dummy1","dummy2","dummy3","dummy4"], tempMate: .constant([ChallengeMate(name: "dummy")]))
    }
}
