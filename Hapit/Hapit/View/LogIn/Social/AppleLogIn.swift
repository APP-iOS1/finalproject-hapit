//
//  AppleLogIn.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct AppleLogIn: View {
    
    @EnvironmentObject var appleViewModel: AppleLoginViewModel
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        SignInWithAppleButton { (request) in
            appleViewModel.nonce = appleViewModel.randomNonceString()
            request.requestedScopes = [.email, .fullName]
            request.nonce = appleViewModel.sha256(appleViewModel.nonce)
        } onCompletion: { (result) in
            switch result{
            case .success(let user):
                guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                    return
                }
                appleViewModel.authenticate(credential: credential)
                authManager.isLoggedin = true
            case .failure(_):
                authManager.isLoggedin = false
            }
        }
        .signInWithAppleButtonStyle(.black)
        .frame(width: 310, height: 50)
    }
}

struct AppleLogIn_Previews: PreviewProvider {
    static var previews: some View {
        AppleLogIn()
    }
}
