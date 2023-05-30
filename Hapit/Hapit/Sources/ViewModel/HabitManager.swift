//
//  HabitManager.swift
//  Hapit
//
//  Created by greenthings on 2023/01/17.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import FirebaseAuth

final class HabitManager: ObservableObject{
    
    enum LoadingState{
        
        case idle
        case loading
        case success
        //case error(Error)
    }
    
    enum FirebaseError: Error{
        case badSnapshot
    }

    var cancellables = Set<AnyCancellable>()
    
    let currentUser = Auth.auth().currentUser ?? nil

    // 특수한 조건(예로, 66일)이 되었을때, challenges 배열에서 habits 배열에 추가한다.
    // challenges 에서는 제거를 한다.
    @Published var currentMateInfos: [User] = []
    @Published var challenges: [Challenge] = []
    // 특수한 조건(예로, 66일)이 되었을때, challenges 배열에서 habits 배열에 추가한다.
    @Published var habits: [Challenge] = []
    // 해당하는 챌린지의 일지의 배열

    @Published var currentChallenge: Challenge = Challenge(id: "temp_challenge", creator: "temp_challenge", mateArray: [], challengeTitle: "temp_challenge", createdAt: Date(), count: 0, isChecked: false, uid: "temp_challenge")
    
    // 로딩상태를 저장하는 변수.
    @Published var loadingState: LoadingState = .idle
    
    var currentUserChallenges: [Challenge] {
        
        var tempChallenges: [Challenge] = []
        for challenge in challenges {
            if let currentUser = Auth.auth().currentUser ?? nil {
                if challenge.mateArray.contains(currentUser.uid){
                    tempChallenges.append(challenge)
                }
            } else {
                return []
            }
        }
        return tempChallenges
    }
    
    @Published var selectedFriends: [User] = []
    //나의 다이어리가 저장되는 변수
    @Published var posts: [Post] = []
    
    //챌린지를 같이 진행하고 있는 친구들의 다이어리가 저장되는 변수
    @Published var currentMatePosts: [Post] = []

    let database = Firestore.firestore()
    
    func fetchChallengeCombine() -> AnyPublisher<[Challenge], Error>{
        Future<[Challenge], Error> {  promise in
            self.database.collection("Challenge")
                .order(by: "createdAt", descending: true)
                .getDocuments{(snapshot, error) in
                    if let error = error {
                        promise(.failure (error))
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        promise(.failure (FirebaseError.badSnapshot))
                        return
                    }
                    
                    snapshot.documents.forEach { document in
                        if let challenge = try? document.data(as: Challenge.self){
                            self.isChallenge(challenge: challenge)
                        }
                    }
                    promise(.success(self.challenges))
                }
        }
        .eraseToAnyPublisher()
    }

    func isChallenge(challenge: Challenge){
        if (challenge.count > 65){
            self.habits.append(challenge)
        }else{
            self.challenges.append(challenge)
        }
    }

    func loadChallenge(){
        self.loadingState = .loading // 챌린지 가져오는 중임을 저장
        challenges.removeAll()
        self.fetchChallengeCombine()
            .sink { (completion) in
                switch completion{
                case .failure(_):
                    return
                case .finished:
                    self.loadingState = .success // 챌린지 모두 가져오기 성공
                    return
                }
            } receiveValue: { [weak self] (challenges) in
                self?.challenges = challenges
            }
            .store(in: &cancellables)
    }
    
    func create(_ challenge: Challenge) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            self.database.collection("Challenge")
                .document(challenge.id)
                .setData([
                    "id": challenge.id,
                    "creator": challenge.creator,
                    "mateArray": challenge.mateArray,
                    "challengeTitle": challenge.challengeTitle,
                    "createdAt": challenge.createdAt,
                    "count": challenge.count,
                    "isChecked": challenge.isChecked,
                    "uid": challenge.uid
                ]) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func createChallenge(challenge: Challenge){
        self.create(challenge)
            .sink { (completion) in
                switch completion{
                case .failure(_):
                    return
                case .finished:
                    return
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    // MARK: - 서버의 Challenge Collection에서 Challenge 객체 하나를 삭제하는 Method
    func removeChallenge(challenge: Challenge) {
        database.collection("Challenge")
            .document(challenge.id).delete()
        loadChallenge()
    }
    
    // MARK: - 서버의 Challenge Collection에서 Challenge의 mateArray에서 배열의 값 하나를 삭제하는 Method
    func removeChallegeMate(challenge: Challenge,removeValue: String) {
        let challegeDocument = database.collection("Challenge").document(challenge.id)
        
        challegeDocument.updateData([
            "mateArray": FieldValue.arrayRemove([removeValue])
        ])
        loadChallenge()
    }
    
    // MARK: - 서버의 Challenge Collection에서 Challenge의 mateArray에서 배열의 값 하나를 추가하는 Method
    // 챌린지 초대 메시지 수락 버튼에서 사용
    func addChallegeMate(challengeID: String, addValue: String) {
        let challegeDocument = database.collection("Challenge").document(challengeID)
        
        challegeDocument.updateData([
            "mateArray": FieldValue.arrayUnion([addValue])
        ])
        loadChallenge()
    }
    
    // MARK: - 사용 중인 유저의 이메일을 반환
    func getChallengeTitle(challengeID: String) async throws -> String {
        do {
            let target = try await database.collection("Challenge").document("\(challengeID)")
                .getDocument()
            let docData = target.data()
            let challengeTitle: String = docData?["challengeTitle"] as? String ?? ""
            
            return challengeTitle
        } catch {
            throw(error)
        }
    }
    
    // MARK: - 서버의 Challenge Collection에서 Challenge의 cretor를 변경하는 Method
    func updateChallegecreator(challenge: Challenge, creator: String) async throws {
        
        do {
        let challengeDocument = database.collection("Challenge").document(challenge.id)
        
        try await challengeDocument.updateData([
            "creator": creator
        ])
        } catch {
            throw(error)
        }
        loadChallenge()
    }
    
    // MARK: - 서버의 Challenge Collection에서 Challenge의 Uid를 변경하는 Method
    func updateChallegeUid(challenge: Challenge, uid: String) async throws {
        do {
            let challegeDocument = database.collection("Challenge").document(challenge.id)
            
            try await challegeDocument.updateData([
                "uid": uid
            ])
        } catch {
            throw(error)
        }
        
        loadChallenge()
    }
    
    // MARK: - 24시간 지나면 isChecked 다 false로 해주는 함수 - 그룹 챌린지
    func makeIsCheckedFalse(challenge: Challenge) -> AnyPublisher<Void, Error> {
        // Update a Challenge
        return Future<Void, Error> { promise in
            self.database.collection("Challenge")
                .document(challenge.id)
                .updateData(["isChecked": false])
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - 로컬에서 변경된 연속일수를 업데이트하는 함수
    func updateCount(challenge: Challenge, count: Int) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            self.database.collection("Challenge")
                .document(challenge.id)
                .updateData(["count": count]) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: - 24시간 지나면 체크 상태를 기반으로 일수를 계산하는 함수
    /// 하루라도 수행하지 않으면 0일로 초기화
    func countDays(count: Int, isChecked: Bool) -> Int{
        if isChecked == true{
            return count + 1
        } else {
            return 0
        }
    }
    
    func toggleIsChanged(isChecked: Bool) -> Bool{
        if isChecked == true{
            return false
        }else{
            return true
        }
    }
    
    @MainActor
    func fetchChallenge(challengeID: String) -> AnyPublisher<Challenge, Error> {
        
        Future<Challenge, Error> {  promise in
            
            let query = self.database.collection("Challenge")
                .whereField("id", isEqualTo: challengeID)
            
            query.getDocuments{(snapshot, error) in
                
                if let error = error {
                    promise(.failure (error))
                    return
                }
                
                guard let snapshot = snapshot else {
                    promise(.failure (FirebaseError.badSnapshot))
                    return
                }
                
                snapshot.documents.forEach { document in
                    if let currentChallenge = try? document.data(as: Challenge.self){
                        self.currentChallenge = currentChallenge
                    }
                }
                promise(.success(self.currentChallenge))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Post CRUD Part
    // MARK: - R: Fetch Posts 함수 (Service)
    @MainActor
    func fetchPosts(challengeID: String) -> AnyPublisher<[Challenge], Error> {
        
        Future<[Challenge], Error> {  promise in
            
            let query = self.database.collection("Post")
                .whereField("challengeID", isEqualTo: challengeID)
            
            query.getDocuments{(snapshot, error) in
                
                if let error = error {
                    promise(.failure (error))
                    return
                }
                
                guard let snapshot = snapshot else {
                    promise(.failure (FirebaseError.badSnapshot))
                    return
                }
                
                snapshot.documents.forEach { document in
                    if let post = try? document.data(as: Post.self){
                        self.posts.append(post)
                    }
                }
                promise(.success(self.challenges))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - R: Fetch Posts 함수 (ViewModel)
    @MainActor
    func loadPosts(challengeID: String){
        posts.removeAll()
        
        self.fetchPosts(challengeID: challengeID)
            .sink { (completion) in
                switch completion{
                case .failure(_):
                    return
                case .finished:
                    return
                }
            } receiveValue: { [weak self] (challenges) in
                self?.challenges = challenges
            }
            .store(in: &cancellables)
    }
    
    // MARK: - C: Create Post 함수 (Service)
    func createService(_ post: Post) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            self.database.collection("Post")
                .document(post.id)
                .setData([
                    "id": post.id,
                    "creatorID": post.creatorID,
                    "challengeID": post.challengeID,
                    "title": post.title,
                    "content": post.content,
                    "createdAt": post.createdAt
                ]) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - C: Post Create 함수 (ViewModel)
    func createPost(post: Post){
        self.createService(post)
            .sink { (completion) in
                switch completion{
                case .failure(_):
                    return
                case .finished:
                    return
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    // MARK: - U: Post Update 함수 (Service)
    func updatePostService(_ post: Post) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            self.database.collection("Post")
                .document(post.id)
                .updateData(["content" : post.content]) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - U: Post Update 함수 (ViewModel)
    func updatePost(post: Post) {
        self.updatePostService(post)
            .sink { (completion) in
                switch completion{
                case .failure(_):
                    return
                case .finished:
                    return
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    // MARK: - D: Post Delete 함수 (Service)
    func deletePostService(_ postID: String) -> AnyPublisher<Void, Error>{
        Future<Void, Error> { promise in
            self.database.collection("Post")
                .document(postID).delete()
            { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - D: Post Delete 함수 (ViewModel)
    func deletePost(postID: String) {
        self.deletePostService(postID)
            .sink { (completion) in
                switch completion {
                case .failure(_):
                    return
                case .finished:
                    return
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
