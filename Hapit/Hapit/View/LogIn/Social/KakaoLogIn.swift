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
            Text("카카오톡 로그인")
        }
    }
}

//struct KakaoLogIn_Previews: PreviewProvider {
//    static var previews: some View {
//        KakaoLogIn(authManager: AuthManager())
//    }
//}
