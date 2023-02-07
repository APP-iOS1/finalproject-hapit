//
//  PostModalView.swift
//  Hapit
//
//  Created by 박진형 on 2023/02/01.
//

import SwiftUI

struct PostModalView: View {
    @Binding var postsForModalView: [Post]
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var userInfoManager: UserInfoManager
    @EnvironmentObject var authManager: AuthManager

    var userInfos: [User] {
        return habitManager.currentMateInfos
    }
    @State var currentPost: Post = Post(id: "", uid: "", challengeID: "", title: "", content: "", createdAt: Date())
    
    @State var selectedMember: String = ""
    
    var body: some View {
        
        VStack{
            if postsForModalView.isEmpty {
                EmptyCellView(currentContentsType: .post)
            }
            else {
                // MARK: 챌린지를 진행하는 사람이 혼자인 경우
                // 스크롤 뷰를 띄우지 않고 바로 컨텐츠를 보여준다.
                if habitManager.currentMateInfos.count == 1{
                    VStack{
                        Text("제목: \(postsForModalView[0].title)")
                            .font(.custom("IMHyemin-Bold", size: 22))
                        Divider()
                        
                        HStack{
                            Text(postsForModalView[0].content)
                                .font(.custom("IMHyemin-Regular", size: 15))
                        }
                        Spacer()
                    }
                } else{
                    // MARK: 챌린지를 진행하는 사람이 여럿인 경우
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(userInfos, id: \.self){ userinfo in
                                VStack{
                                    Button {
                                        //MARK: 버튼을 누르면 selectedUser의 값이 변경된다.
                                        selectedMember = userinfo.id
                                        for post in postsForModalView {
                                            if post.uid == selectedMember {
                                                currentPost = post
                                            }
                                            else {
                                                currentPost = Post(id: "", uid: "", challengeID: "", title: "", content: "", createdAt: Date())
                                            }
                                        }
                                        print("selectedMember", selectedMember)
                                    } label: {
                                        VStack{
                                            Image("\(userinfo.proImage)")
                                                .resizable()
                                                .frame(width: 44, height: 44)
                                                .aspectRatio(contentMode: .fit)
                                            Text(userinfo.name)
                                        } //VStack
                                    } // label
                                }
                            } //ForEach
                        }//HStack
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color("AccentColor"))
                    showContentsView(selectedMember)
                    Spacer()
                    //
                }
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 30, height: 550)
        .background(
            Rectangle()
                .foregroundColor(Color("CellColor"))
                .cornerRadius(20)
        )
        .onAppear(){
            Task{
                // customModalView에서 불러온 mateArray의 순서를 변경할 필요가 있다.
                // CurrentUser의 uid가 mateArray[0으로 와야함]
                let current = authManager.firebaseAuth
                let currentUser = current.currentUser?.uid
                let mateArray = habitManager.currentChallenge.mateArray
                var sortedMateArray = sortMateArray(mateArray, currentUserUid: currentUser ?? "")
                selectedMember = currentUser ?? ""
                // currentMateInfo를 초기화 해주는 부분.
                // 초기화를 하지 않는다면 onAppear 할 때마다 currentInfo가 늘어난다.
                habitManager.currentMateInfos = []
                for member in habitManager.currentChallenge.mateArray {
                    var userInfo = try await userInfoManager.getUserInfoByUID(userUid: member)
                
                    habitManager.currentMateInfos.append(userInfo ?? User(id: "", name: "", email: "", pw: "", proImage: "", badge: [], friends: []))
                }
                print("selectedMember", selectedMember)
            }
        }
        .onChange(of: selectedMember) { newValue in
            
        }
    }
    @ViewBuilder
    func showContentsView(_ selectedMember: String) -> some View {
        
        VStack {
            if currentPost.title != "" {
                Text("제목: \(currentPost.title)")
                    .font(.custom("IMHyemin-Bold", size: 22))
                Divider()
                
                HStack{
                    Text(currentPost.content)
                        .font(.custom("IMHyemin-Regular", size: 15))
                }
                Spacer()
            }
            else {
                EmptyCellView(currentContentsType: .post)
            }
        }
        .onAppear(){
            print(postsForModalView)
            for post in postsForModalView {
                if post.uid == selectedMember {
                    currentPost = post
                }
                else {
                    currentPost = Post(id: "", uid: "", challengeID: "", title: "", content: "", createdAt: Date())
                }
            }
            print(currentPost)
        }
    }
    
    
    func sortMateArray(_ mateArray: [String], currentUserUid: String) -> [String] {
        var currentUserArray: [String] = []
        var otherMatesArray: [String] = []
        
        for uid in mateArray {
            
            if uid == currentUserUid {
                currentUserArray.append(uid)
            }
            else {
                otherMatesArray.append((uid))
            }
        }
        
        let tempArray = currentUserArray + otherMatesArray
        
        return tempArray
    }
}

struct PostModalView_Previews: PreviewProvider {
    static var previews: some View {
        PostModalView(postsForModalView: .constant([
            Post(id: "temp_id", uid: "GqAtTh9IMmMuZrFlRqZoZCOrV1l1", challengeID: "7B2BFA02-2E44-49CC-9776-C34A8D078F80", title: "중R", content: "zz", createdAt: Date()) ]))
    }
}
