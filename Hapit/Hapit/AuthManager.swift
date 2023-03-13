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
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

@MainActor
final class AuthManager: ObservableObject {

    // MARK: - Properties
    //@Published var loggedIn: String = UserDefaults.standard.string(forKey: "state") ?? ""

    // MARK: Badge Properties
    /// badges: View에서 실제로 사용되는 뱃지들의 "이름"을 담은 배열
    /// bearimagesDatas: Storage로 부터 다운 받는 Data형식 뱃지 배열, 해당 배열값을 통해 이미지를 보여줄 수 있음
    /// bearBadges: Badge 형식을 담은 뱃지 배열
    /// newBadges: Storage에서 최초로 가져온 뱃지 이미지들이 순서에 맞게 정렬되어 담기는 배열
    @Published var badges: [String] = []
    @Published var bearimagesDatas: [Data] = []
    @Published var bearBadges: [Badge] = []
    @Published var newBadges: [String] = []


    // MARK: firestore references
    /// storageRef: firebase storage 레퍼런스
    /// database: firestore DB 레퍼런스
    /// firebaseAuth: firebase Auth 레퍼런스
    let storageRef = Storage.storage().reference()
    let database = Firestore.firestore()
    let firebaseAuth = Auth.auth()

    // MARK: - Functions

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
    func getEmail(uid: String) async throws -> String {
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
    func getProImage(uid: String) async throws -> String {
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
    func getFCMToken(uid: String) async throws -> String {
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
    
    
    
}
