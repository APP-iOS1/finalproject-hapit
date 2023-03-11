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
    
    @State var currentUserInfos: [User] = []
    @State var tempIsChecked: Bool = false
    
    @ObservedRealmObject var localChallenge: LocalChallenge // 로컬챌린지에서 각 필드를 업데이트 해주기 위해 선언 - 담을 그릇
    @ObservedResults(LocalChallenge.self) var localChallenges // 새로운 로컬챌린지 객체를 담아주기 위해 선언 - 데이터베이스
    @ObservedResults(LocalChallenge.self) var localHabits
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
                //TODO: 로컬데이터로 개편부탁ㅎ;
                VStack(alignment: .leading, spacing: 1){
                    VStack(alignment: .leading, spacing: 2){
                        //TODO: 여기 데이트형태 어케 변환시키면 좋을지 생각점 해볼게잉
                        Text($localChallenge.createdDate.wrappedValue)
                            .font(.custom("IMHyemin-Regular", size: 13))
                            .foregroundColor(Color("GrayFontColor"))
                        Text($localChallenge.challengeTitle.wrappedValue)
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
                    //TODO: 로컬에서만 먼저 삭제하고, Firestore는 냅둬보자..(성능 업시키려고)
                    
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
                    // 66일이 아닌 경우에만(습관이 되지 않은 경우에만)
                    if $localChallenge.count.wrappedValue < 66 {
                        // 로컬에 업데이트
                        $localChallenge.count.wrappedValue = habitManager.countDays(count: $localChallenge.count.wrappedValue,
                                                                                    isChecked: $localChallenge.isChecked.wrappedValue)
                        // 서버에 업데이트
                        //TODO: 파베의 연속일 업데이트도 잠시 넣어두고 나중에 한꺼번에 업데이트 해주기
                        // 초기화
                        $localChallenge.isChecked.wrappedValue = false
                    }
                }
                currentDate = getToday()
                currentUserInfos = []
            }
            .onAppear{
                //TODO: 로컬의 메이트 어레이 불러오는 거로...
//                Task {
//                    // 함께 챌린지 진행하는 친구들 프사
//                    for member in $localChallenge.mateList.wrappedValue {
//                        
//                        if member != userInfoManager.currentUserInfo?.id{
//                            
//                            let memberUser = try await userInfoManager.getUserInfoByUID(userUid: member)
//                            
//                            currentUserInfos.append(memberUser ?? User(id: "", name: "", email: "", pw: "", proImage: "bearWhite", badge: [], friends: [], loginMethod: "", fcmToken: ""))
//                            
//                        }
//                    }
//                }
            }
            .onChange(of: scenePhase) { _ in // 마지막에 접속한 날짜랑 현재 접속한 날짜랑 다를 경우
                if currentDate != getToday() {
                    if $localChallenge.count.wrappedValue < 66 {
                        // 로컬에 업데이트
                        $localChallenge.count.wrappedValue = habitManager.countDays(count: $localChallenge.count.wrappedValue,
                                                                                    isChecked: $localChallenge.isChecked.wrappedValue)
                        // 초기화
                        $localChallenge.isChecked.wrappedValue = false
                    } else if $localChallenge.count.wrappedValue == 66 {
                        // 로컬해빗에 추가해주고 로컬 챌린지 배열에서 지워준다
                        $localHabits.append(localChallenge)
                        $localChallenges.remove(localChallenge)
                        
                    }
                }
                
                currentDate = getToday()
            }
            
            if $localChallenge.isChecked.wrappedValue == true {
                
                JellyConfetti(title: "")
            }
        }
    }
}
