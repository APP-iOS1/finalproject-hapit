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
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var messageManager: MessageManager
    @EnvironmentObject var userInfoManager: UserInfoManager
    
    @State private var receiverFCMToken: String = ""
    @State private var notificationContent: String = ""
    @ObservedObject private var datas = fcmManager
    
    @State private var challengeTitle: String = ""
    @Binding var isAddHabitViewShown: Bool
    
    //FIXME: 알람데이터 저장이 필요
    @State private var isAlarmOn: Bool = false
    @State private var currentDate = Date()  
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
            ScrollView {
                VStack(spacing: 5) {
                    HStack{
                        InvitedMateView()
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
                                
                                // 챌린지 작성자 uid 저장
                                // TODO: authManager.firebaseAuth.currentUser?.uid ?? "" 변수로 저장해놓으면 더 간단하지 않을까잉?
                                var mateArray: [String] = []
//                                mateArray.append(authManager.firebaseAuth.currentUser?.uid ?? "")
                                
                                // 앱 내 메시지 보내는 기능...
                                for friend in habitManager.selectedFriends {
                                    try await messageManager.sendMessage(Message(id: UUID().uuidString,
                                                                                 messageType: "invite",
                                                                                 sendTime: Date(),
                                                                                 senderID: authManager.firebaseAuth.currentUser?.uid ?? "",
                                                                                 receiverID: friend.id,
                                                                                 isRead: false,
                                                                                 challengeID: id))
                                }
                                
                                // Firestore에 올리기 위한 새로운 챌린지 객체 변수 생성 (따로 빼준 이유: mateArray로부터 mateList를 뽑아내기 위함.)
                                let newChallenge = Challenge(id: id, creator: creator, mateArray: mateArray, challengeTitle: challengeTitle, createdAt: currentDate, count: 0, isChecked: false, uid: authManager.firebaseAuth.currentUser?.uid ?? "")
                                
                                // TODO: 이부분은 냄겨야할 수도 있겠넹...
                                // Firestore에 업로드 (Firestore)
                                habitManager.createChallenge(challenge: newChallenge)
                                
                                // newChallenge의 연산 프로퍼티인 localChallenge를 Realm에 업로드 (Realm)
                                $localChallenges.append(newChallenge.localChallenge)
                                
                                // mateArray에 있는 친구들 돌면서 초대 메세지(FCM) 보내기
                                if habitManager.selectedFriends.count > 0 {
                                    for friend in habitManager.selectedFriends{
                                        receiverFCMToken = try await authManager.getFCMToken(uid: friend.id)
                                        
                                        self.datas.sendFirebaseMessageToUser(
                                            datas: self.datas,
                                            // 받을 사람의 FCMToken
                                            to: receiverFCMToken,
                                            title: "그룹챌린지 요청이 왔어요!",
                                            body: "나랑 챌린지할래? :)"
                                        )
                                        
                                        print(friend)
                                    }
                                }
                                //TODO: 이거 필 없을듯..!
                                habitManager.loadChallenge()
                                
                                isAddHabitViewShown = false
                                
                                habitManager.selectedFriends = [] // 비움
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
                            .padding(.bottom, 10)
                        
                    } // label
                    .disabled((isOverCount == true) || (challengeTitle.count < 1))
                } // VStack
                .background(Color("BackgroundColor")) // 라이트 모드
                .navigationTitle("새로운 챌린지")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            habitManager.selectedFriends = []
                            isAddHabitViewShown = false
                        } label: {
                            Image(systemName: "multiply")
                                .foregroundColor(Color("GrayFontColor"))
                        } // label
                    } // ToolbarItem
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            // 친구 데이터 전달
                            ChallengeFriendsView()
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Image(systemName: "person.badge.plus")
                        }
                    } // ToolbarItem
                } // toolbar
            } // ScrollView
            .safeAreaInset(edge: .bottom, spacing: 0) {
                VStack{
                }
            }
            .background(Color("BackgroundColor"))
        }// NavigationView
        .onAppear() {
            Task {
                do {
                    try await userInfoManager.getCurrentUserInfo(currentUserUid: authManager.firebaseAuth.currentUser?.uid ?? "")
                    try await userInfoManager.getFriendArray()
                } catch {
                }
            }
        }
    } // Body
}
