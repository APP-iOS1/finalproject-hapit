//
//  AuthManager.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/20.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthManager: ObservableObject {
    var userInfoStore: User = User(id: "", name: "", email: "", pw: "")
    
    @Published var isLoggedin = false
    
    let database = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    
    @Published var currentUser = firebaseAuth.currentUser ?? nil
    
    // MARK: - 로그인 
    public func login(with email: String, _ password: String) async -> Bool {
        do{
            try await firebaseAuth.signIn(withEmail: email, password: password)
            isLoggedin = true
        } catch{
            print(error.localizedDescription)
        }
        return isLoggedin
    }
    
    // MARK: - 신규회원 생성
    @MainActor
    func register(email: String, pw: String, name: String) async throws {
        do {
            //Auth에 유저등록
            let target = try await firebaseAuth.createUser(withEmail: email, password: pw).user
            
            // 신규회원 객체 생성
            let newby = User(id: target.uid, name: name, email: email, pw: pw)
            
            // firestore에 신규회원 등록
            await uploadUserInfo(userInfo: newby)
            
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 유저데이터 firestore에 업로드하는 함수
    func uploadUserInfo(userInfo: User) async {
        do {
            try await database.collection("User")
                .document(userInfo.id)
                .setData([
                    "email" : userInfo.email,
                    "pw" : userInfo.pw,
                    "name" : userInfo.name,
                ])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - 이메일 중복확인을 해주는 함수
    @MainActor
    func isEmailDuplicated(email: String) async -> Bool {
        do {
            let target = try await database.collection("User")
                .whereField("email", isEqualTo: email).getDocuments()
            
            if target.isEmpty {
                return false
            } else {
                return true
            }
            
        } catch {
            print(error.localizedDescription)
            return true
        }
    }
    // MARK: - 닉네임 중복확인을 해주는 함수
    @MainActor
    func isNicknameDuplicated(nickName: String) async -> Bool {
        do {
            let target = try await database.collection("User")
                .whereField("name", isEqualTo: nickName).getDocuments()
            
            if target.isEmpty {
                return false //중복되지 않은 닉네임
            } else {
                return true //중복된 닉네임
            }
            
        } catch {
            print(error.localizedDescription)
            return true
        }
    }
    
    // MARK: - 사용 중인 유저의 닉네임, 이메일을 가져와서 --> currentUser에 투입
    func fetchUserInfo(user: User) {
        database.collection("User").getDocuments { snapshot, error in
            if let snapshot {
                for document in snapshot.documents {
                    let id: String = document.documentID
                    let docData = document.data()
                    
                    if id == user.id {
                        let userNickname: String = docData["name"] as? String ?? ""
                        let userEmail: String = docData["email"] as? String ?? ""
                        let userPw: String = docData["pw"] as? String ?? ""

                        self.currentUser = User(id: user.id, name: userNickname, email: userEmail, pw: userPw)

                        print(self.currentUser!)
                    }
                }
            }
        }
    }
}

