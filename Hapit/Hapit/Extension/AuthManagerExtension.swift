//
//  AuthManagerExtension.swift
//  Hapit
//
//  Created by 김응관 on 2023/02/12.
//

import Foundation
import SwiftUI
import AuthenticationServices
import CryptoKit
import Firebase
import FirebaseAuth

extension AuthManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension AuthManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let currentNonce = nonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: currentNonce)
            
            Task {
                do {
                    // 1. 애플계정을 통해 FirebaseAuth 로그인 진행
                    let target = try await self.firebaseAuth.signIn(with: credential)
                    
                    // 2. 애플계정 uid, 이름, email, ID값 임시저장
                    let uid = target.user.uid
                    let appleName = target.user.displayName ?? ""
                    let appleMail = target.user.email ?? ""
                    let providerID = target.user.providerID
                    
                    // 3. 구글로그인 사용자의 정보가 담긴 firestore 문서 경로
                    let userRef = self.database.collection("User").document(uid)
                    
                    // 4. 해당 경로에 문서가 존재하는지 확인
                    let targetDoc = try await userRef.getDocument()
                    
                    // 5. 문서가 없을경우
                    if !(targetDoc.exists) {
                        
                        // 6. 새로운 User 객체 생성
                        let newby = User(id: uid, name: appleName, email: appleMail, pw: providerID, proImage: "bearWhite", badge: [], friends: [], loginMethod: "apple", fcmToken: "")
                        
                        // 7. firestore에 문서를 추가해준다
                        try await userRef.setData([
                            "email" : newby.email,
                            "pw" : newby.pw,
                            "name" : newby.name,
                            "proImage" : newby.proImage,
                            "badge" : newby.badge,
                            "friends" : newby.friends
                        ])
                    }
                    // 8. 로그인 상태 값 변경 및 UserDefaults 저장하기
                    self.loggedIn = "logIn"
                    self.save(value: Key.logIn.rawValue, forkey: "state")
                    self.loginMethod(value: LoginMethod.apple.rawValue, forkey: "loginMethod")
                } catch {
                    throw(error)
                }
            }
        }
    }
}
