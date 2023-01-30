//
//  HapitApp.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
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
                .onAppear {
                    for family: String in UIFont.familyNames {
                                    print(family)
                                    for names : String in UIFont.fontNames(forFamilyName: family){
                                        print("=== \(names)")
                                    }
                                }
                }
        }
    }
}
