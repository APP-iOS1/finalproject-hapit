//
//  ContentView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct ContentView: View {
    @State private var isFullScreen = true
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
             MyPageView()
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
