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
    @Environment(\.dismiss) var dismiss
    @State private var scheduledDate = Date()
    @ObservedResults(HapitPushInfo.self) var hapitPushInfo
    @Binding var isAlarmOn: Bool
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
                    
                    isAlarmOn = true
                    
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
        .task {
            //try? await lnManager.requestAuthorization()
            await lnManager.getCurrentSettings()
        }
        .onChange(of: scenePhase) { newValue in
            //앱이 작동중일 때
            //노티 authorize 해놓고 나가서 거부하고 다시 돌아오면 enable이 되어있음 => 값이 바뀌어서 씬을 업데이트 해준거임
            if newValue == .active {
                Task {
                    await lnManager.getCurrentSettings()
                    await lnManager.getPendingRequests()
                    
                    //우리가 포어그라운드에 있든, 백그라운드에 있든(씬이 바뀔때) 얼마나 많은 대기중 리퀘스트가 있는지 여기서도 보고싶으니까
                }
            }
        }
        .onAppear{
            isAlarmOn = false
        }
    }
}
//
//struct LocalNotificationSettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocalNotificationSettingView()
//    }
//}
