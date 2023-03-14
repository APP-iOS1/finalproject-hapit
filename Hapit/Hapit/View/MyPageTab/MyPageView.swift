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
                    
                    ZStack{
                    
                        if isShowedConfetti{
                            
                            ZStack{
                                Text("축하해요.\n\(newOneName)을 얻으셨어요.")
                                //.font(.title)
                                    .padding()
                                    .font(.custom("IMHyemin-Bold", size: 23))
                                    .foregroundColor(.white)
                                    .background(Color.accentColor)
                                    .clipShape(Capsule())
                            }
                            
                        }else{
                            
                            RewardView()
                        }
                        
                        if isShowedConfetti{
                            
                                JellyConfetti(title: newOneName)
                                    .onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            isShowedConfetti.toggle()
                                        }
                                    }
                        }
                        
                    }
                    
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing){
                        NavigationLink {
                            OptionView(index: $index, flag: $flag)
                        } label: {
                            Image(systemName: "gearshape")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                    }
                }
                .task {
                    do {
                        let current = authManager.firebaseAuth.currentUser?.uid ?? ""
                        let nameTarget = try await authManager.getNickName(uid: current)
                        let emailTarget = try await authManager.getEmail(uid: current)
                        nickName = nameTarget
                        email = emailTarget
                        
                        // String에 뱃지 이름을 String으로 가져옴.
                        try await authManager.fetchBadgeList(uid: current)
                        try await authManager.fetchImages(paths: authManager.badges)
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
                            newOneName = "첫 가입 축하"
                        }
                        // MARK: First Login Check and there is a chance to get back
                        if habitManager.currentUserChallenges.count >= 5{
                            UserDefaults.standard.set(false, forKey: "pro")
                            if (badgeManager.pro == false && !authManager.badges.contains(BadgeManager.BadgeImage.pro.rawValue)) {
                                // Save a status of a newbie badge.
                                badgeManager.save(forkey: BadgeManager.BadgeName.pro.rawValue)
                                
                                // Add a badge to cloud and fetch Images.
                                try await authManager.updateBadge(uid: authManager.firebaseAuth.currentUser?.uid ?? "", badge: BadgeManager.BadgeImage.pro.rawValue)
                                
                                isShowedConfetti.toggle()
                                newOneName = "프로"
                            }
                            if habitManager.currentUserChallenges.count >= 10{
                                UserDefaults.standard.set(false, forKey: "master")
                                // MARK: First Login Check and there is a chance to get back
                                if (badgeManager.master == false && !authManager.badges.contains(BadgeManager.BadgeImage.master.rawValue)) {
                                    // Save a status of a newbie badge.
                                    badgeManager.save(forkey: BadgeManager.BadgeName.master.rawValue)
                                    
                                    // Add a badge to cloud and fetch Images.
                                    try await authManager.updateBadge(uid: authManager.firebaseAuth.currentUser?.uid ?? "", badge: BadgeManager.BadgeImage.master.rawValue)
                                    
                                    isShowedConfetti.toggle()
                                    newOneName = "마스터"
                                }
                            }
                        }
                        
                    } catch {
                        print(error)
                    }
                }
            }
            .background(Color("BackgroundColor"))
            .navigationBarTitleDisplayMode(.inline)
            .customToolbarBackground()
        }
    }
}

// .toolbarBackground 는 iOS 16부터 사용 가능
extension View {
    @ViewBuilder
    func customToolbarBackground() -> some View {
        if #available(iOS 16, *) {
            self
                .toolbarBackground(Color("BackgroundColor"), for: .navigationBar)
        } else {
            self
        }
    }
}

//struct MyPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageView(isFullScreen: .constant(true), index: .constant(0))
//    }
//}
