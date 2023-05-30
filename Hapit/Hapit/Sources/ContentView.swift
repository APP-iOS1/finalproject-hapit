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
    @EnvironmentObject var signInManager: SignInManager
    @EnvironmentObject var normalSignInManager: NormalSignInManager
    @EnvironmentObject var googleSignInManager: GoogleSignInManager
    @EnvironmentObject var kakaoSignInManager: KakaoSignInManager
    @EnvironmentObject var appleSignInManager: AppleSignInManager
    
    @State private var index: Int = 0
    @State private var flag: Int = 1
    
    var body: some View {
        switch manager() {
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
                    
                    try await authManager.addFcmToken(uid: authManager.firebaseAuth.currentUser?.uid ?? "", token: UserDefaults.standard.string(forKey: "fcmToken") ?? "")
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
                                        try await signOut()
                                    } catch {
                                        throw(error)
                                    }
                                } else if authManager.firebaseAuth.currentUser?.uid != "" && flag == 2 {
                                    do {
                                        try await getOut(uid: authManager.firebaseAuth.currentUser?.uid ?? "")
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
    
    func manager() -> String {
        var tmp: String?
        
        if UserDefaults.standard.string(forKey: "loginMethod") == "general" {
            tmp = normalSignInManager.loggedIn
        } else if UserDefaults.standard.string(forKey: "loginMethod") == "google" {
            tmp = googleSignInManager.loggedIn
        } else if UserDefaults.standard.string(forKey: "loginMethod") == "kakao" {
            tmp = kakaoSignInManager.loggedIn
        } else if UserDefaults.standard.string(forKey: "loginMethod") == "apple" {
            tmp = appleSignInManager.loggedIn
        }
        return tmp ?? ""
    }
    
    func signOut() async throws {
        let loginMethod = UserDefaults.standard.string(forKey: "loginMethod") ?? ""

        if loginMethod == "general" {
            try await normalSignInManager.logOut()
        } else if loginMethod == "google" {
            try await googleSignInManager.logOut()
        } else if loginMethod == "kakao" {
            try await kakaoSignInManager.logOut()
        } else if loginMethod == "apple" {
            try await appleSignInManager.logOut()
        }
    }
    
    func getOut(uid: String) async throws {
        let loginMethod = UserDefaults.standard.string(forKey: "loginMethod") ?? ""

        if loginMethod == "general" {
            try await normalSignInManager.deleteUser(uid: uid)
        } else if loginMethod == "google" {
            try await googleSignInManager.deleteUser(uid: uid)
        } else if loginMethod == "kakao" {
            try await kakaoSignInManager.deleteUser(uid: uid)
        } else if loginMethod == "apple" {
            try await appleSignInManager.deleteUser(uid: uid)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthManager())
            .environmentObject(SignInManager())
            .environmentObject(NormalSignInManager())
            .environmentObject(AppleSignInManager())
            .environmentObject(GoogleSignInManager())
            .environmentObject(KakaoSignInManager())
    }
}
