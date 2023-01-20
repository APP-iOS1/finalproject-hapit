//
//  AuthManager.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/20.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class AuthManager: ObservableObject {
    @StateObject var userInfoStore: User = User()
    
    enum AuthError: Error {
        case reigisterError = "회원등록 오류"
        case logInError = "로그인 오류"
        case logOutError = "로그아웃 오류"
    }
    
    let database = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    let currentUser = Auth.auth().currentUser ?? nil
    
    // MARK: - 신규회원 생성
    @MainActor
    func register(email: String, pw: String, name: String, image: String) async throws -> String {
        do {
            //Auth에 유저등록
            let target = try await firebaseAuth.register(email: email, password: pw).user
            
            // 신규회원 객체 생성
            let newby = User(id: target.uid, email: email, pw: pw, name: name, image: image)
            
            // firestore에 신규회원 등록
            return uploadUserInfo(userInfo: newby)
        
        } catch {
            throw Error.registerError
        }
    }
    
    // MARK: - 유저데이터 firestore에 업로드하는 함수
    func uploadUserInfo(userInfo: User) async throws -> String {
        do {
            try await database.collection("User")
                .document(userInfo.id)
                .setData([
                    "email" : userInfo.email,
                    "pw" : userInfo.pw,
                    "name" : userInfo.name,
                    "image" : userInfo.image
                ])
        } catch {
            throw Error.registerError
        }
        return "회원등록 완료"
    }
    
}
