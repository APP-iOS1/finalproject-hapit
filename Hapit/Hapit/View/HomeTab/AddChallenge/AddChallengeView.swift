//
//  AddChallengeView.swift
//  Hapit
//
//  Created by 박민주 on 2023/01/17.
//

import SwiftUI
import FirebaseAuth
import RealmSwift
import Realm

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
    
    //user의 친구 더미 데이터 (디비에서 받아오기)
    @State var friends: [ChallengeFriends] = []
    //친구 리스트 임시 저장
    @State var temeFriend: [ChallengeFriends] = []
    
    @State private var notiTime = Date()
    let maximumCount: Int = 12
    
    private var isOverCount: Bool {
        challengeTitle.count > maximumCount
    }
    @ObservedRealmObject var localChallenge: LocalChallenge
    
    // 친구목록을 렒에 저장하기 위한 스트링 리스트(렒에 Array가 안됌)
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                HStack{
                    InvitedMateView(temeFriend: $temeFriend)
                }.padding(.horizontal,15)
                
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
                    .padding(.top, 20)
                    .shakeEffect(trigger: isOverCount)
                
                HStack {
                    if isOverCount {
                        Text("최대 \(maximumCount)자까지만 입력해주세요.")
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    Text("\(challengeTitle.count) / \(maximumCount)")
                        .foregroundColor(isOverCount ? .red : .gray)
                }
                .font(.custom("IMHyemin-Regular", size: 13))
                .padding(.horizontal, 25)
                
                HStack(spacing: 5) {
                    Image(systemName: "exclamationmark.circle")
                    Text("66일 동안의 챌린지를 성공하면 종료일이 없는 습관으로 변경돼요.")
                }
                .foregroundColor(.gray)
                .font(.custom("IMHyemin-Regular", size: 11))
                .padding(.top, 30)
                
                Spacer()
                
                Button {
                    Task {
                        do {
                            let id = UUID().uuidString
                            let creator = try await authManager.getNickName(uid: authManager.firebaseAuth.currentUser?.uid ?? "")
                            let current = authManager.firebaseAuth                            
                            
                            var mateArray: [String] = []

                            // 챌린지 작성자 uid 저장
                            // TODO: authManager.firebaseAuth.currentUser?.uid ?? "" 부분이 중복되는 코드. 전체적으로 고칠 필요가 있음
                            mateArray.append(authManager.firebaseAuth.currentUser?.uid ?? "")
                            
                            //친구들 uid 저장
                            for friend in habitManager.seletedFriends {
                                let uid = friend.uid
                                mateArray.append(uid)
                                //렐름에 들어갈 List에도 uid 넣기
                                $localChallenge.mateArray.append(uid)
                            }
                            
                            habitManager.createChallenge(challenge: Challenge(id: id, creator: creator, mateArray: mateArray, challengeTitle: challengeTitle, createdAt: currentDate, count: 0, isChecked: false, uid: current.currentUser?.uid ?? ""))
                            
                            let newChallenge = LocalChallenge(localChallengeId: id, creator: creator, challengeTitle: challengeTitle, createdAt: currentDate, count: 0, isChecked: false, isChallengeAlarmOn: false)
                            
                            dismiss()
                            
                            habitManager.loadChallenge()
                            // 선택된 친구를 초기화시켜줌
                            habitManager.seletedFriends = []
                        } catch {
                            throw(error)
                        }
                    }
                } label: {
                    Text("챌린지 생성하기")
                        .font(.custom("IMHyemin-Bold", size: 16))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.accentColor)
                        }
                        .padding(.horizontal, 20)
                } // label
                .disabled((isOverCount == true) || (challengeTitle.count < 1))
            } // VStack
            .background(Color("BackgroundColor")) // 라이트 모드
            .navigationTitle("새로운 챌린지")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        habitManager.seletedFriends = []
                        dismiss()
                    } label: {
                        Image(systemName: "multiply")
                            .foregroundColor(.gray)
                    } // label
                } // ToolbarItem
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        // 친구 데이터 전달
                        ChallengeFriendsView(friends: friends, temeFriend: $temeFriend)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Image(systemName: "person.badge.plus")
                    }
                } // ToolbarItem
            } // toolbar
            .onAppear {
                Task {
                    do {
                        // 친구 배열 데이터 초기화
                        self.friends = []
                        
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
                } // Task
            } // onAppear
        }// NavigationView
    } // Body
}


// MARK: - AddChallengeView Previews
//struct AddChallengeView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddChallengeView()
//    }
//}
