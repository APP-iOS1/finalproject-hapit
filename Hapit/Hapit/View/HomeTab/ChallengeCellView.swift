//
//  ChallengeCellView.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/18.
//

import SwiftUI
import RealmSwift
import Combine

struct ChallengeCellView: View {
    
    // MARK: - Property Wrappers
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var userInfoManager: UserInfoManager
    @Environment(\.scenePhase) var scenePhase
    @State var currentUserInfos: [User]
    @State var tempIsChecked: Bool = false
    @ObservedRealmObject var localChallenge: LocalChallenge // 로컬챌린지에서 각 필드를 업데이트 해주기 위해 선언 - 담을 그릇
    @ObservedResults(LocalChallenge.self) var localChallenges // 새로운 로컬챌린지 객체를 담아주기 위해 선언 - 데이터베이스
    var challenge: Challenge
    
    @AppStorage("currentDate") var currentDate: String = UserDefaults.standard.string(forKey: "currentDate") ?? ""
    
    // MARK: - Method
    /// 오늘 날짜를 "yy년 MM월 dd일" 형태로 반환하는 함수
    func getToday() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yy년 MM월 dd일" // "yyyy-MM-dd HH:mm:ss"
        
        let dateCreatedAt = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
        
        return dateFormatter.string(from: dateCreatedAt)
    }
    
    // MARK: - Body
    var body: some View {
        ZStack{
            HStack {
                Button {
                    $localChallenge.isChecked.wrappedValue.toggle()
                    
                } label: {
                    Image(systemName: $localChallenge.isChecked.wrappedValue ? "checkmark.circle.fill" : "circle")
                        .font(.title)
                        .foregroundColor($localChallenge.isChecked.wrappedValue ? .green : Color("GrayFontColor"))
                    
                }
                .padding(.trailing, 5)
                .buttonStyle(PlainButtonStyle())
                
                //checkButton
                VStack(alignment: .leading, spacing: 1){
                    VStack(alignment: .leading, spacing: 2){
                        Text(challenge.createdDate)
                            .font(.custom("IMHyemin-Regular", size: 13))
                            .foregroundColor(Color("GrayFontColor"))
                        Text(challenge.challengeTitle)
                            .font(.custom("IMHyemin-Bold", size: 20))
                            .foregroundColor(Color("MainFontColor"))
                    }//VStack
                    
                    HStack(spacing: 5){
                        Text(Image(systemName: "flame.fill"))
                            .foregroundColor(.orange)
                        Text("연속 \($localChallenge.count.wrappedValue)일째")
                            .foregroundColor(Color("MainFontColor"))
                        Spacer()
                        ForEach(currentUserInfos){ user in
                            Image("\(user.proImage)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .offset(y: 5)
                                .frame(width: 25)
                                .background(Color("CellColor"))
                                .clipShape(Circle())
                                .overlay(Circle().stroke())
                                .foregroundColor(Color("GrayFontColor"))
                                .padding(.trailing, -12)
                        }
                    }
                    .font(.custom("IMHyemin-Regular", size: 15))//HStack
                    
                }//VStack
                Spacer()
                
            }//HStack
            .padding(20)
            //        .foregroundColor(.black)
            .background(
                Color("CellColor")
            )
            .cornerRadius(20)
            .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 20))
            .contextMenu {
                Button(role: .destructive) {
                    // Firestore에서 챌린지 삭제
                    habitManager.removeChallenge(challenge: challenge)
                    
                    // Realm에서 챌린지 삭제
                    $localChallenges.remove(localChallenge)
                } label: {
                    Text("챌린지 지우기")
                        .font(.custom("IMHyemin-Regular", size: 17))
                    Image(systemName: "trash")
                }
            } // contextMenu
            .onAppear() {
                if currentDate != getToday() { // 마지막에 접속한 날짜랑 현재 접속한 날짜랑 다를 경우 - 앱이 켜질 때마다 서버에 업로드되는 메모리 낭비를 방지
                    // 로컬에 업데이트
                    $localChallenge.count.wrappedValue = habitManager.countDays(count: $localChallenge.count.wrappedValue,
                                                                                isChecked: $localChallenge.isChecked.wrappedValue)
                    // 서버에 업데이트
                    habitManager.updateCount(challenge: challenge, count: $localChallenge.count.wrappedValue)
                    // 초기화
                    $localChallenge.isChecked.wrappedValue = false
                }
                currentDate = getToday()
                currentUserInfos = []
                Task {
                    // 함께 챌린지 진행하는 친구들 프사
                    for member in challenge.mateArray {
                        try await currentUserInfos.append(userInfoManager.getUserInfoByUID(userUid: member) ?? User(id: "", name: "", email: "", pw: "", proImage: "bearWhite", badge: [], friends: [], loginMethod: "", fcmToken: ""))
                    }
                }
         
            }
            .onChange(of: scenePhase) { _ in // 마지막에 접속한 날짜랑 현재 접속한 날짜랑 다를 경우
                if currentDate != getToday() { // 자정이 되는 순간
                    // 로컬에 업데이트
                    $localChallenge.count.wrappedValue = habitManager.countDays(count: $localChallenge.count.wrappedValue,
                                                                                isChecked: $localChallenge.isChecked.wrappedValue)
                    // 서버에 업데이트
                    habitManager.updateCount(challenge: challenge, count: $localChallenge.count.wrappedValue)
                    // 초기화
                    $localChallenge.isChecked.wrappedValue = false
                }
                currentDate = getToday()
            }
            
            if $localChallenge.isChecked.wrappedValue == true {
                
                    JellyConfetti(title: "")
//                        .onAppear{
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                                isShownConfetti = false
//                            }
//                        }
            }
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

