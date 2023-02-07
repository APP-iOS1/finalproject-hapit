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
    var userInfos: [User] {
        return habitManager.currentMateInfos
    }
    //@State var selectedUser: String =
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
                            .font(.custom("IMHyemin-Bold", size: 34))
                        Divider()
                        
                        HStack{
                            Text(postsForModalView[0].content)
                                .font(.custom("IMHyemin-Regular", size: 17))
                        }
                        Spacer()
                    }
                } else{
                    // MARK: 챌린지를 진행하는 사람이 여럿인 경우
                    ScrollView(.horizontal){
                        ForEach(userInfos, id: \.self){ userinfo in
                            VStack{
                                Button {
                                    //MARK: 버튼을 누르면 selectedUser의 값이 변경된다.
                                    //selectedUser = userinfo.id
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
                        
                    }
                    Divider()
                    
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
                habitManager.currentMateInfos = []
                for member in habitManager.currentChallenge.mateArray {
                    var userInfo = try await userInfoManager.getUserInfoByUID(userUid: member)
                
                    habitManager.currentMateInfos.append(userInfo ?? User(id: "", name: "", email: "", pw: "", proImage: "", badge: [], friends: []))
                }
            }
        }
    }
}

struct PostModalView_Previews: PreviewProvider {
    static var previews: some View {
        PostModalView(postsForModalView: .constant([
            Post(id: "temp_id", uid: "GqAtTh9IMmMuZrFlRqZoZCOrV1l1", challengeID: "7B2BFA02-2E44-49CC-9776-C34A8D078F80", title: "중R", content: "zz", createdAt: Date()) ]))
    }
}
