//
//  AddHabitView.swift
//  Hapit
//
//  Created by 박민주 on 2023/01/17.
//

import SwiftUI
import FirebaseAuth

//MARK: - ChallengeType : 개인/그룹
enum ChallengeType: String, CaseIterable{
    case personal = "개인"
    case group = "그룹"
}

let firebaseAuth = Auth.auth()
let currentUser = Auth.auth().currentUser ?? nil

// MARK: - AddHabitView Struct
struct AddHabitView: View {
    // MARK: - Property Wrappers
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var habitManager: HabitManager
    
    @State private var createdAt: Date = Date()
    var createdDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: createdAt)
    }
    @State private var challengeTitle: String = ""
    @State private var isAlarmOn: Bool = false
    @State private var challengetype: ChallengeType = .personal
    
    @State private var currentDate = Date()
    
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Spacer()
            
            VStack(spacing: 15) {
                
                Picker ("개인 그룹 중 선택해주세요",selection: $challengetype){
                    ForEach(ChallengeType.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }
                .accentColor(Color("DarkPinkColor"))
                .background(Color("BackgroundColor"))
                .pickerStyle(SegmentedPickerStyle())
                
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
                    else{
                        Text("챌린지 달성을 위해\n알림을 활용해보세요!")
                            .font(.caption2)
                            .fontWeight(.thin)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                        
                        
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
                        let id = UUID().uuidString
                        print(currentUser)
                        
                        habitManager.createChallenge(challenge: Challenge(id: id, creator: "", mateArray: [], challengeTitle: challengeTitle, createdAt: currentDate, count: 1, isChecked: false, uid: currentUser!.uid ?? ""))
                        
                        habitManager.loadChallenge()
                        
                        dismiss()
                        
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



