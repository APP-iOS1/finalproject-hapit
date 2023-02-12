//
//  AppleLogIn.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI
import AuthenticationServices
import CryptoKit

struct AppleLogIn: View {
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        Button(action: {
            Task {
                await authManager.startSignInWithAppleFlow()
            }
        }){
            Text("애플 로그인")
        }
    }
}

struct AppleLogIn_Previews: PreviewProvider {
    static var previews: some View {
        AppleLogIn()
    }
}
