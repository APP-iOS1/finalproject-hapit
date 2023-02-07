//
//  MessageFullscreenView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/18.
//

import SwiftUI

struct MessageFullscreenView: View {
    @EnvironmentObject var userInfoManager: UserInfoManager
    @EnvironmentObject var messageManager: MessageManager
    
    var body: some View {
        ScrollView {
            if messageManager.messageArray.isEmpty {
                VStack {
                    Text("현재 도착한 메시지가 없습니다.")
                        .font(.custom("IMHyemin-Bold", size: 20))
                    Image(systemName: "envelope.open")
                        .resizable()
                        .frame(width: 200)
                }.frame(maxWidth: .infinity)
            } else {
                ForEach(messageManager.messageArray) { msg in
                    VStack {
                        MessageCellView(msg: msg)
                        Divider()
                    }
                }
            }
        }
        .task {
            messageManager.fetchMessage(userID: userInfoManager.currentUserInfo?.id ?? "")
        }
    }
}

struct MessageFullscreenView_Previews: PreviewProvider {
    static var previews: some View {
        MessageFullscreenView()
    }
}
