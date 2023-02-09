//
//  ChallengeCellView.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/18.
//

import SwiftUI

struct ChallengeCellView: View {
 
    var challenge: Challenge
    var isCheckedInDevice: Bool = false
    
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var userInfoManager: UserInfoManager
    @State var currentUserInfos: [User]
    // MARK: - Body
    var body: some View {
        HStack {
            Button {
                // firestore에 업데이트 함수 제작 요망
                // challenge.isChecked.toggle()
                habitManager.loadChallengeIsChecked(challenge: challenge)
        
            } label: {
                Image(systemName: challenge.isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundColor(challenge.isChecked ? .green : .gray)
                
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 5)
            //checkButton
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
                    ForEach(currentUserInfos){ user in
                        Image("\(user.proImage)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .offset(y: 5)
                            .frame(width: 25)
                            .background(Color(.white))
                            .clipShape(Circle())
                            .overlay(Circle().stroke())
                            .foregroundColor(.gray)
                            .padding(.trailing, -12)
                    }
                }
                .font(.custom("IMHyemin-Regular", size: 15))//HStack
                
            }//VStack
            Spacer()
            
        }//HStack
        .padding(20)
        .foregroundColor(.black)
        .background(
            .white
        )
        .cornerRadius(20)
        .onAppear(){
            currentUserInfos = []
            Task{
                for member in challenge.mateArray {
                    try await currentUserInfos.append(userInfoManager.getUserInfoByUID(userUid: member)  ?? User(id: "", name: "", email: "", pw: "", proImage: "bearWhite", badge: [], friends: []))
                }
                
            }
        }
        //MARK: 프로그레스 뷰를 사용하게 된다면 이 부분.
//        .overlay(
//            VStack{
//                Spacer()
//                ZStack{
//                    Rectangle()
//                        .frame(height: 4)
//                        .padding([.top, .leading, .trailing], 10)
//                        .foregroundColor(Color(UIColor.lightGray))
//                    
//                    HStack{
//                        //                    Image("duckBoat")
//                        //                        .resizable()
//                        //                        .aspectRatio(contentMode: .fit)
//                        //                        .frame(width: 20)
//                        
//                        
//                        Rectangle()
//                            .frame(width: (CGFloat(dateFromStart)/CGFloat(66)) * UIScreen.main.bounds.size.width ,height: 4)
//                            .padding([.top, .leading, .trailing], 10)
//                        Spacer()
//                    }
//                }
//            }
//        )
    }// body
}

//struct ChallengeCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChallengeCellView(challenge: .constant(Challenge(id: UUID().uuidString, creator: "박진주", mateArray: [], challengeTitle: "물 500ml 마시기", createdAt: Date(), count: 0, isChecked: false)))
//    }
//}
