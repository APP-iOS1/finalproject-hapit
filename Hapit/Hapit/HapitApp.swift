//
//  HapitApp.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI
import Firebase
import FirebaseCore
import UserNotifications
import FirebaseMessaging
import UIKit
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth

class AppDelegate: NSObject, UIApplicationDelegate{
    @AppStorage("fcmToken") var fcmToken: String = ""
    @AppStorage("isUserAlarmOn") var isUserAlarmOn: Bool = false
    let gcmMessageIDKey = "gcm.Message_ID"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        KakaoSDK.initSDK(appKey: "fa6e48dad20c3ead13f0758608cb305f")

        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {didAllow, _ in
                self.isUserAlarmOn = didAllow
            })
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("\(#function)")
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
        self.fcmToken = fcmToken ?? ""
 
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
    
@main
struct HapitApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var googleSignIn = AuthManager()
    //private var modalManager: ModalManager = ModalManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(HabitManager())
                .environmentObject(AuthManager())
                .environmentObject(UserInfoManager())
                .environmentObject(LocalNotificationManager())
                .environmentObject(ModalManager())
                .environmentObject(MessageManager())
                .environmentObject(KeyboardManager())
                .environmentObject(BadgeManager())
                .environmentObject(NormalSignInManager())
                .environmentObject(AppleSignInManager())
                .environmentObject(KakaoSignInManager())
                .environmentObject(GoogleSignInManager())
                .environmentObject(SignInManager())
                .onAppear{
                    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
}
