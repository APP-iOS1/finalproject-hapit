//
//  AuthManager.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/20.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase
import FirebaseCore
import CryptoKit
import SwiftUI
import AuthenticationServices

@MainActor
final class AuthManager: ObservableObject {
    
    @Published var isLoggedin = false //이거말고 --> UserInfoManager 함수 활용 생각해보기
    
    let database = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    
    // MARK: - 로그인 
    func login(with email: String, _ password: String) async throws {
        do{
            try await firebaseAuth.signIn(withEmail: email, password: password)
        } catch{
            throw(error)
        }
    }
    
    //MARK: - 로그아웃
    func logOut() async throws {
        do {
            try await firebaseAuth.signOut()
        } catch {
            throw(error)
        }
    }
    
    //MARK: - 회원탈퇴
    func deleteUser(uid: String) async throws {
        do {
            try await firebaseAuth.currentUser?.delete()
            try await database.collection("User").document("\(uid)").delete()
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 신규회원 생성
    func register(email: String, pw: String, name: String) async throws {
        do {
            //Auth에 유저등록
            let target = try await firebaseAuth.createUser(withEmail: email, password: pw).user
            
            // 신규회원 객체 생성
            let newby = User(id: target.uid, name: name, email: email, pw: pw, proImage: "bearWhite", badge: [], friends: [])
            
            // firestore에 신규회원 등록
            try await uploadUserInfo(userInfo: newby)
            
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 유저데이터 firestore에 업로드하는 함수
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
                    "friends" : userInfo.friends
                ])
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 이메일 중복확인을 해주는 함수
    func isEmailDuplicated(email: String) async throws -> Bool {
        do {
            let target = try await database.collection("User")
                .whereField("email", isEqualTo: email).getDocuments()
            
            if target.isEmpty {
                return false
            } else {
                return true
            }
            
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 닉네임 중복확인을 해주는 함수
    func isNicknameDuplicated(nickName: String) async throws -> Bool {
        do {
            let target = try await database.collection("User")
                .whereField("name", isEqualTo: nickName).getDocuments()
            
            if target.isEmpty {
                return false //중복되지 않은 닉네임
            } else {
                return true //중복된 닉네임
            }
            
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 사용 중인 유저의 닉네임을 반환
    func getNickName(uid: String) async throws -> String {
        do {
            let target = try await database.collection("User").document(uid)
                .getDocument()
            
            let docData = target.data()
            
            let tmpName: String = docData?["name"] as? String ?? ""
            
            return tmpName
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 사용 중인 유저의 닉네임을 수정
    func updateUserNickName(uid: String, nickname: String) async throws -> Void {
        let path = database.collection("User")
        do {
            try await path.document(uid).updateData(["name": nickname])
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 사용 중인 유저의 이메일을 반환
    final func getEmail(uid: String) async throws -> String {
        do {
            let target = try await database.collection("User").document("\(uid)")
                .getDocument()
            
            let docData = target.data()
            
            let tmpEmail: String = docData?["email"] as? String ?? ""
            
            return tmpEmail
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 사용 중인 유저의 친구목록을 반환
    final func getFriends(uid: String) async throws -> [String] {
        do {
            let target = try await database.collection("User").document("\(uid)")
                .getDocument()
            
            let docData = target.data()
            
            let tmpFriends: [String] = docData?["friends"] as? [String] ?? [""]
            
            return tmpFriends
        } catch {
            throw(error)
        }
    }

    // MARK: - 사용 중인 유저의 프로필사진을 반환
    func getPorImage(uid: String) async throws -> String {
        do {
            let target = try await database.collection("User").document("\(uid)")
                .getDocument()
            
            let docData = target.data()
            
            let tmpPorImage: String = docData?["proImage"] as? String ?? ""
            
            return tmpPorImage
       } catch {
            throw(error)
        }
    }

    // MARK: - 사용 중인 유저의 프로필 사진을 수정
    func updateUserProfileImage(uid: String, image: String) async throws -> Void {
        let path = database.collection("User")
        do {
            try await path.document(uid).updateData(["proImage": image])
        } catch {
            throw(error)
        }
    }
}

// MARK: - 애플 로그인 클래스
final class AppleLoginViewModel: ObservableObject {
    
    @Published var nonce = ""
    
    func authenticate(credential: ASAuthorizationAppleIDCredential){
        
        guard let token = credential.identityToken else{
            print("error with firebase")
            return
        }
        
        guard let tokenString = String(data: token, encoding: .utf8) else{
            print("error with Token")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        
        Auth.auth().signIn(with: firebaseCredential) { (result, err) in
            if let error = err{
                print(error.localizedDescription)
                return
            }
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

