//
//  FCMManager.swift
//  Hapit
//
//  Created by 추현호 on 2023/02/09.
//

import Foundation

final class FCMManager: ObservableObject {
    
    @Published var titleText: String = ""
    @Published var bodyText: String = ""
    @Published var deviceToken: String = ""
    
    func sendMessageToDevice(){
        guard let url = URL(string: "http://fcm.googleapis.com/fcm/send") else {
            return
        }
        
        let json: [String: Any] = [
            
            "to": deviceToken,
            "notification": [
                
                "title": titleText,
                "body": bodyText
            ],
            "data": [
            ]
        ]
        
        let serverKey =
        "AAAAN0rizBg:APA91bG5s5bazorHw6aOn4L5-KYdDIpYEOfDHx4X8Qwn-uNM9KfYC-EoYzNJsnofBm4t2O31OlRJnXzOMW7NCdbQZeXafA4lt0Q5wL6DHTOWQEXpnVSVuO1tGkaJLx_Twonsxq9N9Eaw"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { _, _, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            print("Success")
            DispatchQueue.main.async {[self] in
                titleText = ""
                bodyText = ""
                deviceToken = ""
            }
        }
        .resume()
    }
    
    
}
