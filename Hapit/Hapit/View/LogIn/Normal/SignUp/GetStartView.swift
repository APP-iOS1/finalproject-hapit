//
//  GetStartView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/18.
//

import SwiftUI

struct GetStartView: View {
    
    @EnvironmentObject var keyboardManager: KeyboardManager
    @EnvironmentObject var authManager: AuthManager
    
    @Binding var isFullScreen: String
    @Binding var email: String
    @Binding var pw: String
    
    var body: some View {
        VStack(spacing: 10) {
            
            HStack() {
                StepBar(nowStep: 3)
                    .padding(.leading, -8)
                Spacer()
            }
            .frame(height: 40)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hapit")
                        .foregroundColor(Color.accentColor)
                    Text("회원가입 완료!")
                }
                .font(.custom("IMHyemin-Bold", size: 34))
                Spacer()
            }
            
            Spacer()
            
            Image("fourbears")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 310, maxHeight: 170)
            
            Spacer()
            
            Button {
                Task {
                    do {
                        try await authManager.login(with: email, pw)
                        isFullScreen = "logIn"
                        authManager.save(value: Key.logIn.rawValue, forkey: "state")
                    } catch {
                        throw(error)
                    }
                }
            } label: {
                Text("시작하기")
                    .font(.custom("IMHyemin-Bold", size: 16))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.accentColor)
                    }
            }
            .padding(.vertical, 5)
        }
        .padding(.horizontal, 20)
        .navigationBarBackButtonHidden(true)
    }
}

struct GetStartView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartView(isFullScreen: .constant("logIn"), email: .constant(""), pw: .constant(""))
    }
}
