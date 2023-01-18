//
//  NicknameModalView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/18.
//

import SwiftUI

struct NicknameModalView: View {
    @Binding var showModal: Bool
    @Binding var userNickname: String
    @State private var nickname = ""
    var body: some View {
        VStack {
            TextField("닉네임을 입력하세요.", text: $nickname)
                .autocorrectionDisabled()
                .padding()
                .frame(width: 350, height: 65)
                .border(.blue)
                .padding(.bottom, 10)
            
            // TODO: 공백 입력, 글자수 제한
            Button {
                userNickname = nickname
                showModal = false
            } label: {
                Text("저장")
                    .bold()
                    .foregroundColor(.white)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 15).fill(.blue))
            }

        }
    }
}

struct NicknameModalView_Previews: PreviewProvider {
    static var previews: some View {
        NicknameModalView(showModal: .constant(false), userNickname: .constant(""))
    }
}
