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
    @State private var showsCustomAlert = false // 챌 린지 디테일 뷰로 넘길 값
    
    @ObservedResults(LocalChallenge.self) var localChallenges // 새로운 로컬챌린지 객체를 담아주기 위해 선언 - 데이터베이스
    @ObservedResults(LocalChallenge.self) var localHabits
    
    var body: some View {
        switch selectedIndex {
        //case 0 은 챌린지
        case 0:
            VStack {
                if localChallenges.isEmpty {
                    EmptyCellView(currentContentsType: .habit)
                } else {
                    ScrollView {
                        //TODO: 이거 우리 이제 필 없음
                        //TODO: 개인챌린지랑 함께하기챌린지랑 db구조상의 차이점이 없어짐
                        //TODO: 초대 시 수락받으면 로컬에 저장을 해주는 중
                        ForEach(localChallenges) { localChallenge in
                                NavigationLink {
                                    ZStack {
                                        ScrollView(showsIndicators: false) {
                                            //TODO: 로컬에 있는 챌린지 불러오는 중
                                            ChallengeDetailView(currentDate: $date, localChallenge: localChallenge)
                                        }
                                        .padding()
                                        .background(Color("BackgroundColor"))
                                        ModalAnchorView()
                                    } // ZStack
                                } label: {
                                    ChallengeCellView(currentUserInfos: [], localChallenge: localChallenge)
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 5)
                        } // ForEach
                    } // ScrollView
                    .onAppear {
                        restoreChallenges()
                    } // onAppear
                    .refreshable { // MARK: - Only iOS 16
                        restoreChallenges()
                    } // refreshable
                } // else
            } // VStack
            //시작할때 0번 인덱스에 해당하는 챌린지뷰를 먼저 그리기 때문에 챌린지 뷰 onAppear시에 챌린지와 습관을 분리해서 각각 배열에 저장해줌
        //case 1은 습관
        case 1:
            //TODO: 서버에 있는 배열 기준으로 체크중 -> 수정요망
            VStack {
                if localHabits.isEmpty {
                    EmptyCellView(currentContentsType: .habit)
                }
                else {
                    //TODO: 로컬 데이터 기준으로 수정 요망
                    ScrollView {
                        ForEach(localChallenges) { localChallenge in
                            
                            NavigationLink {
//                                if localChallenge.isHabit == true {
//                                    HabitDetailView(calendar: Calendar.current)
//                                }
                            } label: {
                                    HabitCellView(habit: localChallenge)
                            }
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
