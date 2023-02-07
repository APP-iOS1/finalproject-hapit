//
//  ContentView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct ContentView: View {
//    init() {
//        UITabBar.appearance().backgroundColor = UIColor.white
//    }
    
    // UserDefault로 항상 앱에 로그인 정보 저장
    @AppStorage("autoLogIn") var isFullScreen: Bool = true
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var userInfoManager: UserInfoManager
    @State private var index: Int = 0
    @State private var flag: Int = 1

    var body: some View {
        //switch 쓰기엔 조금 타입이 그럼
        switch authManager.isLoggedin {
        case true:
            TabView(selection: $index) {
                HomeView()
                    .tabItem {
                        VStack{
                            Image(systemName: "teddybear.fill")
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
                
                MyPageView(isFullScreen: $isFullScreen, index: $index, flag: $flag)
                    .environmentObject(authManager)
                    .tabItem {
                        VStack{
                            Image(systemName: "person.circle.fill")
                            Text("마이페이지")
                        }
                    }
                    .tag(2)
                
            }
        default:
            LogInView(isFullScreen: $isFullScreen)
                    .onAppear {
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
                    .navigationBarColor(backgroundColor: .clear)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
