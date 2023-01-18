//
//  HomeView.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/17.
//

import SwiftUI

enum HabitTypes: String, CaseIterable{
    case Challenge = "챌린지"
    case Habit = "습관"
}
// MARK: 세그먼트로 개인습관 혹은 그룹습관을 선택해 볼 수 있다.
struct HabitSegmentView: View {
    var habitType: HabitTypes
    
    @State var didHabit: Bool = false
    
    var body: some View {
        switch habitType {
        case .Challenge:
            ScrollView{
                NavigationLink {
                    Text("디테일이 들어가는 곳")
                } label: {
                    ChallengeCellView(didHabit: $didHabit)
                }
                
                .swipeActions {
                    Button("완료하기") {
                        didHabit.toggle()
                    }
                    .tint(.green)
                }
                NavigationLink {
                    Text("디테일이 들어가는 곳")
                } label: {
                    ChallengeCellView(didHabit: $didHabit)
                }
                .swipeActions {
                    Button("완료하기") {
                        didHabit.toggle()
                    }
                    .tint(.green)
                }
            }
            .listStyle(.insetGrouped)
            
            
        case .Habit:
            
            ScrollView{
                NavigationLink {
                    Text("디테일이 들어가는 곳")
                } label: {
                    HabitCellView(didHabit: $didHabit)
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

            .navigationTitle(getToday())
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
