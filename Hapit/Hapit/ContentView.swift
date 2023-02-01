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

    @State private var isFullScreen = true
    @State private var index: Int = 0
    
    //@StateObject var habitManager: HabitManager = HabitManager()

    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    VStack{
                        Image(systemName: "teddybear.fill")
                        Text("홈")
                    }
                }
            SocialView()
               .tabItem {
                   VStack{
                       Image(systemName: "globe.europe.africa.fill")
                       Text("소셜")
                   }
                }
            MyPageView(isFullScreen: $isFullScreen)
                .tabItem {
                    VStack{
                        Image(systemName: "person.circle.fill")
                        Text("마이페이지")
                    }
                }
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
