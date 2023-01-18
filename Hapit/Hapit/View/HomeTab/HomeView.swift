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
            List{
                NavigationLink {
                    Text("디테일이 들어가는 곳")
                } label: {
                    ChallengeListCell(didHabit: $didHabit)
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
                    ChallengeListCell(didHabit: $didHabit)
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
            
            List{
                NavigationLink {
                    Text("디테일이 들어가는 곳")
                } label: {
                    HabitListCell(didHabit: $didHabit)
                }
            }
        }// switch
    }
}

struct HabitListCell: View {
    
    @Binding var didHabit: Bool
    
    //MARK: 습관 모델이 만들어지면 수정할 부분
    var title: String = "나의 습관명"
    var dateFromStart: Int = 20
    var dayWithOutStop: Int = 5
    
    var body: some View {
        HStack{
            Button {
                didHabit.toggle()
            } label: {
                Image(systemName: didHabit ? "checkmark.square.fill" : "checkmark.square")
                    .foregroundColor(didHabit ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())

            VStack(alignment: .leading){
                Text(title)
                    .bold()
               
            }//VStack
        }//HStack
        
        
    }
}

struct ChallengeListCell: View {
    
    @Binding var didHabit: Bool
    
    //MARK: 습관 모델이 만들어지면 수정할 부분
    var title: String = "나의 습관명"
    var dateFromStart: Int = 20
    var dayWithOutStop: Int = 5
    
    var body: some View {
        HStack{
            Button {
                didHabit.toggle()
            } label: {
                Image(systemName: didHabit ? "checkmark.square.fill" : "checkmark.square")
                    .foregroundColor(didHabit ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())

            VStack(alignment: .leading){
                Text(title)
                    .bold()
                HStack{
                    Text("D+\(dateFromStart)")
                    Divider()
                  
                    Image(systemName: "flame.fill").font(.body)
                        .foregroundColor(.red)
                    Text("\(dayWithOutStop)일 연속중..!")
                }//HStack
            }//VStack
        }//HStack

        
        
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
            .navigationTitle("나의 해핏")
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
