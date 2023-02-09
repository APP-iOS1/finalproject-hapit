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
import GoogleSignIn

enum Key: String {
    case logIn
    case logOut
}

@MainActor
final class AuthManager: ObservableObject {
    
    @Published var nonce = ""
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
            
            let badge: [String] = docData?["badge"] as! [String]
            
            for element in badge{
                //self.fetchImages(path: element)
                badges.append(element)
            }
            // 뱃지들 중복처리
            
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
        

    // MARK: - 애플로그인 함수
    func authenticate(credential: ASAuthorizationAppleIDCredential) {
        guard let token = credential.identityToken else {
            return
        }
        
        guard let tokenString = String(data: token, encoding: .utf8) else{
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        
        // 1. Authentication에 로그인
        firebaseAuth.signIn(with: firebaseCredential) { (result, err) in
            // 애플로그인 사용자의 uid에 해당하는 문서 접근 경로
            let dbRef = self.database.collection("User")
                .document(result?.user.uid ?? "")
            
            dbRef.getDocument { (document, error) in
                // 2. 애플로그인 유저 uid에 해당하는 문서 없다면 새로 만들어준다
                if !(document?.exists ?? false) {
                    let newby = User(id: result?.user.uid ?? "", name: result?.user.displayName ?? "", email: result?.user.email ?? "", pw: "", proImage: "bearWhite", badge: [], friends: [])
                    
                    dbRef.setData([
                        "email" : newby.email,
                        "pw" : newby.pw,
                        "name" : newby.name,
                        "proImage" : newby.proImage,
                        "badge" : newby.badge,
                        "friends" : newby.friends
                    ])
                }
            }
        }
    }
    // MARK: - 구글로그인 함수
    func googleSignIn() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                let userRef = database.collection("User").document(user?.userID ?? "")
                
                // firestore에 없는 유저인 경우에는 새로 등록해준다
                userRef.getDocument { (document, err) in
                    if !(document?.exists ?? false) {
                        let newby = User(id: user?.userID ?? "", name: user?.profile?.name ?? "", email: user?.profile?.email ?? "", pw: "", proImage: "bearWhite", badge: [], friends: [])
                        
                        userRef.setData([
                            "email" : newby.email,
                            "pw" : newby.pw,
                            "name" : newby.name,
                            "proImage" : newby.proImage,
                            "badge" : newby.badge,
                            "friends" : newby.friends
                        ])
                    }
                }
                googleAuth(for: user, with: error)
            }
        } else {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [self] result, err in
                if let googleUser = result?.user {
                    let userRef = self.database.collection("User").document(googleUser.userID ?? "")
                    
                    userRef.getDocument { (document, err) in
                        if !(document?.exists ?? false) {
                            let newby = User(id: googleUser.userID ?? "", name: googleUser.profile?.name ?? "", email: googleUser.profile?.email ?? "", pw: "", proImage: "bearWhite", badge: [], friends: [])
                            
                            userRef.setData([
                                "email" : newby.email,
                                "pw" : newby.pw,
                                "name" : newby.name,
                                "proImage" : newby.proImage,
                                "badge" : newby.badge,
                                "friends" : newby.friends
                            ])
                        }
                    }
                }
                googleAuth(for: result?.user, with: err)
            }
        }
    }
    
    func googleAuth(for user: GIDGoogleUser?, with error: Error?) {
        if let error = error {
            return
        }
        guard let authenticationToken = user?.accessToken.tokenString, let idToken = user?.idToken?.tokenString else { return }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authenticationToken)

        Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
            if let error = error {
                return
            } else {
                self.loggedIn = "logIn"
            }
        }
    }
}
