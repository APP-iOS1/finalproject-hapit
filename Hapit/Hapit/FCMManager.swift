//
//  FCMManager.swift
//  Hapit
//
//  Created by 추현호 on 2023/02/09.
//

import Foundation
import Firebase
import Combine

let fcmManager = FCMManager()
let serverKey = ""

final class FCMManager: ObservableObject {
    
    @Published var titleText: String = ""
    @Published var bodyText: String = ""
    @Published var deviceToken: String = ""
    
    var sender: String?
    @Published var didChange = PassthroughSubject<[RemoteNotification], Never>() // 컴바인 코드
    @Published var data = [RemoteNotification](){
        didSet{
            didChange.send(data)
        }
    }
        
    func sendFirebaseMessageToUser(datas: FCMManager, to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String: Any] = ["to": token,
                                           "priority": "high",
                                           "notification": ["title": title, "body": body, "badge": 1],
                                           "data": ["user" : "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch {
            }
        }
        task.resume()
    }
}
