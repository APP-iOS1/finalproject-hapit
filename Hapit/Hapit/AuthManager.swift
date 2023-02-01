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

@MainActor
class AuthManager: ObservableObject {
    var userInfoStore: User = User(id: "", name: "", email: "", pw: "", proImage: "", badge: [])
    
    @Published var isLoggedin = false
    
    let database = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    
    // MARK: - 로그인 
    final func login(with email: String, _ password: String) async throws {
        do{
            try await firebaseAuth.signIn(withEmail: email, password: password)
        } catch{
            throw(error)
        }
    }
    
    //MARK: - 로그아웃
    final func logOut() async throws {
        do {
            try await firebaseAuth.signOut()
            isLoggedin = false
        } catch {
            throw(error)
        }
    }
    
    //MARK: - 회원탈퇴
    final func deleteUser(uid: String) async throws {
        do {
            try await firebaseAuth.currentUser?.delete()
            try await database.collection("User").document("\(uid)").delete()
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 신규회원 생성
    final func register(email: String, pw: String, name: String) async throws {
        do {
            //Auth에 유저등록
            let target = try await firebaseAuth.createUser(withEmail: email, password: pw).user
            
            // 신규회원 객체 생성
            let newby = User(id: target.uid, name: name, email: email, pw: pw, proImage: "", badge: [])
            
            // firestore에 신규회원 등록
            try await uploadUserInfo(userInfo: newby)
            
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 유저데이터 firestore에 업로드하는 함수
    final func uploadUserInfo(userInfo: User) async throws {
        do {
            try await database.collection("User")
                .document(userInfo.id)
                .setData([
                    "email" : userInfo.email,
                    "pw" : userInfo.pw,
                    "name" : userInfo.name,
                    "image" : userInfo.proImage,
                    "badge" : userInfo.badge
                ])
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 이메일 중복확인을 해주는 함수
    final func isEmailDuplicated(email: String) async throws -> Bool {
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
    final func isNicknameDuplicated(nickName: String) async throws -> Bool {
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
    final func getNickName(uid: String) async -> String {
        do {
            let target = try await database.collection("User").document("\(uid)")
                .getDocument()
            
            let docData = target.data()
            
            let tmpName: String = docData?["name"] as? String ?? ""
            
            return tmpName
        } catch {
            print(error.localizedDescription)
            return "error"
        }
    }
    
    // MARK: - 사용 중인 유저의 닉네임을 수정
    final func updateUserNickName(uid: String, nickname: String) async -> Void {
        //        guard let currentUserId else { return }
        let path = database.collection("User")
        do {
            try await path.document(uid).updateData(["name": nickname])
        } catch {
#if DEBUG
            print("\(error.localizedDescription)")
#endif
        }
    }
    
    // MARK: - 사용 중인 유저의 이메일을 반환
    final func getEmail(uid: String) async -> String {
        do {
            let target = try await database.collection("User").document("\(uid)")
                .getDocument()
            
            let docData = target.data()
            
            let tmpEmail: String = docData?["email"] as? String ?? ""
            
            return tmpEmail
        } catch {
            print(error.localizedDescription)
            return "error"
        }
    }
}
