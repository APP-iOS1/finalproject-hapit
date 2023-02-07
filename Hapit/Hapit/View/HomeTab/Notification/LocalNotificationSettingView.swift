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
    @Environment(\.dismiss) var dismiss
    @State private var scheduledDate = Date()
    @ObservedResults(HapitPushInfo.self) var hapitPushInfo
    @Binding var isChallengeAlarmOn: Bool
    var challengeID: String
    var challengeTitle: String
    
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
                    
                    isChallengeAlarmOn = true
                    
                    Task{
                        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: scheduledDate)
                        await lnManager.schedule(localNotification: LocalNotification(identifier: challengeID, title: challengeTitle, body: "챌린지를 할 시간입니다", dateComponents: dateComponents, repeats: true))
                        dismiss()
                    }
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
        .onAppear{
            isChallengeAlarmOn = false // 저장하기 버튼을 안 누르고 모달을 닫을 경우에 알림이 해제되어 있어야 함. (아이콘)
            Task {
                await lnManager.getCurrentSettings()
                print("lnManager.isGranted SettingView: \(lnManager.isGranted)")
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
