//
//  HapitApp.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI
import FirebaseCore
import OneSignal

class AppDelegate: NSObject, UIApplicationDelegate, OSSubscriptionObserver {
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges) {
        
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        requestNotificationPermission()
        OneSignal.add(self as OSSubscriptionObserver)
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("d3ac2497-479d-4054-b6b1-e6dc03a64acd")
        
        return true
    }
    func requestNotificationPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in
            if didAllow {
                print("Push: 권한 허용")
            } else {
                print("Push: 권한 거부")
            }
        })
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
