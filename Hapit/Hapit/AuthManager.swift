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
import FirebaseStorage
import SwiftUI
import AuthenticationServices
import CryptoKit
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

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

@MainActor
final class AuthManager: UIViewController, ObservableObject {

    @Published var nonce: String?
    @Published var loggedIn: String = UserDefaults.standard.string(forKey: "state") ?? ""
    
    // 로컬에 저장하는 젤리들의 배열
    @Published var badges: [String] = []
    // Storage로 부터 받는 젤리들의 배열
    @Published var bearimagesDatas: [Data] = []
    // Badge Modeling
    @Published var bearBadges: [Badge] = []
    // 데이터를 스토리지에 가져올떄, 순서 없이 가져와서
    // 이미지와 타이틀이 바뀌는 경우를 대비해서 적용시킴.
    @Published var newBadges: [String] = []
    
    // MARK: Storage URL
    let storageRef = Storage.storage().reference()
    
    let database = Firestore.firestore()
    let firebaseAuth = Auth.auth()
    
    // MARK: - 유저 로그인 정보 UserDefaults에 save 함수
    func save(value: Any?, forkey key: String) {
        UserDefaults.standard.set(value ?? "", forKey: key)
    }
    
    // MARK: - 유저의 로그인 방법 정보 UserDefaults에 save 함수
    func loginMethod(value: Any?, forkey key: String) {
        UserDefaults.standard.set(value ?? "", forKey: key)
    }
    
    // MARK: - [일반] FirebaseAuth 로그인 함수
    func login(with email: String, _ password: String) async throws {
        do {
            try await firebaseAuth.signIn(withEmail: email, password: password)
            self.loginMethod(value: LoginMethod.general.rawValue, forkey: "loginMethod")
        } catch{
            throw(error)
        }
    }
    
    // MARK: - [카카오] 로그인 시도 계정이 Auth에 등록된 사용자인지 확인하는 함수
    func isRegistered(email: String, pw: String, method: String) async throws -> String {
        var newUid: String = ""
            do {
                let target = try await firebaseAuth.createUser(withEmail: email, password: pw)
                newUid = target.user.uid
                return newUid
            } catch {
                do {
                    //1. 이메일이 이미 firestore에 등록된 이메일인지를 확인한다
                    let emailDup = try await isEmailDuplicated(email: email)
                    
                    //2. 이미 가입되어 있는 이메일이라면 해당 이메일 + 이메일이 든 document의 pw를 통해 로그인을 시도함
                    if emailDup {
                        //3. 이미 가입된 이메일 계정의 비밀번호를 가져옴
                        let password = try await getPassword(email: email)
                            
                        //4. 이미 가입된 계정으로 로그인
                        try await login(with: email, password)
                        
                        //5. 로그인 상태 변경
                        self.loggedIn = "logIn"
                        self.save(value: Key.logIn.rawValue, forkey: "state")
                        self.loginMethod(value: LoginMethod.kakao.rawValue, forkey: "loginMethod")
                    }
                } catch {
                    throw(error)
                }
                throw(error)
            }
    }
    
    //MARK: - 로그아웃
    func logOut() async throws {
        do {
            let loginMethod = UserDefaults.standard.string(forKey: "loginMethod") ?? ""
            
            switch loginMethod {
            case "google":
                try await firebaseAuth.signOut()
                GIDSignIn.sharedInstance.signOut()
            case "kakao":
                try await firebaseAuth.signOut()
                UserApi.shared.logout { (error) in
                    if error != nil {
                        return
                    } else {
                        print("kakao logOut Success")
                    }
                }
            default:
                try await firebaseAuth.signOut()
            }
        } catch {
            throw(error)
        }
    }
    
    //MARK: - 회원탈퇴
    func deleteUser(uid: String) async throws {
        do {
            let loginMethod = UserDefaults.standard.string(forKey: "loginMethod") ?? ""
            
            switch loginMethod {
            case "google":
                GIDSignIn.sharedInstance.signOut()
            case "kakao":
                UserApi.shared.logout { (error) in
                    if error != nil {
                        return
                    } else {
                        print("kakao logOut Success")
                    }
                }
            default:
                print("apple or general")
            }
            try await firebaseAuth.currentUser?.delete()
            // User Document 삭제
            try await database.collection("User").document("\(uid)").delete()
            // User의 friendArray에서 uid 삭제 - 완료
            // Challenge의 mateArray에서 uid 삭제
            // -> Challenge에서 mateArray에 해당 유저의 id 있으면 mateArray에서 id 삭제
            // Post의 uid(creatorID) 같은 post 삭제
        } catch {
            throw(error)
        }
    }
    
    // MARK: - [일반] 회원가입 신규회원 생성
    func register(email: String, pw: String, name: String) async throws {
        do {
            //Auth에 유저등록
            let target = try await firebaseAuth.createUser(withEmail: email, password: pw).user
            
            // 신규회원 객체 생성
            let newby = User(id: target.uid, name: name, email: email, pw: pw, proImage: "bearWhite", badge: [], friends: [], loginMethod: "general", fcmToken: "")
            
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
                    "friends" : userInfo.friends,
                    "fcmToken" : userInfo.fcmToken
                ])
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 이메일을 통해 비밀번호를 찾아 반환하는 함수
    func getPassword(email: String) async throws -> String {
        do {
            let target = try await database.collection("User")
                .whereField("email", isEqualTo: email).getDocuments()
            
            if target.isEmpty {
                return ""
            } else {
                // 어짜피 email은 고유한 존재이므로 문서는 무조건 1개가 걸려옴
                let docData = target.documents[0].data()
                // 비밀번호 추출
                let password = docData["pw"] as? String ?? ""
                
                return password
            }
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
    func getFriends(uid: String) async throws -> [String] {
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
    
    // MARK: - 유저의 FCM Token을 받아와 추가하기
    func addFcmToken(uid: String, token: String) async throws {
        let path = database.collection("User").document("\(uid)")
        
        do {
            try await path.updateData([
                "fcmToken": token
            ])
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 특정 유저의 FCM Token 반환
    final func getFCMToken(uid: String) async throws -> String {
        do {
            let target = try await database.collection("User").document("\(uid)")
                .getDocument()
            
            let docData = target.data()
            
            let tmpToken: String = docData?["fcmToken"] as? String ?? ""
            
            return tmpToken
        } catch {
            throw(error)
        }
    }

    
    // MARK: - 사용 중인 유저의 뱃지 추가하기
    func updateBadge(uid: String, badge: String) async throws {
        
        let path = database.collection("User").document("\(uid)")
        
        do {
            try await path.updateData([
                "badge": FieldValue.arrayUnion([badge])
            ])
        } catch {
            throw(error)
        }
        
        try await fetchBadgeList(uid: uid)
        try await fetchImages(paths: badges)
    }
    
    // MARK: - 사용중인 유저의 소유한 뱃지들 가져오기
    @MainActor
    func fetchBadgeList(uid: String) async throws {
        self.badges.removeAll()
        do {
            let target = try await database.collection("User").document("\(uid)")
                .getDocument()
            
            let docData = target.data()
            let badge: [String] = docData?["badge"] as? [String] ?? [""]
            
            for element in badge{
                //self.fetchImages(path: element)
                badges.append(element)
            }
            // 뱃지들 중복처리
            // print("badges: \(badges)")
            badges = Array(Set(badges))
            
        } catch {
            throw(error)
            
        }
    }
    
    // MARK: - Storage에서 이미지 뱃지 가져오기
    //Storage에서 path에 해당하는 이미지를 가져온 뒤, imageData 배열에 추가해주는 함수
    //gs://hapit-b465e.appspot.com/jellybears/bearBlue1.png
    @MainActor
    func fetchImages(paths: [String]) async throws {
        self.bearimagesDatas.removeAll()
        self.newBadges.removeAll()
        
        do {
            for path in paths{
                let ref = storageRef.child("jellybears/" + path + ".png")
                
                ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error != nil {
                        //print(error.localizedDescription)
                    } else {
                        guard let data else { return }
                        self.bearimagesDatas.append(data)
                        self.newBadges.append(path)
                    }
                }
            }
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 애플로그인 실행함수
    func startSignInWithAppleFlow() async {
        let newNonce = randomNonceString()
        nonce = newNonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce ?? "")

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // MARK: - 애플로그인 토큰 발급을 위해 필요한 함수들
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
                    let nickName = targetUser.profile?.name ?? ""
                    
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
                    }
                    // 10. 로그인 상태 값 변경 및 UserDefaults 저장하기
                    self.loggedIn = "logIn"
                    self.save(value: Key.logIn.rawValue, forkey: "state")
                    self.loginMethod(value: LoginMethod.google.rawValue, forkey: "loginMethod")
                } catch {
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
                    let nickName = target.user.profile?.name ?? ""
                    
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
                    }
                    
                    // 10. 로그인 상태 값 변경 및 UserDefaults 저장하기
                    self.loggedIn = "logIn"
                    self.save(value: Key.logIn.rawValue, forkey: "state")
                    self.loginMethod(value: LoginMethod.google.rawValue, forkey: "loginMethod")
                } catch {
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
            throw(error)
        }
    }
    
    // MARK: - 카카오 로그인
    func kakaoSignIn() async {
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
                        //카카오톡이 설치되어 있는지 확인
                        if (UserApi.isKakaoTalkLoginAvailable()) {
                            // 설치되어 있으면 카카오톡 로그인
                            Task {
                                await self.kakaoTalkLogIn()
                            }
                        } else {
                            // 미설치 상태이면 카카오계정 로그인
                            Task {
                                await self.kakaoAccountLogIn()
                            }
                        }
                    } else {
                        print("this error")
                    }
                } else {
                    print("already logged in")
                }
            }
        } else {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                // 설치되어 있으면 카카오톡 로그인
                Task {
                    await self.kakaoTalkLogIn()
                }
            } else {
                // 미설치 상태이면 카카오계정 로그인
                Task {
                    await self.kakaoAccountLogIn()
                }
            }
        }
    }
    // MARK: - 카카오톡 로그인 함수
    func kakaoTalkLogIn() async {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if error != nil{
                return
            }
            else {
                UserApi.shared.me { user, error in
                    if error != nil {
                        return
                    } else {
                        Task {
                            do {
                                // 카카오 이메일, Id, 닉네임 값 임시 저장
                                let kakaoEmail = user?.kakaoAccount?.email ?? ""
                                let kakaoId = String(user?.id ?? 0)
                                let kakaoNickName = user?.kakaoAccount?.profile?.nickname ?? ""
                                
                                // firestore에 등록된 유저인지 확인 -> 등록된 유저면 로그인/신규유저면 회원가입하고 uid 획득
                                let isNewby = try await self.isRegistered(email: kakaoEmail, pw: kakaoId, method: "kakao")
                                
                                // 신규 유저인 경우
                                if isNewby != "" {
                                    
                                    // 새로운 User 객체 생성
                                    let newby = User(id: isNewby, name: kakaoNickName, email: kakaoEmail, pw: kakaoId, proImage: "bearWhite", badge: [], friends: [], loginMethod: "kakao", fcmToken: "")
                                    
                                    // firestore에 문서 등록
                                    try await self.uploadUserInfo(userInfo: newby)
                                    
                                    // auth 로그인 및 로그인 상태값 변경
                                    try await self.login(with: kakaoEmail, kakaoId)
                                    
                                    self.loggedIn = "logIn"
                                    self.save(value: Key.logIn.rawValue, forkey: "state")
                                    self.loginMethod(value: LoginMethod.kakao.rawValue, forkey: "loginMethod")
                                }
                            } catch {
                                throw(error)
                            }
                        }
                    }
                }
            }
        }
    }
    //MARK: - 카카오계정 로그인 함수
    func kakaoAccountLogIn() async {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if error != nil{
                return
            }
            else {
                UserApi.shared.me { user, error in
                    if error != nil {
                        return
                    } else {
                        Task {
                            do {
                                // 카카오 이메일, Id, 닉네임 값 임시 저장
                                let kakaoEmail = user?.kakaoAccount?.email ?? ""
                                let kakaoId = String(user?.id ?? 0)
                                let kakaoNickName = user?.kakaoAccount?.profile?.nickname ?? ""
                                
                                // firestore에 등록된 유저인지 확인 -> 등록된 유저면 로그인/신규유저면 회원가입하고 uid 획득
                                let isNewby = try await self.isRegistered(email: kakaoEmail, pw: kakaoId, method: "kakao")
                                
                                // 신규 유저인 경우
                                if isNewby != "" {
                                    
                                    // 새로운 User 객체 생성
                                    let newby = User(id: isNewby, name: kakaoNickName, email: kakaoEmail, pw: kakaoId, proImage: "bearWhite", badge: [], friends: [], loginMethod: "kakao", fcmToken: "")
                                    
                                    // firestore에 문서 등록
                                    try await self.uploadUserInfo(userInfo: newby)
                                    
                                    // auth 로그인 및 로그인 상태값 변경
                                    try await self.login(with: kakaoEmail, kakaoId)
                                    
                                    self.loggedIn = "logIn"
                                    self.save(value: Key.logIn.rawValue, forkey: "state")
                                    self.loginMethod(value: LoginMethod.kakao.rawValue, forkey: "loginMethod")
                                }
                            } catch {
                                throw(error)
                            }
                        }
                    }
                }
            }
        }
    }
}
