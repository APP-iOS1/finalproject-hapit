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

@MainActor
class AuthManager: ObservableObject {
    
    @Published var isLoggedin = false
    
    // 로컬에 저장하는 젤리들의 배열
    @Published var badges: [String] = []
    // Storage로 부터 받는 젤리들의 배열
    @Published var bearimagesDatas: [Data] = []
    
    // MARK: Storage URL
    let storageRef = Storage.storage().reference()
    
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
            let newby = User(id: target.uid, name: name, email: email, pw: pw, proImage: "bearWhite", badge: [], friends: [])
            
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
                    "proImage" : userInfo.proImage,
                    "badge" : userInfo.badge,
                    "friends" : userInfo.friends
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
    final func getNickName(uid: String) async throws -> String {
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
    final func updateUserNickName(uid: String, nickname: String) async throws -> Void {
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
    final func getPorImage(uid: String) async throws -> String {
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
    final func updateUserProfileImage(uid: String, image: String) async throws -> Void {
        let path = database.collection("User")
        do {
            try await path.document(uid).updateData(["proImage": image])
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 사용중인 유저의 소유한 뱃지가져오기
    func fetchBadgeList(uid: String) async throws {
        self.badges.removeAll()
        do {
            let target = try await database.collection("User").document("\(uid)")
                .getDocument()
            
            let docData = target.data()
            
            let badge: [String] = docData?["badge"] as! [String]
            
            for element in badge{
                badges.append(element)
            }
       } catch {
            throw(error)
           
       }
    }
    
    // MARK: - Storage에서 이미지 뱃지 가져오기
    //Storage에서 path에 해당하는 이미지를 가져온 뒤, imageData 배열에 추가해주는 함수
    //gs://hapit-b465e.appspot.com/jellybears/bearBlue1.png
    func fetchImages(paths: [String]) {
        self.bearimagesDatas.removeAll()
        
        for path in paths{
            let ref = storageRef.child("jellybears/" + path + ".png")
            
            ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if error != nil {
                    //print(error.localizedDescription)
                } else {
                    guard let data else { return }
                    self.bearimagesDatas.append(data)
                }
            }
            
        }
    
    }
    
}
