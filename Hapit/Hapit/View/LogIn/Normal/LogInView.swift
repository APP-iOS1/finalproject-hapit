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
                        TextField("Email", text: $email)
                            .focused($emailFocusField)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                        Rectangle()
                            .fill(.gray)
                            .frame(maxWidth: .infinity, maxHeight: 0.3)
                    }
                    
                    Spacer().frame(height: 22)
                    
                    VStack {
                        SecureField("Password", text: $pw)
                            .focused($pwFocusField)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                        Rectangle()
                            .fill(.gray)
                            .frame(maxWidth: .infinity, maxHeight: 0.3)
                    }
                }
                
                Spacer().frame(height: 20)
                
                Button(action: {
                    Task {
                        //이메일 또는 비밀번호를 입력하지 않았을 경우
                        if email == "" {
                            emailFocusField = true
                        } else if pw == "" {
                            pwFocusField = true
                        } else {
                            let loginResult = await authManager.login(with: email, pw)
                            
                            if loginResult {
                                isFullScreen = false
                            } else {
                                print("로그인 실패")
                            }
                        } 
                    }
                }){
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.pink)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .overlay {
                            Text("로그인")
                                .font(.custom("IMHyemin-Regular", size: 17))
                                .foregroundColor(.white)
                                .bold()
                        }
                }
                
                Spacer().frame(height: 15)
                
                HStack {
                    Text("아직 회원이 아니신가요?")
                        .font(.custom("IMHyemin-Regular", size: 17))
                    NavigationLink(destination: RegisterView(isFullScreen: $isFullScreen)) {
                        Text("회원가입")
                            .font(.custom("IMHyemin-Regular", size: 17))
                        // IMHyemin-Bold
                    }
                }
                
                Spacer().frame(height: 35)
                
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

//struct LogInView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogInView(isFullScreen: .constant(true))
//    }
//}
