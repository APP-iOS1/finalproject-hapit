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
    @ObservedRealmObject var localChallenge: LocalChallenge // 로컬챌린지에서 각 필드를 업데이트 해주기 위해 선언 - 담을 그릇
    @ObservedResults(LocalChallenge.self) var localChallenges // 새로운 로컬챌린지 객체를 담아주기 위해 선언 - 데이터베이스
    
    @Binding var isChallengeAlarmOn: Bool
    @Binding var isShowingAlarmSheet: Bool
    
    // MARK: - Properties
    // ex) var valueName: Bool = true
    var challengeID: String
    var challengeTitle: String
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                Text("매일 이 시간에 챌린지 수행 트리거 알림이 와요 !")
                    .font(.custom("IMHyemin-Regular", size: 17))
                    .padding(.bottom, 20)
                
                Image("bearAlarm")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 170)
                
                DatePicker("", selection: $scheduledDate, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .background(Color("CellColor"))
            }
            .navigationTitle("알림 설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingAlarmSheet = false
                    } label: {
                        Image(systemName: "multiply")
                            .foregroundColor(.gray)
                    } // label
                } // ToolbarItem
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Realm에 푸쉬 알림 정보 업데이트
                        $localChallenge.isChallengeAlarmOn.wrappedValue = true
                        $localChallenge.pushTime.wrappedValue = scheduledDate
                        
                        print("저장한 후의 Realm의 localChallenge: \(localChallenge)")
                        
                        isChallengeAlarmOn = true
                        
                        Task{
                            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: scheduledDate)
                            await lnManager.schedule(localNotification: LocalNotification(identifier: challengeID, title: challengeTitle, body: "챌린지를 수행할 시간이에요!", dateComponents: dateComponents, repeats: true))
                            
                            // 원래 dismiss쓰다가 isShowingAlarmSheet가 true인 상태여서 백그라운드모드일 때
                            // 다시 모달이 다시 올라가는 현상이 있어서 isShowingAlarmSheet를 바인딩해서 false로 고정.
                            isShowingAlarmSheet = false
                        }
                    } label: {
                        Image(systemName: "checkmark")
                    }
                } // ToolbarItem
            } // toolbar
            .onAppear {
                // 저장하기 버튼을 안 누르고 모달을 닫을 경우에 알림이 해제되어 있어야 함. (아이콘)
                isChallengeAlarmOn = false
                
                Task {
                    await lnManager.getCurrentSettings()
                }
            } // onAppear
        }
    }
}

//
//struct LocalNotificationSettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocalNotificationSettingView()
//    }
//}
