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
                                            ScrollView(showsIndicators: false){
                                                // TODO: 로컬에 저장되어 있는 챌린지들을 뿌려줌 - 함께 챌린지에 참여 중인 챌린지도 보여줘야 함
                                                ForEach(localChallenges) { localChallenge in
                                                    if localChallenge.challengeId == challenge.id {
                                                        CustomDatePickerView(currentDate: $date, localChallenge: localChallenge, currentChallenge: challenge)
                                                    }
                                                } // ForEach - localChallenges
                                            }
                                            .padding()
                                            .background(Color("BackgroundColor"))
                                            
                                            ModalAnchorView()
                                        } // ZStack
                                        
                                    } label: {
                                        // TODO: 로컬에 저장되어 있는 챌린지들을 뿌려줌 - 함께 챌린지에 참여 중인 챌린지도 보여줘야 함
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
                        print("================ HabitSegmentDetailView의 localChallenges =================")
                        for localChallenge in localChallenges {
                            print("\(localChallenge)")
                        } // ForEach - localChallenges
                        
                        print("서버에 있는 사용자의 챌린지 수 : \(habitManager.currentUserChallenges.count)")
                        
                        // MARK: 앱을 삭제했다가 다시 설치했을 때 (=LocalChallenges가 비어있을 때) 복구해준다.
                        if localChallenges.isEmpty && !habitManager.currentUserChallenges.isEmpty {
                            // 로컬엔 비어있는데 서버엔 데이터가 존재한다면, 앱이 삭제됐었던 것이므로 서버에 있는 챌린지들을 로컬에 다시 모두 담아준다.
                            for challenge in habitManager.currentUserChallenges {
                                // newChallenge의 연산 프로퍼티인 localChallenge를 Realm에 업로드 (Realm)
                                $localChallenges.append(challenge.localChallenge)
                            }
                        }
                    }
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
}

struct HabitSegmentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HabitSegmentDetailView(selectedIndex: .constant(0))
    }
}
