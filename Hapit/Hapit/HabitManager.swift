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


class HabitManager: ObservableObject{
    
    enum FirebaseError: Error{
        case badSnapshot
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    
    // 특수한 조건(예로, 66일)이 되었을때, challenges 배열에서 habits 배열에 추가한다.
    // challenges 에서는 제거를 한다.
    @Published var challenges: [Challenge] = []
    @Published var habits: [Challenge] = []
    
    
    let database = Firestore.firestore()
    
    
    // MARK: - Fetch Habits
    //func fetchHabits(uesrID: String) async{
    @MainActor
    func fetchChallenge() async{
        
        do {
            
            let documentHabit = try await database.collection("Challenge").getDocuments()
            
            //[<FIRQueryDocumentSnapshot: 0x600001640e60>, <FIRQueryDocumentSnapshot: 0x600001640f00>, <FIRQueryDocumentSnapshot: 0x600001640fa0>, <FIRQueryDocumentSnapshot: 0x600001641040>]
            //print(documentHabit.documents)
            challenges.removeAll()
            
            for document in documentHabit.documents {
                
                let documentData = document.data()
                // id: nil, we should define it in a firestore
                // print("id: \(documentData["id"])")
                
                let id = documentData["id"] as? String ?? "unknown id"
                let creator = documentData["creator"] as? String ?? "unknown creator"
                let mateArray = documentData["mateArray"] as? [String] ?? ["unkown mates"]
                let challengeTitle = documentData["challengeTitle"] as? String ?? "unknown habit title"
                // It is not working
                //var createdAt = documentData["createdAt"] as? Date ?? Date()
                // Solution
                // Firebase가 주는 Timestamp 형식의 값
                let createdAtTimeStamp: Timestamp = documentData["createdAt"] as? Timestamp ?? Timestamp()
                let createdAt: Date = createdAtTimeStamp.dateValue()
                
                let count = documentData["count"] as? Int ?? 0
                
                let isChecked = documentData["isChecked"] as? Bool ?? false
                
                challenges.append(Challenge(id: id, creator: creator, mateArray: mateArray, challengeTitle: challengeTitle, createdAt: createdAt, count: count, isChecked: isChecked))
            }
        }catch{
            dump(error)
        }
    }
    
    
    func fetchChallengeCombine() -> AnyPublisher<[Challenge], Error>{
        
        Future<[Challenge], Error> {  promise in
            
            self.database.collection("Challenge").getDocuments{(snapshot, error) in
                
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
    
    
    // MARK: - Add a Habit
    //func createHabit(creator: String) async {
    @MainActor
    func createChallenge(challengeTitle: String) async {
        
        let id = UUID().uuidString
        //let creatorId = "0b5MlIZzQxJzTbyyEEF2"
        
        do {
            try await database.collection("Challenge")
                .document(id)
                .setData([
                    "id": id,
                    "creator": "추원준",
                    "mateArray": [""],
                    "challengeTitle": challengeTitle,
                    "createdAt": Date.now.timeIntervalSince1970,
                    "count": 0,
                    "isChecked": false
                ])
        } catch {
            print(error.localizedDescription)
        }
        
        await fetchChallenge()
    }
    
    
    // MARK: - Delete a Habit
    // func deleteHabit(post: Post) {
    @MainActor
    func deleteChallenge() async{
        //  guard let currentUser = Auth.auth().currentUser?.uid else { return }
        //  firestore에서 삭제하기
        //        database.collection("User")
        //            .document(currentUser)
        //            .collection("Daylog")
        //            .document(daylog.id)
        //            .delete()
        // 현재 배열에서 제거하기
        // 다시 서버에서 불러올 수도 있지만, 그러기엔 비용이 많이 발생하므로 제거된 대상만 배열에서 빼버린다.
        //self.daylogList.removeAll { $0.id == daylog.id }
    }
    
    
    // MARK: - Update a Habit
    @MainActor
    func updateChallenge() async{
        // Update a Habit
    }
    
    // MARK: - Update a Habit
    @MainActor
    func updateChallengeIsChecked(challenge: Challenge) async{
        // Update a Challenge
        // Local
        var isChecked = challenge.isChecked
        // TO server
        var check: Bool{
            if isChecked == true{
                return false
            }else{
                return true
            }
        }
        
        do{
            try await database.collection("Challenge")
                .document(challenge.id)
                .updateData(["isChecked": check])
        }catch{
            print(error)
        }
        
        await fetchChallenge()
    }
    
}


