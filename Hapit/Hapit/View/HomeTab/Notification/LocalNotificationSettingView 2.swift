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
    @Binding var isChallengeAlarmOn: Bool
    @Binding var isShowingAlarmSheet: Bool
    var challengeID: String
    var challengeTitle: String
    
    // MARK: - Properties
    // ex) var valueName: Bool = true
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center) {
            // 기기에서 알림 허용이 되어있는 경우
                DatePicker("", selection: $scheduledDate, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Button("저장하기") {
                    //Realm에 푸쉬 정보 저장
                    //pushID가 identifier여서 같은 id면 append되지 않고 update(사실상 realm의 Create와 Update는 같은 로직으로 구현)
                    let newLocalPush = HapitPushInfo(pushID: challengeID, pushTime: scheduledDate, isChallengeAlarmOn: true)
                    $hapitPushInfo.append(newLocalPush)
                    
                    isChallengeAlarmOn = true
                    
                    Task{
                        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: scheduledDate)
                        await lnManager.schedule(localNotification: LocalNotification(identifier: challengeID, title: challengeTitle, body: "챌린지를 할 시간입니다", dateComponents: dateComponents, repeats: true))
                        
                        //원래 dismiss쓰다가 isShowingAlarmSheet가 true인 상태여서 백그라운드모드일때 다시 모달이 다시 올라가는 현상이 있어서 isShowingAlarmSheet를 바인딩해서 false로 고정.
                        isShowingAlarmSheet = false
                        
                    }
                }
                .buttonStyle(.bordered)
        }
        .onAppear{
            isChallengeAlarmOn = false // 저장하기 버튼을 안 누르고 모달을 닫을 경우에 알림이 해제되어 있어야 함. (아이콘)
            for push in hapitPushInfo {
                if push.pushID == challengeID {
                    scheduledDate = push.pushTime ?? Date()
                }
            }
            Task {
                await lnManager.getCurrentSettings()
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
