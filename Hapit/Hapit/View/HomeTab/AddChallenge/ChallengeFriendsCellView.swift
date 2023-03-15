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
//    @Binding var challengeFriend: ChallengeFriends
//    //선택한 친구 임시 저장
//    @Binding var tempFriend: [ChallengeFriends]

    var selectedFriend: User
    @Binding var tempFriends: [User]
    @State private var isChecked: Bool = false
    
    var body: some View {
        VStack {
            Button {
                // 친구 선택
                isChecked.toggle()
                
                // true면 추가, false면 삭제
                if isChecked {
                    tempFriends.append(selectedFriend)
                } else {
                    for (index, friend) in tempFriends.enumerated() {
                        if friend == selectedFriend {
                            tempFriends.remove(at: index)
                        }
                    }
                }
            } label: {
                HStack{
                    Image(selectedFriend.proImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 40)
                        .background(Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 60, height: 60))
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    
                    Text(selectedFriend.name)
                        .font(.custom("IMHyemin-Bold", size: 17)).padding(10)

                    Spacer()
                    
                    Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                        .font(.title)
                        .foregroundColor(isChecked ? .green : Color("GrayFontColor"))
                    
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 5)
                
            }//HStack
            .padding(10)
            .background(Color("CellColor"))
            .cornerRadius(15)
            .padding(.horizontal, 20)
            .padding(.bottom, 5)
            
        }
    }
}
