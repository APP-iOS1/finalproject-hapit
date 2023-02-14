//
//  AddChallengeView.swift
//  Hapit
//
//  Created by 박민주 on 2023/01/17.
//

import SwiftUI
import FirebaseAuth
import RealmSwift

// MARK: - AddChallengeView Struct
struct AddChallengeView: View {
    // MARK: Property Wrappers
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var messageManager: MessageManager
    
    @State private var challengeTitle: String = ""
    
    //FIXME: 알람데이터 저장이 필요
    @State private var isAlarmOn: Bool = false
    @State private var currentDate = Date()
    
    //user의 친구 더미 데이터 (디비에서 받아오기)
    @State var friends: [ChallengeFriends] = []
    //친구 리스트 임시 저장
    @State var temeFriend: [ChallengeFriends] = []
    
    @State private var notiTime = Date()
    
    @ObservedResults(LocalChallenge.self) var localChallenges // 새로운 로컬챌린지 객체를 담아주기 위해 선언 - 데이터베이스
    
    // MARK: - Properties
    let maximumCount: Int = 12
    
    private var isOverCount: Bool {
        challengeTitle.count > maximumCount
    }

    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                HStack{
                    InvitedMateView(temeFriend: $temeFriend)
                }
                .padding(.horizontal, 20)
                .padding(.top, 5)
                
                VStack {
                    TextField("챌린지 이름을 입력해주세요.", text: $challengeTitle)
                        .font(.custom("IMHyemin-Bold", size: 18))
                        .padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 20))
                        .cornerRadius(15)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)

                    HStack {
                        if isOverCount {
                            Text("최대 \(maximumCount)자까지만 입력해주세요.")
                                .foregroundColor(.red)
                        }
                        Spacer()
                        
                        Text("\(challengeTitle.count) / \(maximumCount)")
                            .foregroundColor(isOverCount ? .red : Color("GrayFontColor"))
                    }
                    .font(.custom("IMHyemin-Regular", size: 12))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
                .background(Color("CellColor"))
                .cornerRadius(15)
                .overlay (
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isOverCount ? .red : .clear)
                )
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .shakeEffect(trigger: isOverCount)
                
                VStack {
                    Image("fourbears")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                        .padding(.bottom, 30)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("🧸  66일 동안 챌린지를 도전하세요!")
                        Text("🧸  챌린지를 성공하면 습관으로 변경돼요.")
                        Text("🧸  습관은 종료일이 없어요.")
                        Text("🧸  친구들과 그룹 챌린지도 진행할 수 있어요!")
                        Text("🧸  해핏이 여러분의 습관 형성을 도와줄게요 :)")
                    }
                }
                .font(.custom("IMHyemin-Regular", size: 15))
                .padding(EdgeInsets(top: 40, leading: 20, bottom: 30, trailing: 20))
                .frame(maxWidth: .infinity)
                .background(Color("CellColor"))
                .cornerRadius(15)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
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
//                            for friend in habitManager.seletedFriends {
//                                let uid = friend.uid
//                                mateArray.append(uid)
//
//                            }
                            
                            // 함께챌린지 초대 메시지 보내기
                            // TODO: 파베에서 메시지랑 챌린지 uuid 다른지 확인하기
                            for friend in habitManager.seletedFriends {
                                try await messageManager.sendMessage(Message(id: UUID().uuidString,
                                                                             messageType: "invite",
                                                                             sendTime: Date(),
                                                                             senderID: current.currentUser?.uid ?? "",
                                                                             receiverID: friend.uid,
                                                                             isRead: false,
                                                                             challengeID: id))
                            }
                            
                            // Firestore에 올리기 위한 새로운 챌린지 객체 변수 생성 (따로 빼준 이유: mateArray로부터 mateList를 뽑아내기 위함.)
                            let newChallenge = Challenge(id: id, creator: creator, mateArray: mateArray, challengeTitle: challengeTitle, createdAt: currentDate, count: 0, isChecked: false, uid: current.currentUser?.uid ?? "")
                            
                            // Firestore에 업로드 (Firestore)
                            habitManager.createChallenge(challenge: newChallenge)

                            // newChallenge의 연산 프로퍼티인 localChallenge를 Realm에 업로드 (Realm)
                            $localChallenges.append(newChallenge.localChallenge)

                            dismiss()
                            
                            habitManager.loadChallenge()
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
                            .foregroundColor(Color("GrayFontColor"))
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
