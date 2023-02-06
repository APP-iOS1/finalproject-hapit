//
//  LocalNotificationSettingView.swift
//  Hapit
//
//  Created by 박민주 on 2023/02/05.
//

import SwiftUI
import RealmSwift

struct LocalNotificationSettingView: View {
    
    // MARK: - Property Wrappers
    @EnvironmentObject var lnManager: LocalNotificationManager
    @Environment(\.scenePhase) var scenePhase
    @State private var scheduledDate = Date()
    @ObservedResults(HapitPushInfo.self) var hapitPushInfo
    var challengeID: String
    
    // MARK: - Properties
    // ex) var valueName: Bool = true
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center) {
            if lnManager.isGranted { // 기기에서 알림 허용이 되어있는 경우
                DatePicker("", selection: $scheduledDate, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                Button("저장하기") {
                    
                    //Realm에 푸쉬 정보 저장
                    
                    let newLocalPush = HapitPushInfo(pushID: challengeID, pushTime: scheduledDate, isChallengeAlarmOn: true)
                    $hapitPushInfo.append(newLocalPush)
                    
                }
                .buttonStyle(.bordered)
            } else {
                // 기기에서 알림 허용이 되어있지 않은 경우
                Button("설정에서 알림 허용하기") {
                    lnManager.openSettings()
                }
                .buttonStyle(.borderedProminent)
            }
            
        }
    }
}
//
//struct LocalNotificationSettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocalNotificationSettingView()
//    }
//}
