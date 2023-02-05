//
//  LocalNotificationSettingView.swift
//  Hapit
//
//  Created by 박민주 on 2023/02/05.
//

import SwiftUI

struct LocalNotificationSettingView: View {
    
    // MARK: - Property Wrappers
    @EnvironmentObject var lnManager: LocalNotificationManager
    @Environment(\.scenePhase) var scenePhase
    @State private var scheduleDate = Date()
    
    // MARK: - Properties
    // ex) var valueName: Bool = true
    
    // MARK: - Body
    var body: some View {
        VStack {
            if lnManager.isGranted { // 기기에서 알림 허용이 되어있는 경우
                DatePicker("", selection: $scheduleDate, displayedComponents: .hourAndMinute)
                Button("Calendar Notification") {
                    Task {
                    let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: scheduleDate)
                    let localNotification = LocalNotification(identifier: UUID().uuidString,
                                                              title: "챌린지 이름",
                                                              body: "챌린지를 수행할 시간이에요!",
                                                              dateComponents: dateComponents,
                                                              repeats: false)
                        await lnManager.schedule(localNotification: localNotification)
                    }
                }
                .buttonStyle(.bordered)
            } else { // 기기에서 알림 허용이 되어있지 않은 경우
                Button("Enable Notifications") {
                    lnManager.openSettings()
                }
                .buttonStyle(.borderedProminent)
            }
            
        }
        .task {
            try? await lnManager.requestAuthorization()
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                Task {
                    await lnManager.getCurrentSettings()
                    await lnManager.getPendingRequests()
                }
            }
        }
    }
}

struct LocalNotificationSettingView_Previews: PreviewProvider {
    static var previews: some View {
        LocalNotificationSettingView()
    }
}
