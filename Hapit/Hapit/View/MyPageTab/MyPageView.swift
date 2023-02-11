//
//  MyPageView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct MyPageView: View {
    
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var badgeManager: BadgeManager
    
    @Binding var isFullScreen: String
    @Binding var index: Int
    @Binding var flag: Int
    @State private var nickName = ""
    @State private var email = ""
    
    // About Badge
    @State var isShowedConfetti: Bool = false
    @State var newOneName: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                        ProfileCellView(nickName: $nickName, email: $email)
                        RewardView()
                        .overlay(content: {
                            if isShowedConfetti{
                                JellyConfetti(title: newOneName)
                                    .onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                            isShowedConfetti.toggle()
                                        }
                                    }
                            }
                        })
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing){
                        NavigationLink {
                            OptionView(isFullScreen: $isFullScreen, index: $index, flag: $flag)
                        } label: {
                            Image(systemName: "gearshape")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                    }
                }
     
                .onAppear {
                    
                    Task {
                        
                        do {
                            let current = authManager.firebaseAuth.currentUser?.uid ?? ""
                            let nameTarget = try await authManager.getNickName(uid: current)
                            let emailTarget = try await authManager.getEmail(uid: current)
                            nickName = nameTarget
                            email = emailTarget
                            
                            // String에 뱃지 이름을 String으로 가져옴.
                            try await authManager.fetchBadgeList(uid: authManager.firebaseAuth.currentUser?.uid ?? "")
                            // String 타입인 뱃지이름을 활용하여 Data를 가져옴.
                            // Test 용
                            UserDefaults.standard.set(false, forKey: "noob")
                            
                            // MARK: First Login Check and there is a chance to get back
                            if (badgeManager.noob == false && !authManager.badges.contains(BadgeManager.BadgeImage.noob.rawValue)) {
                                // Save a status of a newbie badge.
                                badgeManager.save(forkey: BadgeManager.BadgeName.noob.rawValue)
                                
                                // Add a badge to cloud and fetch Images.
                                try await authManager.updateBadge(uid: authManager.firebaseAuth.currentUser?.uid ?? "", badge: BadgeManager.BadgeImage.noob.rawValue)
                                
                                isShowedConfetti.toggle()
                                newOneName = "noob"
                            }
                            
                        } catch {
                            throw(error)
                        }
                        
                    }
                }
            }
            .background(Color("BackgroundColor"))
            .navigationBarTitleDisplayMode(.inline)

        }
    }
}

//struct MyPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageView(isFullScreen: .constant(true), index: .constant(0))
//    }
//}
