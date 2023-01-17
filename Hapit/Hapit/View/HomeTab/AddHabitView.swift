//
//  AddHabitView.swift
//  Hapit
//
//  Created by 박민주 on 2023/01/17.
//

import SwiftUI

// MARK: - AddHabitView Struct
struct AddHabitView: View {
    // MARK: - Property Wrappers
    @State private var habitName: String = ""
    @State private var isAlarmOn: Bool = false
    @State private var currentDate = Date()
    @State private var dayOfTheWeekValues: [Bool] = [false, false, false, false, false, false, false] // 요일 배열
    @State private var dayOfTheWeekKeys: [String] = ["월", "화", "수", "목", "금", "토", "일"] // 요일 배열
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                TextField("습관 이름을 입력해주세요.", text: $habitName)
                    .font(.title3)
                    .bold()
                    .padding(20)
                    .background(Color("CellColor"))
                    .cornerRadius(15)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal, 20)
                
                Divider()
                    .padding(.vertical, 10)
                
                HStack {
                    Text("기간")
                    Spacer()
                    DatePicker("", selection: $currentDate, displayedComponents: .date)
                        .labelsHidden()
                    Text("-")
                    DatePicker("", selection: $currentDate, displayedComponents: .date)
                        .labelsHidden()
                    
                }
                .padding()
                .background(Color("CellColor"))
                .cornerRadius(15)
                .padding(.horizontal, 20)
                
                
                HStack {
                    Text("요일")
                    Spacer()
                    ForEach(0..<7, id: \.self) { index in
                        Button {
                            dayOfTheWeekValues[index].toggle()
                        } label: {
                            Circle()
                                .frame(width: 30)
                                .foregroundColor(dayOfTheWeekValues[index] ? .accentColor : Color("BackgroundColor"))
                                .overlay {
                                    Text("\(dayOfTheWeekKeys[index])")
                                        .font(.footnote)
                                        .foregroundColor(dayOfTheWeekValues[index] ? .white : .accentColor)
                                }
                        }

                    }
                    
                }
                .padding()
                .background(Color("CellColor"))
                .cornerRadius(15)
                .padding(.horizontal, 20)
                
                HStack {
                    Text("알림")
                    Spacer()
                    if isAlarmOn {
                        DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    
                    Toggle("", isOn: $isAlarmOn)
                        .labelsHidden()
                    
                }
                .frame(height: 40)
                .padding()
                .background(Color("CellColor"))
                .cornerRadius(15)
                .padding(.horizontal, 20)
                
                
                
                Spacer()
            } // VStack
            .padding(.top, 30)
            .background(Color("BackgroundColor")) // 라이트 모드
            .navigationTitle("새로운 습관")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {

                    } label: {
                        Image(systemName: "multiply")
                            .foregroundColor(.gray)
                    } // label
                } // ToolbarItem

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {

                    } label: {
                        Image(systemName: "checkmark")
                    } // label
                } // ToolbarItem
            } // toolbar
        } // NavigationStack
    } // Body
}


// MARK: - AddHabitView Previews
struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView()
    }
}
