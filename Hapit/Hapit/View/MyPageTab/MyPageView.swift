//
//  MyPageView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var authManager: AuthManager
    @Binding var isFullScreen: Bool
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ProfileCellView()
                        .environmentObject(authManager)
                    RewardView()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing){
                        NavigationLink {
                            OptionView(isFullScreen: $isFullScreen)
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .frame(width: 30,height: 30)
                        }
                    }
                }
            }
            .background(Color("BackgroundColor"))
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(isFullScreen: .constant(true))
    }
}
