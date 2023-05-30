//
//  GoogleSignInManager.swift
//  Hapit
//
//  Created by 김응관 on 2023/03/08.
//

import Foundation
import Firebase
import GoogleSignIn

class GoogleSignInManager: SignInManager {
    // MARK: - 구글계정 로그인 함수
    func googleSignIn() async {
        // 앱에서 이전에 구글로그인을 한적이 있는 경우
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            Task {
                do {
                    // 1. 이전에 구글로그인 했던 계정 목록에 띄워줌 누르면 구글 로그인 자동 진행
                    let targetUser = try await GIDSignIn.sharedInstance.restorePreviousSignIn()

                    // 2. 로그인된 구글계정으로 FirebaseAuth 로그인 진행
                    try await googleAuth(for: targetUser)

                    // 3. gmail, ID, NickName 임시 저장
                    let gmail = targetUser.profile?.email ?? ""
                    let gID = targetUser.userID ?? ""
                    let nickName = "user" + UUID().uuidString

                    // 4. Auth 로그인 되어 있는 구글로그인 계정 uid 가져오기
                    let isNewby = self.firebaseAuth.currentUser?.uid ?? ""

                    // 5. 구글로그인 사용자의 정보가 담긴 firestore 문서 경로
                    let userRef = self.database.collection("User").document(isNewby)

                    // 6. 해당 경로에 문서가 존재하는지 확인
                    let targetDoc = try await userRef.getDocument()

                    // 7. 문서가 없을경우
                    if !(targetDoc.exists) {

                        // 8. 새로운 User 객체 생성
                        let newby = User(id: isNewby, name: nickName, email: gmail, pw: gID, proImage: "bearWhite", badge: [], friends: [], loginMethod: "google", fcmToken: "")

                        // 9. firestore에 문서를 추가해준다
                        try await userRef.setData([
                            "email" : newby.email,
                            "pw" : newby.pw,
                            "name" : newby.name,
                            "proImage" : newby.proImage,
                            "badge" : newby.badge,
                            "friends" : newby.friends
                        ])

                        self.save(value: Newby.newby.rawValue, forkey: "newby")
                    }
                    // 10. 로그인 상태 값 변경 및 UserDefaults 저장하기
                    self.loggedIn = "logIn"
                    self.save(value: Key.logIn.rawValue, forkey: "state")
                    self.save(value: LoginMethod.google.rawValue, forkey: "loginMethod")
                } catch {
                    self.save(value: SignInError.googleSignInError.rawValue, forkey: "error")
                    throw(error)
                }
            }
        } else {
            //앱에서 이전에 구글로그인 한 적이 없는 경우
            Task {
                do {
                    guard let clientID = FirebaseApp.app()?.options.clientID else { return }

                    let configuration = GIDConfiguration(clientID: clientID)

                    GIDSignIn.sharedInstance.configuration = configuration

                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    guard let rootViewController = windowScene.windows.first?.rootViewController else { return }

                    let target = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

                    try await googleAuth(for: target.user)

                    // 3. gmail, ID, NickName 임시 저장
                    let gmail = target.user.profile?.email ?? ""
                    let gID = target.user.userID ?? ""
                    let nickName = "user" + UUID().uuidString

                    // 4. Auth 로그인 되어 있는 구글로그인 계정 uid 가져오기
                    let isNewby = self.firebaseAuth.currentUser?.uid ?? ""

                    // 5. 구글로그인 사용자의 정보가 담긴 firestore 문서 경로
                    let userRef = self.database.collection("User").document(isNewby)

                    // 6. 해당 경로에 문서가 존재하는지 확인
                    let targetDoc = try await userRef.getDocument()

                    // 7. 문서가 없을경우
                    if !(targetDoc.exists) {

                        // 8. 새로운 User 객체 생성
                        let newby = User(id: isNewby, name: nickName, email: gmail, pw: gID, proImage: "bearWhite", badge: [], friends: [], loginMethod: "google", fcmToken: "")

                        // 9. firestore에 문서를 추가해준다
                        try await userRef.setData([
                            "email" : newby.email,
                            "pw" : newby.pw,
                            "name" : newby.name,
                            "proImage" : newby.proImage,
                            "badge" : newby.badge,
                            "friends" : newby.friends
                        ])

                        self.save(value: Newby.newby.rawValue, forkey: "newby")
                    }

                    // 10. 로그인 상태 값 변경 및 UserDefaults 저장하기
                    self.loggedIn = "logIn"
                    self.save(value: Key.logIn.rawValue, forkey: "state")
                    self.save(value: LoginMethod.google.rawValue, forkey: "loginMethod")
                } catch {
                    self.save(value: SignInError.googleSignInError.rawValue, forkey: "error")
                    throw(error)
                }
            }
        }
    }

    // MARK: - 구글계정을 통해 firebaseAuth SignIn 수행하는 함수
    func googleAuth(for user: GIDGoogleUser?) async throws {
        do {
            guard let authenticationToken = user?.accessToken.tokenString, let idToken = user?.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authenticationToken)

            // firebaseAuth 로그인 실행 (신규유저면 자동으로 추가됨)
            try await self.firebaseAuth.signIn(with: credential)
        } catch {
            self.save(value: SignInError.firebaseAuthCredentialSignInError.rawValue, forkey: "error")
            throw(error)
        }
    }
}
