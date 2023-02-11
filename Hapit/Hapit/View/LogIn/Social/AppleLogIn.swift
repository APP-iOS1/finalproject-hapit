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
        GeometryReader { geo in
            SignInWithAppleButton { (request) in
                authManager.nonce = randomNonceString()
                request.requestedScopes = [.fullName, .email]
                request.nonce = sha256(authManager.nonce)
            } onCompletion: { (result) in
                switch result{
                case .success(let user):
                    Task {
                        guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                            return
                        }
                        authManager.authenticate(credential: credential)
                        authManager.save(value: Key.logIn.rawValue, forkey: "state")
                        authManager.loginMethod(value: LoginMethod.apple.rawValue, forkey: "loginMethod")
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                        authManager.loggedIn = "logIn"
                    }
                    
                case .failure(_):
                    authManager.save(value: Key.logOut.rawValue, forkey: "state")
                    authManager.loggedIn = "logOut"
                }
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 50)
        }
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }

    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
}

struct AppleLogIn_Previews: PreviewProvider {
    static var previews: some View {
        AppleLogIn()
    }
}
