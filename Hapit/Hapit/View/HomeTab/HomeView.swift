//
//  HomeView.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/17.
//

import SwiftUI

//TODO: 체크버튼 분리하기: 현재 한 습관만 달성해도 모든 습관이 다 체크되는 이슈가 있음.


enum HabitTypes: String, CaseIterable{

    case Challenge = "챌린지"
    case Habit = "습관"

}
// MARK: 세그먼트로 개인습관 혹은 그룹습관을 선택해 볼 수 있다.
struct HabitSegmentView: View {
    var habitType: HabitTypes
    
    // MARK: 더미 데이터
    @State var dummyChallenge: Challenge = Challenge(id: UUID().uuidString, creator: "박진주", mateArray: [], challengeTitle: "물 500ml 마시기", createdAt: Date(), count: 1, isChecked: false)
    
    @State var dummyChallenge2: Challenge = Challenge(id: UUID().uuidString, creator: "박진주", mateArray: [], challengeTitle: "금연하기", createdAt: Date(), count: 1, isChecked: false)
    
    @State var dummyChallenge3: Challenge = Challenge(id: UUID().uuidString, creator: "박진주", mateArray: [], challengeTitle: "블로그쓰기", createdAt: Date(), count: 1, isChecked: false)
    
    var body: some View {
        switch habitType {

        case .Challenge:
            ScrollView{

                NavigationLink {
                    HabitDetailView(calendar: Calendar.current)
                } label: {
                    ChallengeCellView(challenge: $dummyChallenge)
                }

                NavigationLink {
                    HabitDetailView(calendar: Calendar.current)
                } label: {
                    ChallengeCellView(challenge: $dummyChallenge2)
                }

            }
   
            
            
        case .Habit:
            
            ScrollView{
                NavigationLink {
                    HabitDetailView(calendar: Calendar.current)
                } label: {

                    HabitCellView(habit: $dummyChallenge3)

                }
            }
        }// switch
    }
}




struct HomeView: View {
    
    @State private var isAddHabitViewShown: Bool = false
    @State private var selectedType: HabitTypes = .Challenge

    var body: some View {
        
        NavigationStack{
            VStack {
                Picker("습관의 종류를 골라주세요", selection: $selectedType){
                    ForEach(HabitTypes.allCases, id: \.self){ habitType in
                        Text(habitType.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                //Text("스와이프 해서 오늘의 챌린지를 달성하세요")
                Spacer()
                HabitSegmentView(habitType: selectedType)
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
