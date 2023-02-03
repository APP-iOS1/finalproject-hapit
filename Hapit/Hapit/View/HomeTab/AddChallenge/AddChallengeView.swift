//
//  AddChallengeView.swift
//  Hapit
//
//  Created by 박민주 on 2023/01/17.
//

import SwiftUI
import FirebaseAuth

//MARK: - 현재 사용자
let currentUser = Auth.auth().currentUser ?? nil

//MARK: - PickerView(세그먼트 Picker)
///challengetype : [String]
///currentIndex: Int
///font: UIFont
struct PickerView: View {
    @Binding var currentIndex: Int // 현재 picker의 위치
    var challengetype: [String] //section (개인/그룹)
    let font = UIFont(name: "IMHyemin-Bold", size: 13) // 폰트 적용
    
    init(_ currentIndex: Binding<Int>, challengetype: [String]) {
        self._currentIndex = currentIndex
        self.challengetype = challengetype
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("AccentColor")) //선택된 picker의 TintColor 설정
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected) //선택된 picker의 글자색 설정
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.systemGray], for: .normal) //선택되지 않은 picker의 글자색 설정
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal) //picker의 폰트 설정
        
    }
    
    var body: some View {
        VStack {
            Picker("", selection: $currentIndex) {
                ForEach(challengetype.indices, id: \.self) { index in
                    Text(challengetype[index])
                        .font(.custom("IMHyemin-Bold", size: 17))
                        .tag(index)
                }
            }//Picker
            .pickerStyle(.segmented)
        }//VStack
        .padding()
    }
}//PickerView

// MARK: - AddChallengeView Struct
struct AddChallengeView: View {
    // MARK: Property Wrappers
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var authManager: AuthManager
    
    @State private var challengeTitle: String = ""
    //FIXME: 알람데이터 저장이 필요
    @State private var isAlarmOn: Bool = false
    @State private var currentDate = Date()
    //PickerView(challengetype,currentIndex)
    @State var challengetype: [String] = ["개인", "그룹"]
    @State var currentIndex: Int = 0
    
    //user의 친구 더미 데이터
    @State var myFriends: [String] = ["김예원", "박민주", "신현준", "릴루","이지", "로로", "가나","dddd", "보리", "가지", "아이스크림"]
    
    // 친구 리스트 임시저장
    @State var tempMate: [ChallengeMate] = []
    
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
                        if isAlarmOn {
                            DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        else{
                            Text("챌린지 달성을 위해\n알림을 활용해보세요!")
                                .font(.custom("IMHyemin-Regular", size: 10))
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
                    .font(.custom("IMHyemin-Regular", size: 10))
                    .foregroundColor(.gray)
                    .padding(.top, 5)
                    
                    Spacer()
                default:
                    
                    HStack{
                        InvitedMateView(tempMate: $tempMate)
                        
                        NavigationLink {
                            // 친구 데이터 전달
                            AddChallengeMateView(myFriendArray: myFriends,tempMate: $tempMate)
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
                        if isAlarmOn {
                            DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        else{
                            Text("챌린지 달성을 위해\n알림을 활용해보세요!")
                                .font(.custom("IMHyemin-Regular", size: 10))
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
                        default:
                            Task {
                                do {
                                    let id = UUID().uuidString
                                    let creator = try await authManager.getNickName(uid: currentUser?.uid ?? "")
                                    
                                     var mateArray: [String] = []
                                
                                     for mate in habitManager.seletedMate {
                                        let mateName = mate.name
                                        mateArray.append(mateName)
                                     }
                                    habitManager.createChallenge(challenge: Challenge(id: id, creator: creator, mateArray: mateArray, challengeTitle: challengeTitle, createdAt: currentDate, count: 1, isChecked: false, uid: currentUser?.uid ?? ""))
                                    
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
