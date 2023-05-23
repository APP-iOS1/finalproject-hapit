//
//  GeneralSignInManager.swift
//  Hapit
//
//  Created by 김응관 on 2023/03/08.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase
import FirebaseCore
import FirebaseStorage
import SwiftUI
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class SignInManager: UIViewController, ObservableObject, SignIn {
    
    // MARK: - Properties
    
    // MARK: logIn Properties
    /// loggedIn: 로그인 상태에 관한 상태 값을 담은 변수
    /// signInError: 로그인/회원가입에서 발생한 에러 상태를 담은 변수
    @Published var loggedIn: String = UserDefaults.standard.string(forKey: "state") ?? ""
    @Published var signInError: String =
        UserDefaults.standard.string(forKey: "error") ?? ""
    
    // MARK: firestore references
    let database = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    
    // MARK: - Functions
    
    func save(value: Any?, forkey key: String) {
        UserDefaults.standard.set(value ?? "", forKey: key)
    }
    
    func uploadUserInfo(userInfo: User) async throws {
        do {
            try await database.collection("User")
                .document(userInfo.id)
                .setData([
                    "email" : userInfo.email,
                    "pw" : userInfo.pw,
                    "name" : userInfo.name,
                    "proImage" : userInfo.proImage,
                    "badge" : userInfo.badge,
                    "friends" : userInfo.friends,
                    "fcmToken" : userInfo.fcmToken
                ])
        } catch {
            self.save(value: SignInError.uploadUserInfoError.rawValue, forkey: "error")
            throw(error)
        }
    }
    
    func logOut() async throws {
        do {
            let loginMethod = UserDefaults.standard.string(forKey: "loginMethod") ?? ""

            switch loginMethod {
            case "google":
                try firebaseAuth.signOut()
                GIDSignIn.sharedInstance.signOut()
            case "kakao":
                try firebaseAuth.signOut()
                UserApi.shared.logout { (error) in
                    if error != nil {
                        self.save(value: SignInError.kakaoSignOutError.rawValue, forkey: "error")
                        return
                    }
                }
            default:
                try firebaseAuth.signOut()
            }
        } catch {
            self.save(value: SignInError.firebaseAuthSignOutError.rawValue, forkey: "error")
            throw(error)
        }
    }
    
    func deleteUser(uid: String) async throws {
        do {
            let loginMethod = UserDefaults.standard.string(forKey: "loginMethod") ?? ""

            switch loginMethod {
            case "google":
                GIDSignIn.sharedInstance.signOut()
            case "kakao":
                UserApi.shared.logout { (error) in
                    if error != nil {
                        self.save(value: SignInError.kakaoSignOutError.rawValue, forkey: "error")
                        return
                    }
                }
            default:
                break
            }

            try await firebaseAuth.currentUser?.delete()

            // User Document 삭제
            try await database.collection("User").document(uid).delete()
            // User의 friendArray에서 uid 삭제 - 완료
            // Challenge의 mateArray에서 uid 삭제
            // -> Challenge에서 mateArray에 해당 유저의 id 있으면 mateArray에서 id 삭제
            // Post의 uid(creatorID) 같은 post 삭제
        } catch {
            self.save(value: SignInError.deleteUserError.rawValue, forkey: "error")
            throw(error)
        }
    }
}
