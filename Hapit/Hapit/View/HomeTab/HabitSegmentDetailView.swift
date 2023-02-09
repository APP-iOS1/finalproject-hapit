//
//  HabitSegmentDetailView.swift
//  Hapit
//
//  Created by 박진형 on 2023/02/02.
//

import SwiftUI

//MARK: 세그먼트로 개인습관 혹은 그룹습관을 선택해 볼 수 있다.
struct HabitSegmentDetailView: View {
    
    @Binding var selectedIndex: Int
    @State var date = Date()
    // 챌린지와 습관을 관리하는 객체
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var authManager: AuthManager
    
    @State private var isOnAlarm: Bool = false // 알림 설정
    @State private var showsCustomAlert = false // 챌린지 디테일 뷰로 넘길 값
    
    var body: some View {
        switch selectedIndex {
        case 0:
            VStack {
                if habitManager.currentUserChallenges.count < 1{
                    EmptyCellView(currentContentsType: .challenge)
                }
                else {
                    ScrollView {
                        ForEach(habitManager.currentUserChallenges) { challenge in
                            ForEach(challenge.mateArray, id: \.self) { mate in
                                if mate == authManager.firebaseAuth.currentUser?.uid {
                                    NavigationLink {
                                        //HabitDetailView(calendar: Calendar.current)
                                        ZStack{
                                            ScrollView(showsIndicators: false){
                                                CustomDatePickerView(currentDate: $date, localChallenge: challenge.localChallenge, currentChallenge: challenge)
//                                                    .onAppear {
//                                                        // HabitManger의 @Published currentChallenge 갱신
//                                                        habitManager.currentChallenge = challenge
//                                                    }
                                            }
                                            .padding()
                                            .background(Color("BackgroundColor"))
                                          
                                            ModalAnchorView()
                                        } // ZStack
                                        
                                    } label: {
                                        ChallengeCellView(challenge: challenge, currentUserInfos: [])
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
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 5)
                                    
                                } // if
                            }
                        }
                    }
                }
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
