//
//  LogInView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct LogInView: View {
    @State private var email: String = ""
    @State private var pw: String = ""
    @Binding var isFullScreen: Bool
    
    @FocusState private var emailFocusField: Bool
    @FocusState private var pwFocusField: Bool
    
    @State private var logInResult: Bool = false
    @State private var verified: Bool = false
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 200)
                
                Spacer().frame(height: 120)
                
                Group {
                    VStack {
                        TextField("이메일", text: $email)
                            .font(.custom("IMHyemin-Regular", size: 16))
                            .focused($emailFocusField)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                        Rectangle()
                            .modifier(TextFieldUnderLineRectangleModifier(stateTyping: emailFocusField))
                    }
                    
                    Spacer().frame(height: 20)
                    
                    VStack {
                        SecureField("비밀번호", text: $pw)
                            .font(.custom("IMHyemin-Regular", size: 16))
                            .focused($pwFocusField)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                        Rectangle()
                            .modifier(TextFieldUnderLineRectangleModifier(stateTyping: pwFocusField))
                    }
                }
                
                Spacer().frame(height: 20)
                
                HStack() {
                    if !logInResult && verified {
                        Image(systemName: "exclamationmark.circle")
                        Text("이메일과 비밀번호가 일치하지 않습니다")
                        Spacer()
                    } else {
                        Text("")
                    }
                }
                .font(.custom("IMHyemin-Regular", size: 12))
                .foregroundColor(.red)
                
                Spacer().frame(height: 20)
                
                Button(action: {
                    Task {
                        //이메일 또는 비밀번호를 입력하지 않았을 경우
                        if email == "" {
                            emailFocusField = true
                        } else if pw == "" {
                            pwFocusField = true
                        } else {
                            verified = true
                            logInResult = await authManager.login(with: email, pw)
                            
                            if logInResult {
                                isFullScreen = false
                            }
                        } 
                    }
                }){
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.pink)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .overlay {
                            Text("로그인")
                                .font(.custom("IMHyemin-Bold", size: 16))
                                .foregroundColor(.white)
                        }
                }
                
                Group {
                    Spacer().frame(height: 15)
                    
                    HStack {
                        Text("아직 회원이 아니신가요?")
                            .font(.custom("IMHyemin-Regular", size: 16))
                        NavigationLink(destination: RegisterView(isFullScreen: $isFullScreen)) {
                            Text("회원가입")
                                .font(.custom("IMHyemin-Regular", size: 16))
                        }
                    }
                    
                    Spacer().frame(height: 35)
                }
                
                Group {
                    HStack {
                        AppleLogIn()
                        GoogleLogIn()
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(isFullScreen: .constant(true))
    }
}
