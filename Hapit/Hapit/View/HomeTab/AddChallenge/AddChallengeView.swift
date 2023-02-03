//
//  AddChallengeView.swift
//  Hapit
//
//  Created by 박민주 on 2023/01/17.
//

import SwiftUI
import FirebaseAuth
import RealmSwift

//MARK: - ChallengeType(개인/그룹)
enum ChallengeType: String, CaseIterable{
    case personal = "개인"
    case group = "그룹"
}

let currentUser = Auth.auth().currentUser ?? nil

struct PickerView: View {
    @Binding var currentIndex: Int
        var challengetype: [String] //section (개인/그룹)
    let font = UIFont(name: "IMHyemin-Bold", size: 13)
    
        init(_ currentIndex: Binding<Int>, challengetype: [String]) {
            self._currentIndex = currentIndex
            self.challengetype = challengetype
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("AccentColor"))
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.systemGray], for: .normal)
            
            UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal)
            
        }
        
        var body: some View {
            VStack {
                Picker("", selection: $currentIndex) {
                    ForEach(challengetype.indices, id: \.self) { index in
                        Text(challengetype[index])
                            .font(.custom("IMHyemin-Bold", size: 17))
                            .tag(index)
                            
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
        }
}

// MARK: - AddChallengeView Struct
struct AddChallengeView: View {
    // MARK: - Property Wrappers
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var authManager: AuthManager
    @ObservedObject private var notiManager = NotificationManager()
    @ObservedResults(HapitPushInfo.self) var hapitPushInfo
    
    @State private var challengeTitle: String = ""
    @State var challengetype: [String] = ["개인", "그룹"]
    @State var currentIndex: Int = 0
    @State private var notiTime = Date()
    @State private var currentDate = Date()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                
                PickerView($currentIndex, challengetype: challengetype)
                switch(currentIndex){
                case 0:
                    TextField("챌린지 이름을 입력해주세요.", text: $challengeTitle)
                        .font(.custom("IMHyemin-Bold", size: 17))
                        
                        .padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
                        .background(Color("CellColor"))
                        .cornerRadius(15)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        Text("알림")
                            .font(.custom("IMHyemin-Regular", size: 17))
                        Spacer()
                        if notiManager.isAlarmOn {
                            DatePicker("", selection: $notiManager.notiTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        else{
                            Text("챌린지 달성을 위해\n알림을 활용해보세요!")
                                .font(.custom("IMHyemin-Regular", size: 10))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.trailing)
                            
                        }
                        Toggle("", isOn: $notiManager.isAlarmOn)
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
                    .font(.custom("IMHyemin-Regular", size: 10))
                    .foregroundColor(.gray)
                    .padding(.top, 5)
                    
                    Spacer()
                default:
                    HStack{
                        NavigationLink {
                            AddChallengeMateView()
                                .navigationBarBackButtonHidden(true)

                        } label: {
                            VStack {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Text("친구초대")
                                    .font(.custom("IMHyemin-Bold", size: 17))
                            }

                        }.padding(.horizontal,20)
                    }

                    TextField("챌린지 이름을 입력해주세요.", text: $challengeTitle)
                        .font(.custom("IMHyemin-Bold", size: 17))
                        
                        .padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
                        .background(Color("CellColor"))
                        .cornerRadius(15)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        Text("알림")
                            .font(.custom("IMHyemin-Regular", size: 17))

                        Spacer()
                        if notiManager.isAlarmOn {
                            DatePicker("", selection: $notiManager.notiTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        else{
                            Text("챌린지 달성을 위해\n알림을 활용해보세요!")
                                .font(.custom("IMHyemin-Regular", size: 10))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.trailing)
                            
                        }
                        Toggle("", isOn: $notiManager.isAlarmOn)
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
                    .font(.custom("IMHyemin-Regular", size: 10))
                    .padding(.top, 5)
                    
                    Spacer()
                }
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
                        
                        switch(currentIndex){
                        case 0:
                            Task {
                                //HapitPushInfo에도 동일하게 담길 id 이기 때문에 do 밖으로 빼줌
                                let id = UUID().uuidString
                                do {
                                    let creator = try await authManager.getNickName(uid: currentUser?.uid ?? "")
                                    
                                    habitManager.createChallenge(challenge: Challenge(id: id, creator: creator, mateArray: [], challengeTitle: challengeTitle, createdAt: currentDate, count: 1, isChecked: false, uid: currentUser?.uid ?? ""))
                                    
                                    dismiss()
                                    
                                    habitManager.loadChallenge()
                                } catch {
                                    throw(error)
                                }
                                if notiManager.isAlarmOn {
                                    let newPushInfo = HapitPushInfo(pushID: id, pushTime: notiManager.notiTime, isChallengeAlarmOn: true)
                                    $hapitPushInfo.append(newPushInfo)
                                }
                            }
                            
                        default:
                            Task {
                                do {
                                    let id = UUID().uuidString
                                    let creator = try await authManager.getNickName(uid: currentUser?.uid ?? "")
                                    
                                    habitManager.createChallenge(challenge: Challenge(id: id, creator: creator, mateArray: [], challengeTitle: challengeTitle, createdAt: currentDate, count: 1, isChecked: false, uid: currentUser?.uid ?? ""))
                                    
                                    dismiss()
                                    
                                    habitManager.loadChallenge()
                                } catch {
                                    throw(error)
                                }
                            }
                        }
                        
                    } label: {
                        Image(systemName: "checkmark")
                    } // label
                } // ToolbarItem
            } // toolbar
        } // NavigationStack
    } // Body
}

// MARK: - AddChallengeView Previews
struct AddChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        AddChallengeView()
    }
}
