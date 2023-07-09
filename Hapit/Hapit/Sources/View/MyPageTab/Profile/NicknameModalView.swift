//
//  NicknameModalView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/18.
//

import SwiftUI

struct NicknameModalView: View {
    @Binding var showNicknameModal: Bool
    @Binding var userNickname: String
    @State private var nickname = ""
    @State private var isValid = false
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        VStack {
//            HStack {
//                Spacer()
//                Button {
//                    showModal = false
//                } label: {
//                    Image(systemName: "xmark")
//                        .resizable()
//                        .frame(width: 20, height: 20)
//                }
//                .padding()
//            }
            
            Spacer()
            
            Text("닉네임 수정")
                .font(.custom("IMHyemin-Bold", size: 22))

            TextField("닉네임을 입력하세요.", text: $nickname)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .font(.custom("IMHyemin-Regular", size: 17))
                .padding()
                .frame(width: 350, height: 65)
                .border(Color.accentColor)
                .padding(.bottom, 10)
                .onChange(of: nickname) { value in
                    if nickname.count > 0 && nickname.count < 10 {
                        self.isValid = true
                    } else {
                        self.isValid = false
                    }
                }
            
            // TODO: 공백 입력, 글자수 제한
            Button {
                Task {
                    // UserDefaults nickname 업데이트
                    if isValid {
                        userNickname = nickname
                        //UserDefaults.standard.set(userNickname, forKey: "localNickname")
                        
                        do {
                            let current = authManager.firebaseAuth
                            try await authManager.updateUserNickName(uid: current.currentUser?.uid ?? "", nickname: userNickname)
                        } catch {
                            throw(error)
                        }
                        dismiss()
                        showNicknameModal = false
                    }
                }
            } label: {
                Text("저장")
                    .font(.custom("IMHyemin-Bold", size: 17))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.accentColor))
            }
            .disabled(!isValid)
            
            Spacer()
        }
    }
}

