//
//  LogIn.swift
//  Hapit
//
//  Created by 김응관 on 2023/03/07.
//

import Foundation

protocol SignIn {
    var signInError: String { get set }
    func save(value: Any?, forkey key: String)
    func uploadUserInfo(userInfo: User) async throws
    func logOut() async throws
    func deleteUser(uid: String) async throws
}

// 로그인 상태에 관한 enum
enum Key: String {
    case logIn
    case logOut
}

// 로그인 방법에 관한 enum
enum LoginMethod: String {
    case general
    case apple
    case google
    case kakao
}

// 신규회원인지 기존회원인지 여부에 관한 enum
enum Newby: String {
    case newby
    case ob
}
