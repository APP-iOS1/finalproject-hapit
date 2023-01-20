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
    @Environment(\.dismiss) private var dismiss
        
    @EnvironmentObject var habitManager: HabitManager
    
    
    @State private var challengeTitle: String = ""
    @State private var isAlarmOn: Bool = false
    @State private var currentDate = Date()
    
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                TextField("챌린지 이름을 입력해주세요.", text: $challengeTitle)
                    .font(.title3)
                    .bold()
                    .padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
                    .background(Color("CellColor"))
                    .cornerRadius(15)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
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
                        .padding(.leading, 5)
                    
                }
                .frame(height: 40)
                .padding()
                .background(Color("CellColor"))
                .cornerRadius(15)
                .padding(.horizontal, 20)
                
                HStack(spacing: 5) {
                    Image(systemName: "exclamationmark.circle")
                    Text("66일 동안의 챌린지를 성공하면 종료일이 없는 습관으로 변경돼요.")
                }
                .foregroundColor(.gray)
                .font(.caption2)
                .padding(.top, 5)
                
                
                Spacer()
            } // VStack
            .padding(.top, 30)
            .background(Color("BackgroundColor")) // 라이트 모드
            .navigationTitle("새로운 챌린지")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "multiply")
                            .foregroundColor(.gray)
                    } // label
                } // ToolbarItem

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                        Task{
                            await habitManager.createChallenge(challengeTitle: challengeTitle)
                            
                        }

                        dismiss()
                        
                    } label: {
                        Image(systemName: "checkmark")
                    } // label
                } // ToolbarItem
            } // toolbar
        } // NavigationStack
    } // Body
}


//// MARK: - AddHabitView Previews
//struct AddHabitView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddHabitView()
//    }
//}
//
//

