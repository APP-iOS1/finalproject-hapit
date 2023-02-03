//
//  NotificationManager.swift
//  Hapit
//
//  Created by 박민주 on 2023/01/30.
//

import UserNotifications
import SwiftUI
import RealmSwift

// hapitPushInfo에 저장된 챌린지 id를 가져와서 HapitManger 안에 있는 객체 배열 안의 해당 id의 객체에 접근해서 Title가져오기

class NotificationManager: ObservableObject {
    @EnvironmentObject var habitManager: HabitManager

    let notiCenter = UNUserNotificationCenter.current()
    
    @Published var isAlarmOn: Bool = false

    @Published var notiTime: Date = Date() {
        didSet {
            // Set Notification with the Time
            removeAllNotifications()
            addNotification(with: notiTime)
            // , challengeId: <#String#>
        }
    }
    
    @Published var isAlertOccurred: Bool = false
    
    // time에 반복되는 노티피케이션 추가
    // , challengeId: String
    func addNotification(with time: Date) {
        let content = UNMutableNotificationContent()
        
//        for i in habitManager.challenges {
//
//        }
        
        content.title = "챌린지명"
        content.subtitle = "챌린지를 수행할 시간이에요!"
        content.sound = UNNotificationSound.default
        
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notiCenter.add(request)
    }
    
    func removeAllNotifications() {
        notiCenter.removeAllDeliveredNotifications()
        notiCenter.removeAllPendingNotificationRequests()
    }
    
    func requestNotiAuthorization() {
        // 노티피케이션 설정을 가져오기
        // 상태에 따라 다른 액션 수행
        notiCenter.getNotificationSettings { settings in
            
            // 승인되어있지 않은 경우 request
            if settings.authorizationStatus != .authorized {
                self.notiCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                    if let error = error {
                        print("Error : \(error.localizedDescription)")
                    }
                    
                    // 노티피케이션 최초 승인
                    if granted {
                        self.addNotification(with: self.notiTime)
                    }
                    // 노티피케이션 최초 거부
                    else {
                        DispatchQueue.main.async {
                            self.isAlarmOn = false
                        }
                    }
                }
            }
            
            // 거부되어있는 경우 alert
            if settings.authorizationStatus == .denied {
                // 알림 띄운 뒤 설정 창으로 이동
                DispatchQueue.main.async {
                    self.isAlertOccurred = true
                }
            }
        }
    }
    
    // 디바이스 설정 앱으로 자동 이동
    func openSettings() {
       if let bundle = Bundle.main.bundleIdentifier,
          let settings = URL(string: UIApplication.openSettingsURLString + bundle) {
            if UIApplication.shared.canOpenURL(settings) {
               UIApplication.shared.open(settings)
            }
        }
    }
}
