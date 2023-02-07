//
//  UserInfoManager.swift
//  Hapit
//
//  Created by 이주희 on 2023/02/03.
//

import SwiftUI
import FirebaseFirestore

typealias SnapshotDataType = [String: Any]

final class UserInfoManager: ObservableObject {
    @Published var friendArray = [User]()
    @Published var currentUserInfo: User? = nil
    
    let database = Firestore.firestore()
    
    // MARK: - 현재 접속한 유저의 정보 불러오기
    // - parameters with: Auth.auth().currentUser.uid
    func getCurrentUserInfo(currentUserUid: String?) async throws -> Void {
        guard let currentUserUid else { return }
        let userPath = database.collection("User").document("\(currentUserUid)")
        do {
            let snapshot = try await userPath.getDocument()
            if let requestedData = snapshot.data() {
                self.currentUserInfo = makeCurrentUser(with: requestedData)
                guard let currentUserInfo else { return }
            }
            else {
                dump("\(#function) - DEBUG: NO SNAPSHOT FOUND")
            }
        } catch {
            throw(error)
        }
    }
    
    // MARK: getCurrentUserInfo()에서 사용할 함수
    private func makeCurrentUser(with requestedData: SnapshotDataType) -> User {
        let id: String = requestedData["id"] as? String ?? ""
        let name: String = requestedData["name"] as? String ?? ""
        let email: String = requestedData["email"] as? String ?? ""
        let pw: String = requestedData["pw"] as? String ?? ""
        let proImage: String = requestedData["proImage"] as? String ?? ""
        let badge: [String] = requestedData["badge"] as? [String] ?? [""]
        let friends: [String] = requestedData["friends"] as? [String] ?? [""]
        
        let currentUser = User(id: id, name: name, email: email, pw: pw, proImage: proImage, badge: badge, friends: friends)
        
        return currentUser
    }
    
    // MARK: 현재 유저의 친구 정보 불러오기
    func getFriendArray(currentUserUid: String) async throws -> Void {
        //guard let currentUserUid else { return }
//        var uid = ""
//
//        if currentUserUid == nil{
//            uid = "0TNE4PomiUdal8xg4wsUevBmUNt1"
//        }else{
//            uid = currentUserUid ?? "Impossible"
//        }

        let target = try await database.collection("User").document(currentUserUid).getDocument()
        let docData = target.data()
        //친구의 UID 리스트
        let friendList: [String] = docData?["friends"] as? [String] ?? [""]
        
        self.friendArray.removeAll()
        
        for friend in friendList {
            // 친구 아이디의 유저 경로
            let target = database.collection("User").document("\(friend)")
            do {
                let snapshot = try await target.getDocument()
                if let requestedData = snapshot.data() {
                    // 친구의 유저 정보 불러와서 배열에 더하기
                    let friendData = makeCurrentUser(with: requestedData)
//                    DispatchQueue.main.async {
                    // UID까지 저장한 friendData
                    let getFriendData = User(id: friend, name: friendData.name, email: friendData.email, pw: friendData.pw, proImage: friendData.proImage, badge: friendData.badge, friends: friendData.friends)
                    
                        self.friendArray.append(getFriendData)
//                    }
                } else {
                    dump("\(#function) - DEBUG: NO SNAPSHOT FOUND")
                }
            } catch {
                throw(error)
            }
        }
    }
    
}
