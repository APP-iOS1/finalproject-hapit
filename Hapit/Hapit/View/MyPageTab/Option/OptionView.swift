//
//  OptionView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/31.
//

import SwiftUI
import FirebaseAuth

struct OptionView: View {
    @EnvironmentObject var lnManager: LocalNotificationManager
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("isUserAlarmOn") var isUserAlarmOn: Bool = false
    @State private var isSettingsAlert = false
    @Binding var index: Int
    @Binding var flag: Int

    var body: some View {
        VStack {
            List {
                NavigationLink {
                    
                } label: {
                    Text("해핏에 대해서")
                        .modifier(ListTextModifier())
                }.listRowSeparator(.hidden)
                
                NavigationLink {
                    
                } label: {
                    Text("오픈소스 라이선스")
                        .modifier(ListTextModifier())
                }.listRowSeparator(.hidden)
                
                NavigationLink {
                    
                } label: {
                    Text("이용약관")
                        .modifier(ListTextModifier())
                }.listRowSeparator(.hidden)
                
                NavigationLink {
                    
                } label: {
                    Text("개인정보 처리방침")
                        .modifier(ListTextModifier())
                }.listRowSeparator(.hidden)
                
                NavigationLink {
                    
                } label: {
                    Text("만든 사람들")
                        .modifier(ListTextModifier())
                }.listRowSeparator(.hidden)
                
                NavigationLink {
                    AccountView(index: $index, flag: $flag)
                } label: {
                    Text("계정")
                        .modifier(ListTextModifier())
                }.listRowSeparator(.hidden)
                
                Toggle("알림", isOn: $lnManager.isAlarmOn)
                    .onChange(of: lnManager.isAlarmOn) { val in
                        if val == false {
                            lnManager.clearRequests()
                        } else {
                            if lnManager.isGranted == false {
                                isSettingsAlert.toggle()
                                if isSettingsAlert {
                                    lnManager.isAlarmOn = false
                                }
                            }
                        }
                        isUserAlarmOn = val
                    }
                    .listRowSeparator(.hidden)
                    .font(.custom("IMHyemin-Bold", size: 16))
                
            }
            .listStyle(PlainListStyle())

        } // VStack
        .onAppear {
            Task{
                await lnManager.getCurrentSettings()
                if !lnManager.isGranted {
                    lnManager.isAlarmOn = lnManager.isGranted
                    isUserAlarmOn = lnManager.isGranted
                }
                lnManager.isAlarmOn = isUserAlarmOn
                
            }
        }
        .onChange(of: scenePhase) { newValue in
            // 앱이 작동중일 때
            // 노티 authorize 해놓고 나가서 거부하고 다시 돌아오면 enable이 되어있음 => 값이 바뀌어서 씬을 업데이트 해준거임
            // 설정 앱에서 끄면 해당 변화가 바로 OptionView에 반영되어야 하지만,
            // 설정 앱에선 켜져 있고, OptionView에서 끈 후에, 다시 OptionView가 펼쳐지면 설정 앱 알림 정보가 반영되면 안 됨.
            if newValue == .active {
                Task {
                    await lnManager.getCurrentSettings()
                    lnManager.isAlarmOn = lnManager.isGranted
                    isUserAlarmOn = lnManager.isGranted
                }
            }
        }
        .customAlert(isPresented: $isSettingsAlert,
                     title: "알림허용이 되어있지 않습니다",
                     message: "설정으로 이동하여 알림 허용을 하시겠습니까?",
                     primaryButtonTitle: "허용",
                     primaryAction: {lnManager.openSettings()},
                     withCancelButton: true)
        
        
    }
    
    
}

struct ListTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("IMHyemin-Bold", size: 16))
    }
}

struct OptionView_Previews: PreviewProvider {
    static var previews: some View {
        OptionView(index: .constant(0), flag: .constant(1))
    }
}
