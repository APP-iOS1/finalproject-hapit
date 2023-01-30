//
//  SocialView.swift
//  Hapit
//
//  Created by 김예원 on 2023/01/17.
//

//import SwiftUI
//
//struct User: Identifiable {
//    let id : String
//    let name: String
//    let profileImage: String
//    let challenge: [String]
//}
//
//
//
//struct Users1 {
//    let users = [
//        User(id: "1",name: "박민주", profileImage: "bearBlue",challenge: ["물마시기","물마시기2","물마시기3"]),
//        User(id: "2",name: "김예원", profileImage: "bearGreen",challenge: ["아침먹기","아침먹기2","아침먹기3"]),
//        User(id: "3",name: "추현호", profileImage: "bearYellow",challenge: ["점심먹기3"]),
//        User(id: "4",name: "이주희", profileImage: "bearPurple",challenge: ["저녁먹기2","저녁먹기3"])
//    ]
//}
//
//struct SocialView: View {
//    let friends = Users1()
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                VStack {
//                    HStack {
//                        Spacer()
//                        Text("친구 수: 3")
//                            .font(.subheadline)
//                            .bold()
//                    }.padding(.trailing, 20)
//
//                    ScrollView{
//                        // TODO: 본인 표시 해줘야함 -> 셀 색깔로?
//                        ForEach(friends.users) { user in
//                            NavigationLink {
//                                FriendChallengeView()
//                            } label: {
//                                FriendsRow(friends: user)
//                            }
//                        }
//                    }
//                }
//                .navigationTitle("랭킹")
//                .toolbar {
//                    Button {
//
//                    } label: {
//                        // TODO: 나중에 메세지 오면 색깔, 심볼 삼항연산자로 변경
//                        // 읽은 상태
////                        Image(systemName: "envelope")
////                            .foregroundColor(.gray)
//                        // 메세지 온 상태
//                        Image(systemName: "envelope.badge")
//                            .foregroundColor(Color("AccentColor"))
//                    }
//
//                }
//            }.background(Color("BackgroundColor"))
//        }
//    }
//}
//struct FriendsRow: View {
//    let friends: User
//
//    var body: some View {
//        HStack {
//            // TODO: 노션에 적어놓은 랭킹대로 정렬
//            Text("\(friends.id)")
//                .font(.largeTitle)
//                .foregroundColor(Color("AccentColor"))
//
//            Image(friends.profileImage)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 40, height: 40)
//                .padding(10)
//
//            // TODO: 습관 개수???
//            VStack(alignment: .leading, spacing: 3) {
//                Text(friends.name)
//                    .foregroundColor(.black)
//                    .bold()
//                Text("현재 챌린지 개수: \(friends.challenge.count)")
//                    .font(.subheadline)
//                    .foregroundColor(Color(.systemGray))
//            }
//            Spacer()
//        }
//        .padding()
//        .background(.white)
//        .cornerRadius(20)
//        .padding(.horizontal)
//
//    }
//}
//
//
//struct SocialView_Previews: PreviewProvider {
//    static var previews: some View {
//        SocialView()
//    }
//}
