//
//  AddChallengeView.swift
//  Hapit
//
//  Created by 박민주 on 2023/01/17.
//

import SwiftUI
import FirebaseAuth
import RealmSwift

//MARK: - 현재 사용자
// 사용하는 건지 아닌지 모르겠어요 : yw
//let currentUser = Auth.auth().currentUser ?? nil

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
    @ObservedObject private var notiManager = NotificationManager()
    @ObservedResults(HapitPushInfo.self) var hapitPushInfo
    
    @State private var challengeTitle: String = ""

    //FIXME: 알람데이터 저장이 필요
    @State private var isAlarmOn: Bool = false
    @State private var currentDate = Date()
    //PickerView(challengetype,currentIndex)
    @State var challengetype: [String] = ["개인", "그룹"]
    @State var currentIndex: Int = 0

    //user의 친구 더미 데이터 (디비에서 받아오기)
    @State var friends: [ChallengeFriends] = []
    //친구 리스트 임시 저장
    @State var temeFriend: [ChallengeFriends] = []

    @State private var notiTime = Date()
//    @State private var currentDate = Date()
    let maximumCount: Int = 12

    private var isOverCount: Bool {
        challengeTitle.count > maximumCount
    }

    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                PickerView($currentIndex, challengetype: challengetype)
                switch(currentIndex){
                case 0:
                    TextField("챌린지 이름을 입력해주세요.", text: $challengeTitle)
                        .font(.custom("IMHyemin-Bold", size: 20))

                        .padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
                        .background(Color("CellColor"))
                        .cornerRadius(15)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(isOverCount ? .red : .clear)
                            )
                        .padding(.horizontal, 20)
                        .shakeEffect(trigger: isOverCount)
                        .onChange(of: challengeTitle, perform: {
                                  challengeTitle = String($0.prefix(maximumCount+1))
                                })
                    
                    HStack {
                      if isOverCount {
                        Text("최대 \(maximumCount) 글자 까지만 입력해주세요.")
                          .foregroundColor(.red)
                          .font(.custom("IMHyemin-Regular", size: 13))
                      }
                    
                      Spacer()

                      Text("\(challengeTitle.count) / \(maximumCount)")
                        .foregroundColor(isOverCount ? .red : .gray)
                        .font(.custom("IMHyemin-Regular", size: 17))
                    }
                    .padding([.leading, .trailing], 20)
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
                        InvitedMateView(temeFriend: $temeFriend)
                        
                        NavigationLink {
//                             친구 데이터 전달
                            ChallengeFriendsView(friends: friends, temeFriend: $temeFriend)
                                .navigationBarBackButtonHidden(true)
                            
                        } label: {
                            VStack {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Text("함께할 친구 고르기")
                                    .font(.custom("IMHyemin-Bold", size: 17))
                            }
                            
                        }.padding(.horizontal,20)
                    }
                    
                    TextField("챌린지 이름을 입력해주세요.", text: $challengeTitle)
                        .font(.custom("IMHyemin-Bold", size: 20))

                        .padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
                        .background(Color("CellColor"))
                        .cornerRadius(15)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(isOverCount ? .red : .clear)
                            )
                        .padding(.horizontal, 20)
                        .shakeEffect(trigger: isOverCount)
                    
                    HStack {
                      if isOverCount {
                        Text("최대 \(maximumCount) 글자 까지만 입력해주세요.")
                          .foregroundColor(.red)
                          .font(.custom("IMHyemin-Regular", size: 17))
                      }

                      Spacer()

                      Text("\(challengeTitle.count) / \(maximumCount)")
                        .foregroundColor(isOverCount ? .red : .gray)
                    }
                    .font(.custom("IMHyemin-Regular", size: 17))
                    .padding()
                    
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

                                    let creator = try await authManager.getNickName(uid: authManager.firebaseAuth.currentUser?.uid ?? "")
                                    let current = authManager.firebaseAuth                                    
                                    habitManager.createChallenge(challenge: Challenge(id: id, creator: creator, mateArray: [], challengeTitle: challengeTitle, createdAt: currentDate, count: 1, isChecked: false, uid: current.currentUser?.uid ?? ""))
                                    
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
                                    let creator = try await authManager.getNickName(uid: authManager.firebaseAuth.currentUser?.uid ?? "")
                                    let current = authManager.firebaseAuth
                                   
                                    //친구들 uid 저장
                                     var mateArray: [String] = []
                                
                                     for friend in habitManager.seletedFriends {
                                         let uid = friend.uid
                                        mateArray.append(uid)
                                     }                    
                                    
                                    habitManager.createChallenge(challenge: Challenge(id: id, creator: creator, mateArray: mateArray, challengeTitle: challengeTitle, createdAt: currentDate, count: 1, isChecked: false, uid: current.currentUser?.uid ?? ""))
                                    
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
                    .disabled((isOverCount == true) || (challengeTitle.count < 1) )
                } // ToolbarItem
            } // toolbar
        }
        .onAppear {
            Task {
                do {
                    //친구 데이터를 받아오기
                    let current = authManager.firebaseAuth
                    let friends = try await authManager.getFriends(uid: current.currentUser?.uid ?? "")
                    // 받아온 친구 데이터를 ChallengeFriends 데이터로 받아오기
                    for friend in friends{
                       let nickname = try await authManager.getNickName(uid: friend)
                        let proImage = try await authManager.getPorImage(uid: friend)
                        self.friends.append(ChallengeFriends(uid: friend, proImage: proImage, name: nickname))
                        print("\(self.friends)")
                    }
                    
                } catch {
                    throw(error)
                }
            }
        }
        // NavigationView
    } // Body
}

// MARK: - AddChallengeView Previews
struct AddChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        AddChallengeView()
    }
}
