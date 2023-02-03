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
    
    enum FirebaseError: Error{
        case badSnapshot
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    let currentUser = Auth.auth().currentUser ?? nil
    
    // 특수한 조건(예로, 66일)이 되었을때, challenges 배열에서 habits 배열에 추가한다.
    // challenges 에서는 제거를 한다.
    @Published var challenges: [Challenge] = []
    @Published var habits: [Challenge] = []
    @Published var posts: [Post] = []
    //나의 친구들을 받을 변수
    @Published var friends: [User] = []

    // 최종으로 받아오는 초대할 친구 목록
    @Published var seletedFriends: [ChallengeFriends] = []

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
                            self.challenges.append(challenge)
                        }
                    }
                    
                    promise(.success(self.challenges))
                    
                }
            
        }
        .eraseToAnyPublisher()
        
    }
    
    func loadChallenge(){
        
        challenges.removeAll()
        
        self.fetchChallengeCombine()
            .sink { (completion) in
                switch completion{
                    case .failure(let error):
                        print(error)
                        return
                    case .finished:
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
                    case .failure(let error):
                        print(error)
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
    
    // MARK: - Update a Habit
    @MainActor
    func updateChallenge() async{
        // Update a Habit
    }
    
    // MARK: - Update a Habit
    func updateChallengeIsChecked(challenge: Challenge) -> AnyPublisher<[Challenge], Error> {
        // Update a Challenge
        // Local
        let isChecked = challenge.isChecked
        // TO server
        var check: Bool{
            if isChecked == true{
                return false
            }else{
                return true
            }
        }
        
        return Future<[Challenge], Error> {  promise in
            
            self.database.collection("Challenge")
                .document(challenge.id)
                .updateData(["isChecked": check])
            promise(.success(self.challenges))
            
        }
        .eraseToAnyPublisher()
    }
    func loadChallengeIsChecked(challenge: Challenge){
        self.updateChallengeIsChecked(challenge: challenge)
            .sink { (completion) in
                switch completion{
                    case .failure( _):
                        return
                    case .finished:
                        return
                }
            } receiveValue: { [weak self] (challenges) in
                self?.challenges = challenges
            }
            .store(in: &cancellables)
    loadChallenge()
    }
    
    // MARK: - About Posts
    @MainActor
    func fetchPosts(id: String) -> AnyPublisher<[Challenge], Error>{
        
        Future<[Challenge], Error> {  promise in
            
            let query = self.database.collection("Post")
                .whereField("challengeID", isEqualTo: id)
            
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
    
    @MainActor
    func loadPosts(id: String){
        posts.removeAll()
        
        self.fetchPosts(id: id)
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
}
