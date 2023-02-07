//
//  MyPageView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var authManager: AuthManager
    
    @Binding var isFullScreen: String
    @Binding var index: Int
    @Binding var flag: Int
    @State private var nickName = ""
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ProfileCellView(nickName: $nickName, email: $email)
                        .padding(.top, -50)
                    RewardView()
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
