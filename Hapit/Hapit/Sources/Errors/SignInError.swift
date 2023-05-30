//
//  SignInError.swift
//  Hapit
//
//  Created by 김응관 on 2023/03/09.
//

import Foundation

enum SignInError: String {
    case uploadUserInfoError
    case firebaseAuthSignOutError
    case kakaoSignOutError
    case deleteUserError
    case firebaseAuthSignInError
    case registerUserError
    case emailDuplicateCheckError
    case nickNameDuplicateCheckError
    case appleSignInError
    case googleSignInError
    case firebaseAuthCredentialSignInError
    case getPassWordError
    case registerCheckError
    case kakaoInvalidTokenError
    case kakaoAccessTokenError
    case kakaoTalkSignInError
    case kakaoAccountSignInError
    case getKakaoUserInfoError
    case appleIdentityTokenFetchError
    case serializeTokenStringError
}
