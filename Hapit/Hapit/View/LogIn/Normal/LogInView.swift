//
//  LogInView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct LogInView: View {
    
    @Namespace var topID
    @Namespace var bottomID
    
    @Binding var isFullScreen: String
    
    @State private var email: String = ""
    @State private var pw: String = ""
    
    @FocusState private var emailFocusField: Bool
    @FocusState private var pwFocusField: Bool
    
    @State private var logInResult: Bool = false
    @State private var verified: Bool = false
    
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var habitManager: HabitManager
    
    // ScrollView의 y값 찾아서 -> hidden 해보기
    // 키보드 높이만큼 뷰 올리는 방법..!
    
    var body: some View {
        NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        Group {
                            Image("logo")
                                .resizable()
                                .frame(height: 180)
                                .id(topID)
                            Spacer()
                        }
                        .padding(.bottom, 30)
                        
                        VStack(spacing: 20) {
                            VStack(spacing: 5) {
                                TextField("이메일", text: $email)
                                    .font(.custom("IMHyemin-Bold", size: 16))
                                    .focused($emailFocusField)
                                    .modifier(ClearTextFieldModifier())
                                Rectangle()
                                    .modifier(TextFieldUnderLineRectangleModifier(stateTyping: emailFocusField))
                            }
                            .frame(height: 40)
                            
                            VStack(spacing: 5) {
                                SecureField("비밀번호", text: $pw)
                                    .font(.custom("IMHyemin-Bold", size: 16))
                                    .focused($pwFocusField)
                                    .modifier(ClearTextFieldModifier())
                                Rectangle()
                                    .modifier(TextFieldUnderLineRectangleModifier(stateTyping: pwFocusField))
                            }
                            .frame(height: 40)
                        }
                        
                        HStack(alignment: .center, spacing: 5) {
                            if UserDefaults.standard.string(forKey: "state") ?? "" == "logOut" && verified {
                                Image(systemName: "exclamationmark.circle")
                                Text("이메일과 비밀번호가 일치하지 않습니다")
                                Spacer()
                            } else {
                                Text("이")
                                    .foregroundColor(.white)
                            }
                        }
                        .font(.custom("IMHyemin-Bold", size: 12))
                        .foregroundColor(.red)
                        .padding(.bottom, 20)
                        
                        Button(action: {
                            Task {
                                //이메일 또는 비밀번호를 입력하지 않았을 경우
                                if email == "" {
                                    emailFocusField = true
                                } else if pw == "" {
                                    pwFocusField = true
                                } else {
                                    do {
                                        try await authManager.login(with: email, pw)
                                        isFullScreen = "logIn"
                                        authManager.save(value: Key.logIn.rawValue, forkey: "state")
                                        verified = true
                                    } catch {
                                        isFullScreen = "logOut"
                                        authManager.save(value: Key.logOut.rawValue, forkey: "state")
                                        verified = true
                                        throw(error)
                                    }
                                }
                            }
                        }){
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.pink)
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                                .overlay {
                                    Text("로그인")
                                        .font(.custom("IMHyemin-Bold", size: 16))
                                        .foregroundColor(.white)
                                }
                        }
                        .padding(.bottom, 20)
                        
                        Group {
                            HStack {
                                Text("아직 회원이 아니신가요?")
                                    .font(.custom("IMHyemin-Bold", size: 16))
                                NavigationLink(destination: RegisterView(isFullScreen: $isFullScreen)){
                                    Text("회원가입")
                                        .font(.custom("IMHyemin-Bold", size: 16))
                                }
                            }
                        }
                        .padding(.bottom, 10)
                        .padding(.top, 10)
                        
                        Group {
                            VStack {
                                AppleLogIn()
                                //GoogleLogIn()
                            }
                        }
                    }
                .padding(.horizontal, 20)
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(isFullScreen: .constant("logOut"))
            .environmentObject(AuthManager())
    }
}
