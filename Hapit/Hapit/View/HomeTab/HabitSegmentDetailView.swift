//
//  HabitSegmentDetailView.swift
//  Hapit
//
//  Created by 박진형 on 2023/02/02.
//

import SwiftUI
import RealmSwift

//MARK: 세그먼트로 개인습관 혹은 그룹습관을 선택해 볼 수 있다.
struct HabitSegmentDetailView: View {
    
    @Binding var selectedIndex: Int
    @State var date = Date()
    // 챌린지와 습관을 관리하는 객체
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var authManager: AuthManager
    
    @State private var isOnAlarm: Bool = false // 알림 설정
    @State private var showsCustomAlert = false // 챌린지 디테일 뷰로 넘길 값
    
    @ObservedResults(LocalChallenge.self) var localChallenges // 새로운 로컬챌린지 객체를 담아주기 위해 선언 - 데이터베이스
    
    var body: some View {
        switch selectedIndex {
        case 0:
            VStack {
                if habitManager.currentUserChallenges.count < 1 {
                    EmptyCellView(currentContentsType: .challenge)
                } else {
                    ScrollView {
                        ForEach(habitManager.currentUserChallenges) { challenge in
                            ForEach(challenge.mateArray, id: \.self) { mate in
                                if mate == authManager.firebaseAuth.currentUser?.uid {
                                    NavigationLink {
                                        ZStack{
                                            ScrollView(showsIndicators: false) {
                                                ForEach(localChallenges) { localChallenge in
                                                    if localChallenge.challengeId == challenge.id {
                                                        ChallengeDetailView(currentDate: $date, localChallenge: localChallenge, currentChallenge: challenge)
                                                    }
                                                } // ForEach - localChallenges
                                            }
                                            .padding()
                                            .background(Color("BackgroundColor"))
                                            ModalAnchorView()
                                        } // ZStack
                                        
                                    } label: {
                                        ForEach(localChallenges) { localChallenge in
                                            if localChallenge.challengeId == challenge.id {
                                                ChallengeCellView(currentUserInfos: [], localChallenge: localChallenge, challenge: challenge)
                                            }
                                        } // ForEach - localChallenges
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 5)
                                } // if
                            } // ForEach - mateArray
                        } // ForEach - currentUserChallenges
                    } // ScrollView
                    .onAppear {
                        restoreChallenges()
                        print(localChallenges)
                    } // onAppear
                    .refreshable { // MARK: - Only iOS 16
                        restoreChallenges()
                    } // refreshable
                } // else
            } // VStack
   
        case 1:
            if habitManager.habits.count < 1{
                EmptyCellView(currentContentsType: .habit)
            }
            else{
                ScrollView {
                    ForEach(habitManager.habits) { habit in
                        
                        NavigationLink {
                            //HabitDetailView(calendar: Calendar.current)
                        } label: {
                            HabitCellView(habit: habit)
                        }
                    }
                }
            }
            
        default: Text("something wrong")
        }// switch
    }
    
    // MARK: - 로컬에 있는 챌린지와 서버에 있는 챌린지 개수가 다를 경우 복구하는 함수 (앱을 삭제하고 재설치하는 경우)
    func restoreChallenges() {
        if countMyChallengesFromServer() != 0 && countLocalChallenges() == 0 {
            // 로컬에 있는 챌린지와 서버에 있는 챌린지 개수가 다를 경우, 앱이 삭제됐었던 것이므로 서버에 있는 챌린지들을 로컬에 다시 모두 담아준다.
            for localChallenge in localChallenges { // 로컬에 있는 챌린지 모두 삭제 (초기화)
                $localChallenges.remove(localChallenge)
            }
            for challenge in habitManager.currentUserChallenges {
                for mate in challenge.mateArray {
                    if mate == authManager.firebaseAuth.currentUser?.uid {
                        // newChallenge의 연산 프로퍼티인 localChallenge를 Realm에 업로드 (Realm)
                        $localChallenges.append(challenge.localChallenge)
                    }
                }
            }
        }
    }
    
    // MARK: - 서버에 있는 내가 참여하는 모든 챌린지의 개수를 반환하는 함수
    func countMyChallengesFromServer() -> Int {
        var count = 0
        for challenge in habitManager.currentUserChallenges {
                count += 1
            }
        return count
    }
    
    func countLocalChallenges() -> Int {
        var count = 0
        for _ in localChallenges {
            count += 1
        }
        return count
    }
    
}

struct HabitSegmentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HabitSegmentDetailView(selectedIndex: .constant(0))
    }
}
