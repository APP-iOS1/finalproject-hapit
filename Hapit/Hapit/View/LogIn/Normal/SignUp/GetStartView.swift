//
//  GetStartView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/18.
//

import SwiftUI

struct GetStartView: View {
    
    @Binding var isFullScreen: Bool
    @EnvironmentObject var authManager: AuthManager
    
    @Binding var email: String
    @Binding var pw: String
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack() {
                StepBar(nowStep: 3)
                    .padding(.leading, -8)
                Spacer()
            }
            .padding(.top, 30)
            
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
                        authManager.isLoggedin = true
                        isFullScreen = false
                    } catch {
                        authManager.isLoggedin = false
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
    }
}

//struct GetStartView_Previews: PreviewProvider {
//    static var previews: some View {
//        GetStartView()
//    }
//}
