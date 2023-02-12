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

    @Binding var email: String
    @Binding var pw: String
    
    // 화면비율 1/4 : 1/12.5 : 1/50
    var body: some View {
        GeometryReader { geo in
            VStack() {
                HStack() {
                    StepBar(nowStep: 3)
                        .padding(.leading, -8)
                    Spacer()
                }
                .frame(height: 30)
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hapit")
                            .foregroundColor(Color.accentColor)
                        Text("회원가입 완료!")
                    }
                    .font(.custom("IMHyemin-Bold", size: 34))
                    Spacer()
                }
                .padding(.bottom, geo.size.height / 4)
                
                Spacer()
                
                Image("fourbears")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 310, maxHeight: 170)
                    .padding(.vertical, geo.size.height / 12.5)
                
                Button {
                    Task {
                        do {
                            try await authManager.login(with: email, pw)
                            authManager.loggedIn = "logIn"
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
                .padding(.vertical, geo.size.height / 50)
                //.padding(.vertical, 5)
            }
            .padding(.horizontal, 20)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct GetStartView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartView(email: .constant(""), pw: .constant(""))
    }
}
