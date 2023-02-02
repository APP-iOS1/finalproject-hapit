//
//  ContentView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct ContentView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    @AppStorage("autoLogIn") var isFullScreen: Bool = true
    
    @EnvironmentObject var authManager: AuthManager
    @State private var index: Int = 0
    //@StateObject var habitManager: HabitManager = HabitManager()

    var body: some View {
        TabView(selection: $index){
            HomeView()
                .tabItem {
                    VStack{
                        Image(systemName: "teddybear.fill")
                        Text("홈")
                    }
                }
                .tag(0)
            SocialView()
               .tabItem {
                   VStack{
                       Image(systemName: "globe.europe.africa.fill")
                       Text("소셜")
                   }
                }
               .tag(1)
            MyPageView(isFullScreen: $isFullScreen, index: $index).environmentObject(authManager)
                .tabItem {
                    VStack{
                        Image(systemName: "person.circle.fill")
                        Text("마이페이지")
                    }
                }
                .tag(2)
        }.fullScreenCover(isPresented: $isFullScreen) {
            LogInView(isFullScreen: $isFullScreen)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
