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
        ZStack {
            ScrollView {
                if messageManager.messageArray.isEmpty {
                    VStack {
                        Text("현재 도착한 메시지가 없습니다.")
                    }.frame(maxWidth: .infinity)
                } else {
                    ForEach(messageManager.messageArray) { msg in
                        MessageCellView(msg: msg)
                    }
                }
            }
        }
        .background(Color("BackgroundColor"))
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
