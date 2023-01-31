//
//  HapitApp.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI
import FirebaseCore
import OneSignal

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("d3ac2497-479d-4054-b6b1-e6dc03a64acd")
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notification: \(accepted)")
        })
        // Set your customer userId
        // OneSignal.setExternalUserId("userId")
        return true
    }
    
    private func setupExternalId() {
        let externalUserId = randomString(of: 10)
        
        OneSignal.setExternalUserId(externalUserId, withSuccess: { results in
            print("External user id update complete with results: ", results!.description)
            if let pushResults = results!["push"] {
                print("Set external user id push status: ", pushResults)
            }
            if let emailResults = results!["email"] {
                print("Set external user id email status: ", emailResults)
            }
            if let smsResults = results!["sms"] {
                print("Set external user id sms status: ", smsResults)
            }
        }, withFailure: {error in
            print("Set external user id done with error: " + error.debugDescription)
        })
    }
    
    
    private func randomString(of length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s
    }
    
    
}

@main
struct HapitApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(HabitManager())
                .environmentObject(AuthManager())
        }
    }
}
