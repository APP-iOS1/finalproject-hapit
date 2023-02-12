//
//  SocialView.swift
//  Hapit
//
//  Created by 김예원 on 2023/01/17.
//

import SwiftUI
import FirebaseAuth

struct SocialView: View {
    @EnvironmentObject var userInfoManager: UserInfoManager
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var messageManager: MessageManager
    @EnvironmentObject var habitManager: HabitManager
    @State private var myFriends: [User] = [User]() // currentUser 포함
    @State private var sortMyFriends: [User] = [User]() // currentUser 포함, 정렬
    @State private var friends: [User] = [User]() // currentUser 제외
    @State private var rankCountArray: [[Int]] = [] // 0: count, 1: rank
    @State private var isAllRead: Bool = true

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Text("친구 수: \(myFriends.count - 1)")
                            .font(.custom("IMHyemin-Bold", size: 15))
                    }.padding(.trailing, 20)
                    
                    // 본인 챌린지 뷰는 안들어가지게 분기처리
                    ScrollView {
                        ForEach(Array(sortMyFriends.enumerated()), id: \.1) { (index, friend) in
                            if friend.id != userInfoManager.currentUserInfo?.id ?? "" {
                                NavigationLink {
                                    FriendChallengeView(friend: friend)
                                        .navigationTitle("친구가 수행중인 챌린지")
                                } label: {
                                    FriendsRow(friend: friend, index: rankCountArray[index][1], count: challengeCount(friend: friend))
                                }.disabled(friend.id == userInfoManager.currentUserInfo?.id)
                            }
                        }
                    }
                }
                .navigationTitle("랭킹")
                .toolbar {
                    HStack {
                        // MARK: 친구관리
                        NavigationLink {
                            EditFriendView(friends: $friends)
                        } label: {
//                            person.2.badge.gearshape
                            Image(systemName: "person.and.person")
                        }
                        
                        // MARK: 메시지함
                        NavigationLink {
                            MessageFullscreenView(isAllRead: $isAllRead)
                        } label: {
                            Image(systemName: isAllRead ? "envelope" : "envelope.badge")
                                .foregroundColor(Color("AccentColor"))
                        }
                    }
                }
            }.background(Color("BackgroundColor"))
        }
        // FIXME: 뷰 들어올 때마다가 아니라 친구 목록의 변화가 있을때마다 실행되게끔 바꾸기
        .task {
            do {
                let current = authManager.firebaseAuth
                try await userInfoManager.getCurrentUserInfo(currentUserUid: current.currentUser?.uid ?? "")
                try await userInfoManager.getFriendArray()
                self.myFriends = userInfoManager.friendArray
                self.friends = userInfoManager.friendArray
                let tmp = userInfoManager.currentUserInfo ?? User(id: "", name: "", email: "", pw: "", proImage: "", badge: [""], friends: [""], fcmToken: "")
                // 셀에 (나) 표시
                self.myFriends.insert(User(id: tmp.id, name: "(나) " + tmp.name, email: tmp.email, pw: tmp.pw, proImage: tmp.proImage, badge: tmp.badge, friends: tmp.friends, fcmToken: tmp.fcmToken), at: 0)
            } catch {
            }
            // 챌린지 진행일수 정렬
            sortMyFriends = myFriends.sorted(by:
                                                {challengeDaysCount(friend: $0) > challengeDaysCount(friend: $1)})
            // 챌린지 개수 정렬
//            sortMyFriends = myFriends.sorted(by:
//                                                {challengeCount(friend: $0) > challengeCount(friend: $1)})
            rankCountArray = ranking(friends: sortMyFriends)
            
            // 안 읽은 메세지 있나 확인
            // FIXME: 한 박자 늦게 뜨는 이슈
            messageManager.fetchMessage(userID: userInfoManager.currentUserInfo?.id ?? "")
            for msg in messageManager.messageArray {
                if !(msg.isRead) {
                    isAllRead = false
                    break
                }
            }
        }
    }
    
    func challengeCount(friend: User) -> Int {
        var count = 0
        for challenge in habitManager.challenges {
            for mate in challenge.mateArray {
                if mate == friend.id {
                    count += 1
                }
            }
        }
        return count
    }
    
    // TODO: 나중에 습관 개수도 추가해야함
    func challengeDaysCount(friend: User) -> Int {
        var daysCount = 0
        for challenge in habitManager.challenges {
            for mate in challenge.mateArray {
                if mate == friend.id {
                    daysCount += challenge.count
                }
            }
        }
        return daysCount
    }
    
    // MARK: 랭킹 알고리즘
    // - parameter : sortMyFriends
    func ranking(friends: [User]) -> [[Int]] {
        var rankArray: [[Int]] = Array(repeating: Array(repeating: 1,count: 2), count: friends.count)
        var cnt: Int = 0
        
        for (index, friend) in friends.enumerated() {
            rankArray[index][0] = challengeDaysCount(friend: friend)
        }
        
        for index in 0..<friends.count {
            if index == 0 {
                rankArray[index][1] = 1
                continue
            }
            // 직전 원소와 같은 랭크숫자 넣어줌
            if rankArray[index - 1][0] == rankArray[index][0] {
                rankArray[index][1] = rankArray[index - 1][1]
                cnt += 1
            } else {
                rankArray[index][1] = rankArray[index - 1][1] + cnt + 1
                cnt = 0
            }
        }
        return rankArray
    }
}

// MARK: FriendsCell
struct FriendsRow: View {
    let friend: User
    var index: Int
    let count: Int
    
    var body: some View {
        HStack {
            Text("\(index)")
                .font(.largeTitle)
                .foregroundColor(Color("AccentColor"))
            
            Image(friend.proImage)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(10)
            
            VStack(alignment: .leading, spacing: 3) {
                Text("\(friend.name)")
                    .foregroundColor(.black)
                    .bold()
                
                Text("현재 챌린지 개수: \(count)")
                    .font(.subheadline)
                    .foregroundColor(Color(.systemGray))
            }
            Spacer()
        }
        .padding()
        .background(.white)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
    }
}
