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
    
    //---
    @Binding var isClicked: Bool // 챌린지 추가 버튼 눌렸는가
    @Binding var challCount: Int?
    
    @ObservedResults(LocalChallenge.self) var localChallenges // 새로운 로컬챌린지 객체를 담아주기 위해 선언 - 데이터베이스
    
    var body: some View {
        switch selectedIndex {
        case 0:
            VStack {
                //TODO: 서버에 있는 챌린지 기준으로 분기처리 중(로컬중심으로 개편 필요)
                if habitManager.currentUserChallenges.count < 1  {
                    if habitManager.loadingState == .success { // 서버에서 챌린지를 모두 성공적으로 가져왔다면
                        EmptyCellView(currentContentsType: .challenge)
                    }
                    else { // 가져오는 중이라면
                        ScrollView {
                            CellSkeletonView()
                        }
                        .padding(.horizontal, 20)
                    }
                } else {
                    ScrollView {
                        //TODO: 이거 우리 이제 필 없음
                        //TODO: 개인챌린지랑 함께하기챌린지랑 db구조상의 차이점이 없어짐
                        //TODO: 초대 시 수락받으면 로컬에 저장을 해주는 중
                        ForEach(habitManager.currentUserChallenges) { challenge in
                            ForEach(challenge.mateArray, id: \.self) { mate in
                                if mate == authManager.firebaseAuth.currentUser?.uid {
                                    NavigationLink {
                                        ZStack{
                                            ScrollView(showsIndicators: false) {
                                                //TODO: 로컬에 있는 챌린지 불러오는 중
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
                    .padding(.bottom, 1)
                    .onAppear {
                        restoreChallenges()
                    } // onAppear
                    .refreshable { // MARK: - Only iOS 16
                        restoreChallenges()
                        habitManager.loadChallenge() // 새로고침
                    } // refreshable
                } // else
            } // VStack
            
        case 1:
            //TODO: 서버에 있는 배열 기준으로 체크중 -> 수정요망
            if habitManager.habits.count < 1{
                EmptyCellView(currentContentsType: .habit)
            }
            else{
                //TODO: 로컬 데이터 기준으로 수정 요망
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
        // DB 흐름을 로컬중심으로 개편 -> 서버에 올리는 시점을 바꿔야 한다. -> 나머지 부분에 대해서는 이 함수로 퉁 칠 수 있도록
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
            print("server \(count)")
            return count
        }
        
        func countLocalChallenges() -> Int {
            var count = 0
            for _ in localChallenges {
                count += 1
            }
            print("local \(count)")
            return count
        }
        
    }
    
//    struct HabitSegmentDetailView_Previews: PreviewProvider {
//        static var previews: some View {
//            HabitSegmentDetailView(selectedIndex: .constant(0), isClicked: .constant(false))
//        }
//    }
