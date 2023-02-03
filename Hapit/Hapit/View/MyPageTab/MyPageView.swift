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
    @Binding var index: Int
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ProfileCellView()
                    RewardView()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing){
                        NavigationLink {
                            OptionView(isFullScreen: $isFullScreen, index: $index)
                        } label: {
                            Image(systemName: "gearshape")
                                .resizable()
                                .frame(width: 25, height: 25)
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
        MyPageView(isFullScreen: .constant(true), index: .constant(0))
    }
}
