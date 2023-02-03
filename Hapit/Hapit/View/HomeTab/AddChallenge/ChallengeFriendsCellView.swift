//
//  ChallengeFriendsCellView.swift
//  Hapit
//
//  Created by 김예원 on 2023/02/03.
//

import SwiftUI

struct ChallengeFriendsCellView: View {
    @EnvironmentObject var habitManager: HabitManager
    
    // 친구 데이터
    @State var challengeFriends: ChallengeFriends
    //선택한 친구 임시 저장
    @Binding var temeFriend: [ChallengeFriends]

    @State var isChecked: Bool = false
    
    @State private var isSelectedJelly = 0
    let bearArray = Jelly.allCases.map({"\($0)"})
    
    var body: some View {
        VStack {
            Button {
                // 친구 선택
                isChecked.toggle()
                challengeFriends.isChecked.toggle()
                temeFriend.append(challengeFriends)
            } label: {
                HStack{
                    Image(bearArray[isSelectedJelly % 7])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 40)
                        .background(Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 60, height: 60))
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    
                    Text(challengeFriends.name)
                        .font(.custom("IMHyemin-Bold", size: 17)).padding(10)
                    Text(String(challengeFriends.isChecked))
                    Spacer()
                    
                    Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                        .font(.title)
                        .foregroundColor(isChecked ? .green : .gray)
                    
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 5)
                
            }//HStack
            .padding(10)
            .foregroundColor(.black)
            .background(.white)
            .cornerRadius(15)
            .padding(.horizontal, 20)
            .padding(.bottom, 5)
            
        }
    }
}

struct ChallengeFriendsCellView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChallengeFriendsCellView(challengeFriends: ChallengeFriends(uid: "1231211", proImage: "", name: "bearJelly"),temeFriend: .constant([ChallengeFriends(uid: "1231211", proImage: "", name: "bearJelly")]))
    }
    
}
