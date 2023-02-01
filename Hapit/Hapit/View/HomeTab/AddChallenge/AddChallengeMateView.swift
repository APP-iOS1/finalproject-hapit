//
//  AddChallengeMateView.swift
//  Hapit
//
//  Created by 김예원 on 2023/01/31.
//

import SwiftUI

struct AddChallengeMateView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var authManager: AuthManager
    // 더미 데이터 현재 친구 리스트가 없음
    @State var mateArray: [String] = ["김예원", "박민주", "신현준", "릴루","이지", "로로", "가나", "릴루","ddd", "보리", "가지", "아이스크림"]
    var body: some View {
        
        ZStack{
            VStack{
                ScrollView{
                    VStack{
                        ForEach(mateArray,id: \.self) { mate in
                            // 선택된 셀의 값을 저장하는 변수가 필요
                            AddChallengeMateCellView(mateName: mate)
                        }
                    }
                }
                .padding(.top,20)
                
                Button{
                    // 초대하기를 누르면 선택된 셀에 해당하는 친구들을 groupArray에 넣을 수 있음
                }label: {
                    Text("초대하기")
                        .foregroundColor(.white)
                        .frame(width: 330,height: 50)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                        }
                }
            }
        }.background(Color("BackgroundColor").ignoresSafeArea())
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
        AddChallengeMateView()
    }
}
