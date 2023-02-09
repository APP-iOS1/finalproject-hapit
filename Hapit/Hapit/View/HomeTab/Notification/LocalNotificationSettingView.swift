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
    @EnvironmentObject var habitManager: HabitManager
    @Environment(\.scenePhase) var scenePhase
    @State private var scheduledDate = Date()
    @ObservedRealmObject var localChallenge: LocalChallenge // 로컬챌린지에서 각 필드를 업데이트 해주기 위해 선언

    @Binding var isChallengeAlarmOn: Bool
    @Binding var isShowingAlarmSheet: Bool
    
    // MARK: - Properties
    // ex) var valueName: Bool = true
    var challengeID: String
    var challengeTitle: String
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center) {
            // 기기에서 알림 허용이 되어있는 경우
                DatePicker("", selection: $scheduledDate, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Button("저장하기") {
                    // Realm에 푸쉬 알림 정보 업데이트
                    $localChallenge.isChallengeAlarmOn.wrappedValue = true
                    $localChallenge.pushTime.wrappedValue = scheduledDate
                    
                    // challenges 업데이트
                    for challenge in habitManager.currentUserChallenges {
                        if challenge == habitManager.currentChallenge {
                            challenge.localChallenge.isChallengeAlarmOn = true
                            challenge.localChallenge.pushTime = scheduledDate
                        }
                    }
                    
                    print("저장한 후의 Realm의 localChallenge: \(localChallenge)")
                    print("저장한 후의 currentChallenge.localChallenge: \(habitManager.currentChallenge.localChallenge.localChallengeId)")

                    isChallengeAlarmOn = true
                    
                    Task{
                        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: scheduledDate)
                        await lnManager.schedule(localNotification: LocalNotification(identifier: challengeID, title: challengeTitle, body: "챌린지를 할 시간입니다", dateComponents: dateComponents, repeats: true))
                        
                        // 원래 dismiss쓰다가 isShowingAlarmSheet가 true인 상태여서 백그라운드모드일 때
                        // 다시 모달이 다시 올라가는 현상이 있어서 isShowingAlarmSheet를 바인딩해서 false로 고정.
                        isShowingAlarmSheet = false
                        
                    }
                }
                .buttonStyle(.bordered)
        }
        .onAppear{
            isChallengeAlarmOn = false // 저장하기 버튼을 안 누르고 모달을 닫을 경우에 알림이 해제되어 있어야 함. (아이콘)

            print("LocalNotificationSettingView의 localChallenge: \(localChallenge)")
            
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
