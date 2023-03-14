//
//  AccountView.swift
//  Hapit
//
//  Created by 박민주 on 2023/03/14.
//

import SwiftUI
import FirebaseAuth

struct AccountView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var signInManager: SignInManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var userInfoManager: UserInfoManager
    @EnvironmentObject var messageManager: MessageManager
    @EnvironmentObject var normalSignInManager: NormalSignInManager
    @EnvironmentObject var googleSignInManager: GoogleSignInManager
    @EnvironmentObject var kakaoSignInManager: KakaoSignInManager
    @EnvironmentObject var appleSignInManager: AppleSignInManager
    
    @Binding var index: Int
    @Binding var flag: Int
    @State private var isLogoutAlert = false
    @State private var isWithdrawalAlert = false
    
    var body: some View {
        //  현재 유저에 대한 정보를 받아옴
        let current = authManager.firebaseAuth
        let currentUser = current.currentUser?.uid
        
        VStack {
            List {
                Button {
                    isLogoutAlert = true
                } label: {
                    Text("로그아웃")
                }.listRowSeparator(.hidden)

                Button {
                    isWithdrawalAlert.toggle()
                } label: {
                    Text("회원탈퇴")
                        .foregroundColor(.red)
                }.listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .font(.custom("IMHyemin-Regular", size: 16))
        }
        .customAlert(isPresented: $isLogoutAlert,
                     title: "",
                     message: "로그아웃하시겠습니까?",
                     primaryButtonTitle: "로그아웃",
                     primaryAction: { Task {
                flag = 1
                signOut()
                index = 0 } },
                     withCancelButton: true)
        
        .customAlert(isPresented: $isWithdrawalAlert,
                     title: "정말로 해핏을 떠나실건가요?",
                     message: "탈퇴하면 데이터를 복구할 수 없습니다.",
                     primaryButtonTitle: "탈퇴",
                     primaryAction: { Task {
            //MARK: - 1. 일기(POST)(실패-보류)
//            Task {
//                    for post in habitManager.posts{
//                      //  if post.creatorID.contains(currentUser ?? ""){
//                        habitManager.deletePost(postID: post.id)
//                       // }
//                    }
//
//            }
            //MARK: - 2.챌린지(Challenge)
            ///2-1. 내가 참여중인 챌린지(함께 하는 챌린지)
            ///mateArray에서 나의 uid와 같은 데이터를 찾아서 지움
            ///2-2. 내가 만든 챌린지(함께하는 챌린지)
            ///creator, Challenge.uid 가 '나' 인 챌린지들 중 "mateArray.count >1" creator,Challenge.uid를 변경 후 mateArray에서 나를 삭제
            ///2-3. 내가 만든 챌린지(개인 챌린지)
            ///creator, Challenge.uid 가 '나' 인 챌린지들 중 "mateArray.count <= 1"인 경우, 바로 삭제
            
            Task{
                for challenge in habitManager.challenges {
                    if challenge.mateArray.contains(currentUser ?? "") {
                        //2-1~2-2. 1보다 큰 경우(함께 챌린지인 경우)
                        if challenge.mateArray.count > 1{
                            //2-1. 내가 참여중인 모든 함께 챌린지에서 친구 리스트에 내 이름을 지움
                            habitManager.removeChallegeMate(challenge: challenge,removeValue: currentUser ?? "")
                            // 2-2. 내가 만든 함께 챌린지라면 creator와 uid도 업데이트 함
                            if challenge.uid.contains(currentUser ?? ""){
                                // 참여중인 챌린지의 마지막 사람에게 할당함.
                                try await habitManager.updateChallegecreator(challenge: challenge, creator: authManager.getNickName(uid: challenge.mateArray.last ?? ""))
                                habitManager.updateChallegeUid(challenge: challenge, uid: challenge.mateArray.last ?? "")
                            }
                        }
                        //2-3. 1보다 작은 경우(개인 챌린지인 경우)(성공)
                        else{
                            habitManager.removeChallenge(challenge: challenge)// 챌린지 삭제하기
                        }
                    }
                }
            }
            //MARK: - 4. 내 친구에 저장된 나를 삭제
            Task{
                try await userInfoManager.getFriendArray()
                
                for friend in userInfoManager.friendArray {
                    try await userInfoManager.removeFriendData(userID: currentUser ?? "", friendID: friend.id)
                }
            }
            //MARK: - 5. 로그아웃
            Task{
                // 로그인 ?
                flag = 2
                // 화면 위치 변경
                index = 0
                signOut()
//                //로그인 뷰를 띄워주기 위함(logOut 상태를 표현함)
//                authManager.loggedIn = "logOut"
//                // 로그아웃 인 상태를 저장함
//                authManager.save(value: Key.logOut.rawValue, forkey: "state")
            }
            
            //MARK: - 6. 유저에서 나를 삭제
            ///유저의 메세지들을 먼저 삭제하기
            Task{
                for message in messageManager.messageArray{
                    if message.receiverID == currentUser ?? "" {
                        try await messageManager.removeMessage(userID: currentUser ?? "", messageID: message.id)
                    }
                }
                
            }
        }
        //MARK: - 7. 유저에서 나를 삭제
        },withCancelButton: true)
    }
    
    func signOut() {
        let loginMethod = UserDefaults.standard.string(forKey: "loginMethod") ?? ""

        if loginMethod == "general" {
            normalSignInManager.loggedIn = "logOut"
            normalSignInManager.save(value: Key.logOut.rawValue, forkey: "state")
        } else if loginMethod == "google" {
            googleSignInManager.loggedIn = "logOut"
            googleSignInManager.save(value: Key.logOut.rawValue, forkey: "state")
        } else if loginMethod == "kakao" {
            kakaoSignInManager.loggedIn = "logOut"
            kakaoSignInManager.save(value: Key.logOut.rawValue, forkey: "state")
        } else if loginMethod == "apple" {
            appleSignInManager.loggedIn = "logOut"
            appleSignInManager.save(value: Key.logOut.rawValue, forkey: "state")
        }
    }
    
    func getOut() {
        let loginMethod = UserDefaults.standard.string(forKey: "loginMethod") ?? ""

        if loginMethod == "general" {
            normalSignInManager.loggedIn = "logOut"
            normalSignInManager.save(value: Key.logOut.rawValue, forkey: "state")
        } else if loginMethod == "google" {
            googleSignInManager.loggedIn = "logOut"
            googleSignInManager.save(value: Key.logOut.rawValue, forkey: "state")
        } else if loginMethod == "kakao" {
            kakaoSignInManager.loggedIn = "logOut"
            kakaoSignInManager.save(value: Key.logOut.rawValue, forkey: "state")
        } else if loginMethod == "apple" {
            appleSignInManager.loggedIn = "logOut"
            appleSignInManager.save(value: Key.logOut.rawValue, forkey: "state")
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(index: .constant(0), flag: .constant(0))
    }
}
