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
    @Binding var isAllRead: Bool
    
    var body: some View {
        ScrollView {
            // MARK: if - 메시지 함이 비었을 때
            if messageManager.messageArray.isEmpty {
                EmptyCellView(currentContentsType: .message)
                
                // MARK: else - 메시지가 한 개 이상 있을 때
            } else {
                ForEach(messageManager.messageArray) { msg in
                    VStack {
                        MessageCellView(isAllRead: $isAllRead, msg: msg)
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
        .customAlert(isPresented: $trash,
                     title: "전체 삭제 하시겠습니까?",
                     message: "메시지를 다시 볼 수 없어요",
                     primaryButtonTitle: "삭제",
                     primaryAction: { Task {
            for msg in messageManager.messageArray {
                try await messageManager.removeMessage(userID: userInfoManager.currentUserInfo?.id ?? "",
                                                       messageID: msg.id) }}},
                     withCancelButton: true)
    }
}

struct MessageFullscreenView_Previews: PreviewProvider {
    static var previews: some View {
        MessageFullscreenView(isAllRead: .constant(true))
    }
}
