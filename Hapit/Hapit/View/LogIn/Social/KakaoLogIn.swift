//
//  KakaoLogIn.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKUser

struct KakaoLogIn: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        Button(action: {
            Task {
                await authManager.kakaoSignIn()
            }
        }){
            Image("kakaobtn")
                .mask(Circle())
                .frame(width: 44, height: 44)
        }
    }
}

struct KakaoLogIn_Previews: PreviewProvider {
    static var previews: some View {
        KakaoLogIn()
            .environmentObject(AuthManager())
    }
}
