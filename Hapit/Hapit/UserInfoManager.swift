//
//  UserInfoManager.swift
//  Hapit
//
//  Created by 이주희 on 2023/02/03.
//

import SwiftUI
import FirebaseFirestore

typealias SnapshotDataType = [String: Any]

@MainActor
final class UserInfoManager: ObservableObject {
    @Published var userInfoArray = [User]()
    @Published var friendArray = [User]()
    @Published var currentUserInfo: User? = nil
    let database = Firestore.firestore()
    
    // MARK: - 현재 접속한 유저의 정보 불러오기
    // - parameters with: Auth.auth().currentUser.uid
    //싱글턴활용해보기
    func getCurrentUserInfo(currentUserUid: String?) async throws -> Void {
        guard let currentUserUid else { return }
        
        let userPath = database.collection("User").document("\(currentUserUid)")
        
        do {
            let snapshot = try await userPath.getDocument()
            if let requestedData = snapshot.data() {
                self.currentUserInfo = makeUser(with: requestedData, id: snapshot.documentID)
            }
        } catch {
            throw(error)
        }
    }
//    func getUserInfosByChallenge(challenge: Challenge) async throws -> [User] {
//        let mateArray: [String] = challenge.mateArray
//        var tempArray: [User] = []
//        do {
//            for mate in mateArray {
//                try await tempArray.append(getUserInfoByUID(userUid: mate) ?? User(id: "", name: "", email: "", pw: "", proImage: "bearWhite", badge: [], friends: []))
//                return tempArray
//            }
//        } catch {
//            throw(error)
//        }
//        return tempArray
//    }
    
    func getUserInfoByUID(userUid: String?) async throws -> User? {
        var tempUser: User? = nil
        guard let userUid else { return nil }
        
        let userPath = database.collection("User").document("\(userUid)")
        
        do {
            let snapshot = try await userPath.getDocument()
            if let requestedData = snapshot.data() {
                tempUser = makeUser(with: requestedData, id: snapshot.documentID)

                guard let tempUser else { return nil}
                return tempUser
            }
            else {
                dump("\(#function) - DEBUG: NO SNAPSHOT FOUND")
            }
        } catch {
            throw(error)
        }
        return tempUser
    }
    
    // MARK: getCurrentUserInfo(), fetchUserInfo에서 사용할 함수
    private func makeUser(with requestedData: SnapshotDataType, id: String) -> User {
        let id: String = id
        let name: String = requestedData["name"] as? String ?? ""
        let email: String = requestedData["email"] as? String ?? ""
        let pw: String = requestedData["pw"] as? String ?? ""
        let proImage: String = requestedData["proImage"] as? String ?? ""
        let badge: [String] = requestedData["badge"] as? [String] ?? [""]
        let friends: [String] = requestedData["friends"] as? [String] ?? [""]
        
        let userInfo = User(id: id, name: name, email: email, pw: pw, proImage: proImage, badge: badge, friends: friends)
        
        return userInfo
    }
    
    // MARK: 데이터베이스에 있는 전체 유저 정보 불러오기
    func fetchUserInfo() async -> Void {
        self.userInfoArray.removeAll()
        let path = database.collection("User")
        let _ = path.getDocuments() { (snapshot, error) in
            if let snapshot {
                for document in snapshot.documents {
                    let userData = self.makeUser(with: document.data(), id: document.documentID)
                    self.userInfoArray.append(userData)
                }
            }
        }
    }
    
    // MARK: 현재 유저의 친구 정보 불러오기
    // 다른 사람의 uid로 친구 불러올 일 없으므로 인자 제거했음
    func getFriendArray() async throws -> Void {
        // SocialView 불러오면서 getCurrentUserInfo()를 실행하기 때문에 CurrentUserInfo 사용 가능
        let friendList = currentUserInfo?.friends ?? [""]
        
        self.friendArray.removeAll()
        
        for friend in friendList {
            // 친구 아이디의 유저 경로
            let target = database.collection("User").document("\(friend)")
            do {
                let snapshot = try await target.getDocument()
                if let requestedData = snapshot.data() {
                    let friendData = makeUser(with: requestedData, id: snapshot.documentID)
                    self.friendArray.append(friendData)
                }
            } catch {
                throw(error)
            }
        }
    }
    
    // MARK: 친구 삭제
    // - parameters with: currentUserUid, user.id
    func removeFriendData(userID: String, friendID: String) async throws -> Void {
        do {
            // currentUser의 친구 목록에서 삭제
            try await database.collection("User")
                .document(userID)
                .updateData([
                    "friends": FieldValue.arrayRemove([friendID])
                ])
            
            // 해당 친구의 친구 목록에서 currentUser 삭제
            try await database.collection("User")
                .document(friendID)
                .updateData([
                    "friends": FieldValue.arrayRemove([userID])
                ])
        } catch {
            throw(error)
        }
    }
    
    // MARK: 친구 추가
    // - parameters with: currentUserUid, user.id
    func updateFriendList(receiverID: String, senderID: String) async throws -> Void {
        do {
            try await database.collection("User")
                .document(receiverID)
                .updateData([
                    "friends": FieldValue.arrayUnion([senderID])
                ])
            
            try await database.collection("User")
                .document(senderID)
                .updateData([
                    "friends": FieldValue.arrayUnion([receiverID])
                ])
        } catch {
            throw(error)
        }
    }
}
