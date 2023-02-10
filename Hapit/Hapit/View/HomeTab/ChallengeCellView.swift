//
//  ChallengeCellView.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/18.
//

import SwiftUI
import RealmSwift

struct ChallengeCellView: View {

    // MARK: - Property Wrappers
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var userInfoManager: UserInfoManager
    @State var currentUserInfos: [User]
    @State private var isChecked: Bool = false
    @ObservedRealmObject var localChallenge: LocalChallenge // 로컬챌린지에서 각 필드를 업데이트 해주기 위해 선언 - 담을 그릇
    @ObservedResults(LocalChallenge.self) var localChallenges // 새로운 로컬챌린지 객체를 담아주기 위해 선언 - 데이터베이스
    
//    @ObservedResults(
//        LocalChallenge.self,
//      where: { $0.challengeId == true }
//    ) var localChallenges
    
    // MARK: - Properties
    var challenge: Challenge
    var isCheckedInDevice: Bool = false
    
    // MARK: - Body
    var body: some View {
        HStack {
            Button {
                // 체크 데이터 토글
                isChecked.toggle()

                // Realm에 체크 정보 저장 - 뷰가 바뀌기 전까지 로컬에 체크 정보를 저장해두기 위함.
                $localChallenge.isChecked.wrappedValue = isChecked
        
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
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 20))
        .contextMenu {
            Button(role: .destructive) {
                // 챌린지 삭제
                habitManager.removeChallenge(challenge: challenge)
            } label: {
                Text("챌린지 지우기")
                    .font(.custom("IMHyemin-Regular", size: 17))
                Image(systemName: "trash")
            }
        } // contextMenu
        .onAppear(){
            currentUserInfos = []
            Task {
                // 함께 챌린지 진행하는 친구들 프사
                for member in challenge.mateArray {
                    try await currentUserInfos.append(userInfoManager.getUserInfoByUID(userUid: member)  ?? User(id: "", name: "", email: "", pw: "", proImage: "bearWhite", badge: [], friends: []))
                }
            }
            
            // 해당 뷰에서만 쓰이는 체크 변수에다가 서버에 저장된 챌린지 체크 정보 저장
            isChecked = challenge.isChecked
        }
        .onDisappear {
            // 뷰가 사라질 때 서버에 체크 정보를 업로드
//            habitManager.loadChallengeIsChecked(challenge: challenge)
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
