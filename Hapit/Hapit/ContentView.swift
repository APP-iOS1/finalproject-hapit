//
//  ContentView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var keyboardManager: KeyboardManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var userInfoManager: UserInfoManager
    
    @State private var index: Int = 0
    @State private var flag: Int = 1
    
    var body: some View {
        switch authManager.loggedIn {
        case "logIn":
            TabView(selection: $index) {
                HomeView()
                    .tabItem {
                        VStack{
                            Image("teddybear.fill")
                                .renderingMode(.template)
                                .font(.title3)
                            Text("홈")
                        }
                    }
                    .tag(0)
                    .onAppear{
                        habitManager.loadChallenge()
                    }
                
                SocialView()
                    .tabItem {
                        VStack{
                            Image(systemName: "globe.europe.africa.fill")
                            Text("소셜")
                        }
                    }
                    .tag(1)
                
                MyPageView(index: $index, flag: $flag)
                    .environmentObject(authManager)
                    .tabItem {
                        VStack{
                            Image(systemName: "person.circle.fill")
                            Text("마이페이지")
                        }
                    }
                    .tag(2)
            }
            .onAppear{
                Task{
                    // String에 뱃지 이름을 String으로 가져옴.
                    try await authManager.fetchBadgeList(uid: authManager.firebaseAuth.currentUser?.uid ?? "")
                    // String 타입인 뱃지이름을 활용하여 Data를 가져옴.
                    try await authManager.fetchImages(paths: authManager.badges)
                }
            }
        default:
            LogInView()
                .onAppear {
                    Task {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            Task {
                                if authManager.firebaseAuth.currentUser?.uid != "" && flag == 1 {
                                    do {
                                        try await authManager.logOut()
                                    } catch {
                                        throw(error)
                                    }
                                } else if authManager.firebaseAuth.currentUser?.uid != "" && flag == 2 {
                                    do {
                                        try await authManager.deleteUser(uid: authManager.firebaseAuth.currentUser?.uid ?? "")
                                    } catch {
                                        throw(error)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationBarColor(backgroundColor: .clear)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(KeyboardManager())
            .environmentObject(AuthManager())
    }
}
