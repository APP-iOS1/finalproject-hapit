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
    @State private var trash = false
    
    var body: some View {
        ScrollView {
            if messageManager.messageArray.isEmpty {
                VStack {
                    Text("현재 도착한 메시지가 없습니다.")
                        .font(.custom("IMHyemin-Bold", size: 20))
                    Image(systemName: "envelope.open")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
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
        .toolbar {
            Button {
                trash.toggle()
            } label: {
                Image(systemName: "trash")
            }
        }
        .alert("전체 삭제 하시겠습니까?", isPresented: $trash) {
            Button("삭제", role: .destructive) {
                Task {
                    for msg in messageManager.messageArray {
                        try await messageManager.removeMessage(userID: userInfoManager.currentUserInfo?.id ?? "", messageID: msg.id)
                    }
                }
            }
            Button("취소", role: .cancel) {  }
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
