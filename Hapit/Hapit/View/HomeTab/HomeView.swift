//
//  HomeView.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/17.
//

import SwiftUI
import SegmentedPicker
//TODO: 체크버튼 분리하기: 현재 한 습관만 달성해도 모든 습관이 다 체크되는 이슈가 있음.

// MARK: 세그먼트로 개인습관 혹은 그룹습관을 선택해 볼 수 있다.
struct HabitSegmentView: View {
    
    @Binding var selectedIndex: Int
    
    // 챌린지와 습관을 관리하는 객체
    @EnvironmentObject var habitManager: HabitManager
    
    var body: some View {
        switch selectedIndex {
            
        case 0:
                ScrollView{
                    if habitManager.challenges.count < 1{
                        
                        EmptyCellView()
                        
                    }
                    else{
                    ForEach(habitManager.challenges) { challenge in
                        
                        NavigationLink {
                            //HabitDetailView(calendar: Calendar.current)
                        } label: {
                            
                            ChallengeCellView(challenge: challenge)
                        }
                        
                    }
                }
                
            }
                .onAppear{
                    habitManager.loadChallenge()
                }
        case 1:

                if habitManager.habits.count < 1{
                    EmptyCellView()
                }
                else{
                    ScrollView{
                        ForEach(habitManager.habits) { habit in
                            
                            NavigationLink {
                                // MARK: 버전 분기
                                
                                //HabitDetailView(calendar: Calendar.current)
                            } label: {
                                HabitCellView(habit: habit)
                            }
                            
                        }
                    }
//                    .onAppear{
//                        Task{
//                            await habitManager.fetchChallenge()
//                        }
//                        print(habitManager.habits)
//
//                    }
                    
            }
        default : Text("something wrong")
        }// switch
        
    }
}

struct HomeView: View {
    
    @State private var isAddHabitViewShown: Bool = false
    @State private var habitTypeList: [String] = ["챌린지", "습관"]
    @State var selectedIndex: Int = 0
    
    @EnvironmentObject var habitManager: HabitManager
    
    var body: some View {
        
        NavigationView{
            VStack {
                SegmentedPicker(
                    habitTypeList,
                    selectedIndex: Binding(
                        get: { selectedIndex },
                        set: { selectedIndex = $0 ?? 0 }),
                    selectionAlignment: .bottom,
                    content: { item, isSelected in
                        Text(item)
                            .foregroundColor(isSelected ? Color.accentColor : Color.gray )
                        //.padding(.horizontal, 70)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .font(.custom("IMHyemin-Bold", size: 17))
                        
                    },
                    selection: {
                        VStack(spacing: 0) {
                            Spacer()
                            Color.accentColor.frame(height: 2)
                                .clipShape(Capsule())
                                .frame(maxWidth: .infinity)
                        }
                        
                    })
                .onAppear {
                    selectedIndex = 0
                }
                .animation(.easeInOut(duration: 0.3))
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
                
                // 세그먼트 뷰
                Spacer()
                HabitSegmentView(selectedIndex: $selectedIndex)
                Spacer()
                
                
            }//VStack
            .background(Color("BackgroundColor").ignoresSafeArea())
            
            .navigationBarTitle(getToday())
            //MARK: 툴바 버튼. 습관 작성하기 뷰로 넘어간다.
            .toolbar {
                
                //                NavigationLink {
                //                    // AddHabitView가 올 자리
                //                    Text("hello")
                //                } label: {
                //                    Label("Add Habit", systemImage: "plus.app")
                //                }
                
                Button {
                    isAddHabitViewShown.toggle()
                } label: {
                    Label("Add Habit", systemImage: "plus.app")
                }
                
            }//toolbar
        }//NavigationStack
        .sheet(isPresented: $isAddHabitViewShown) {
            AddHabitView()
        }
        
        
        
    }//body
    
    
    func getToday() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yy년 MM월 dd일" // "yyyy-MM-dd HH:mm:ss"
        
        let dateCreatedAt = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
        
        return dateFormatter.string(from: dateCreatedAt)
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}



//    // MARK: 더미 데이터
//    @State var dummyChallenge: Challenge = Challenge(id: UUID().uuidString, creator: "박진주", mateArray: [], challengeTitle: "물 500ml 마시기", createdAt: Date(), count: 1, isChecked: false)
//
//    @State var dummyChallenge2: Challenge = Challenge(id: UUID().uuidString, creator: "박진주", mateArray: [], challengeTitle: "금연하기", createdAt: Date(), count: 1, isChecked: false)
//
//    @State var dummyChallenge3: Challenge = Challenge(id: UUID().uuidString, creator: "박진주", mateArray: [], challengeTitle: "블로그쓰기", createdAt: Date(), count: 1, isChecked: false)
