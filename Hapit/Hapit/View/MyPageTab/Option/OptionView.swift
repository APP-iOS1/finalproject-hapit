//
//  OptionView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/31.
//

import SwiftUI
import FirebaseAuth

struct OptionView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var userInfoManager: UserInfoManager
    @EnvironmentObject var messageManager: MessageManager
    @EnvironmentObject var lnManager: LocalNotificationManager
    @Environment(\.scenePhase) var scenePhase
    
    @Binding var index: Int
    @Binding var flag: Int
    @State private var isLogoutAlert = false
    @State private var isSettingsAlert = false
    @State private var isWithdrawalAlert = false
    @AppStorage("isUserAlarmOn") var isUserAlarmOn: Bool = false

    var body: some View {
        //  현재 유저에 대한 정보를 받아옴
        let current = authManager.firebaseAuth
        let currentUser = current.currentUser?.uid
        
        VStack {
            List {
                NavigationLink {
                    
                } label: {
                    Text("해핏에 대해서")
                        .modifier(ListTextModifier())
                }.listRowSeparator(.hidden)
                
                NavigationLink {
                    
                } label: {
                    Text("오픈소스 라이선스")
                        .modifier(ListTextModifier())
                }.listRowSeparator(.hidden)
                
                NavigationLink {
                    
                } label: {
                    Text("이용약관")
                        .modifier(ListTextModifier())
                }.listRowSeparator(.hidden)
                
                NavigationLink {
                    
                } label: {
                    Text("개인정보 처리방침")
                        .modifier(ListTextModifier())
                }.listRowSeparator(.hidden)
                
                NavigationLink {
                    
                } label: {
                    Text("만든 사람들")
                        .modifier(ListTextModifier())
                }.listRowSeparator(.hidden)
                
                Toggle("알림", isOn: $lnManager.isAlarmOn)
                    .onChange(of: lnManager.isAlarmOn) { val in
                        if val == false {
                            lnManager.clearRequests()
                        } else {
                            if lnManager.isGranted == false {
                                isSettingsAlert.toggle()
                                if isSettingsAlert {
                                    lnManager.isAlarmOn = false
                                }
                            }
                        }
                        isUserAlarmOn = val
                    }
                    .listRowSeparator(.hidden)
                    .font(.custom("IMHyemin-Bold", size: 16))
                
            }
            .listStyle(PlainListStyle())
            
            // MARK: 로그아웃
            Button {
                isLogoutAlert = true
            } label: {
                Text("로그아웃")
                    .font(.custom("IMHyemin-Regular", size: 16))
                    .foregroundColor(Color("GrayFontColor"))
                    .frame(width: 350, height: 50)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color("GrayFontColor")))
                    .padding()
            }
            
            // MARK: 회원탈퇴
            // TODO: "회원탈퇴하겠습니다." 라고 유저에게 텍스트를 입력받아 탈퇴를 더 어렵게 하기
            HStack {
                Spacer()
                Button {
                    isWithdrawalAlert.toggle()
                } label: {
                    Text("회원탈퇴")
                        .font(.custom("IMHyemin-Regular", size: 16))
                        .foregroundColor(Color("GrayFontColor"))
                }
            }
            .frame(width: 350)
            .padding(.bottom)
        } // VStack
        .onAppear {
            Task{
                await lnManager.getCurrentSettings()
                if !lnManager.isGranted {
                    lnManager.isAlarmOn = lnManager.isGranted
                    isUserAlarmOn = lnManager.isGranted
                }
                lnManager.isAlarmOn = isUserAlarmOn
                
            }
        }
        .onChange(of: scenePhase) { newValue in
            // 앱이 작동중일 때
            // 노티 authorize 해놓고 나가서 거부하고 다시 돌아오면 enable이 되어있음 => 값이 바뀌어서 씬을 업데이트 해준거임
            // 설정 앱에서 끄면 해당 변화가 바로 OptionView에 반영되어야 하지만,
            // 설정 앱에선 켜져 있고, OptionView에서 끈 후에, 다시 OptionView가 펼쳐지면 설정 앱 알림 정보가 반영되면 안 됨.
            if newValue == .active {
                Task {
                    await lnManager.getCurrentSettings()
                    lnManager.isAlarmOn = lnManager.isGranted
                    isUserAlarmOn = lnManager.isGranted
                }
            }
        }
        .customAlert(isPresented: $isSettingsAlert,
                     title: "알림허용이 되어있지 않습니다",
                     message: "설정으로 이동하여 알림 허용을 하시겠습니까?",
                     primaryButtonTitle: "허용",
                     primaryAction: {lnManager.openSettings()},
                     withCancelButton: true)
        
        .customAlert(isPresented: $isLogoutAlert,
                     title: "",
                     message: "로그아웃하시겠습니까?",
                     primaryButtonTitle: "로그아웃",
                     primaryAction: { Task {
                flag = 1
                authManager.loggedIn = "logOut"
                authManager.save(value: Key.logOut.rawValue, forkey: "state")
                index = 0 } },
                     withCancelButton: true)
        
        .customAlert(isPresented: $isWithdrawalAlert,
                     title: "정말로 해핏을 떠나실건가요?",
                     message: "탈퇴하면 데이터를 복구할 수 없습니다.",
                     primaryButtonTitle: "탈퇴",
                     primaryAction: { Task {
            //MARK: - 1. 일기(POST)(실패-보류)
            Task {
                    for post in habitManager.posts{
                      //  if post.creatorID.contains(currentUser ?? ""){
                        habitManager.deletePost(postID: post.id)
                       // }
                    }

            }
            //MARK: - 2.챌린지(Challenge)
            ///2-1. 내가 만든 챌린지(함께하는 챌린지)
            ///creator, Challenge.uid 가 '나' 인 챌린지들 중 "mateArray.count <= 1"인 경우, 바로 삭제
            ///2-2. 내가 만든 챌린지(개인 챌린지)
            ///creator, Challenge.uid 가 '나' 인 챌린지들 중 "mateArray.count >1" creator,Challenge.uid를 변경 후 mateArray에서 나를 삭제
            ///2-3. 내가 참여중인 챌린지(함께 하는 챌린지)
            ///mateArray에서 나의 uid와 같은 데이터를 찾아서 지움
            Task{
                for challenge in habitManager.challenges {
                    if challenge.mateArray.contains(currentUser ?? "") {
                        //2-1. 1보다 큰 경우(함께 챌린지인 경우)(성공)
                        if challenge.mateArray.count > 1{
                            
                            try await habitManager.updateChallegecreator(challenge: challenge, creator: authManager.getNickName(uid: challenge.mateArray[1]))
                            habitManager.updateChallegeUid(challenge: challenge, uid: challenge.mateArray[1])
                            habitManager.removeChallegeMate(challenge: challenge,removeValue: currentUser!) //친구 목록에서 나를 지움
                            
                        }
                        //2-2. 1보다 작은 경우(개인 챌린지인 경우)(성공)
                        else{
                            habitManager.removeChallenge(challenge: challenge)// 챌린지 삭제하기
                        }
                    }
                }
                //2-3. 내가 참여중인 챌린지(함께 하는 챌린지)(실패)
                for challenge in habitManager.currentUserChallenges {
                    habitManager.removeChallegeMate(challenge: challenge, removeValue: currentUser ?? "") //친구 목록에서 나를 지움
                }
            }
            //MARK: - 4. 내 친구에 저장된 나를 삭제(성공)
            Task{
                try await userInfoManager.getFriendArray()
                
                for friend in userInfoManager.friendArray {
                    try await userInfoManager.removeFriendData(userID: currentUser ?? "", friendID: friend.id)
                }
            }
            //MARK: - 5. 로그아웃(성공)
            Task{
                // 로그인 ?
                flag = 2
                // 화면 위치 변경
                index = 0
                //로그인 뷰를 띄워주기 위함(logOut 상태를 표현함)
                authManager.loggedIn = "logOut"
                // 로그아웃 인 상태를 저장함
                authManager.save(value: Key.logOut.rawValue, forkey: "state")
            }
            /// 6-1. 유저의 메세지들을 먼저 삭제하기
            /// 6-2. 유저의 정보 삭제(회원 탈퇴 완료)
            // 6-1. 메세지 삭제하기(성공)
            Task{
                for message in messageManager.messageArray{
                    if message.receiverID == currentUser ?? "" {
                        try await messageManager.removeMessage(userID: currentUser ?? "", messageID: message.id)
                    }
                }
                
            }
            //MARK: - 6. 유저에서 나를 삭제(--)
            Task{
                // 6-2. user 삭제()
            //    try await authManager.deleteUser(uid: currentUser ?? "")
            }
        }},withCancelButton: true)
    }
}

struct ListTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("IMHyemin-Bold", size: 16))
    }
}

struct OptionView_Previews: PreviewProvider {
    static var previews: some View {
        OptionView(index: .constant(0), flag: .constant(1))
    }
}
