//
//  UserInfoViewModel.swift
//  Hapit
//
//  Created by 추현호 on 2023/01/17.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

final class UserInfoViewModel: ObservableObject {
    @Published var userInfo: User?
    let database = Firestore.firestore()
    let currentUserId = Auth.auth().currentUser?.uid ?? ""
    
    @MainActor
    public func fetchUserInfo() {
        database.collection("user").getDocuments { snapshot, error in
            if let snapshot {
                
                for document in snapshot.documents {
                    let id : String = document.documentID
                    let docData = document.data()
                    
                    if id == self.currentUserId {
                        
                        let id = document.documentID
                        let userEmail = docData["userEmail"] as? String ?? ""
                        let userName = docData["userName"] as? String ?? ""
                        let userImage = docData["userImage"] as? String ?? ""


                        
                        self.userInfo =
                        User(id: id, userEmail: userEmail, userImg: userImage, userName: userName)
                        
                        print(self.userInfo!)
                    }
                }
                
            }
        }
    }
    
}
