//
//  LogInView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct LogInView: View {
    
    @EnvironmentObject var keyboardManager: KeyboardManager
    
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
    
    // 화면비율: 1/20 : 1/50 : 1/50
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack() {
                    Spacer()
                    
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, geo.size.height / 30)
                        .edgesIgnoringSafeArea(keyboardManager.isVisible ? .bottom : [])
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        VStack() {
                            TextField("이메일", text: $email)
                                .keyboardType(.emailAddress)
                                .font(.custom("IMHyemin-Bold", size: 16))
                                .focused($emailFocusField)
                                .modifier(ClearTextFieldModifier())
                            Rectangle()
                                .modifier(TextFieldUnderLineRectangleModifier(stateTyping: emailFocusField))
                        }
                        .frame(height: 40)
                        
                        VStack() {
                            SecureField("비밀번호", text: $pw)
                                .font(.custom("IMHyemin-Bold", size: 16))
                                .focused($pwFocusField)
                                .modifier(ClearTextFieldModifier())
                                .padding(.bottom, 0.2)
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
                    .padding(.bottom, 15)
                    
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
                                    
                                    //2.3 로그인 상태 변경
                                    authManager.loggedIn = "logIn"
                                    //2.4 로그인 상태 UserDefaults에 저장
                                    authManager.save(value: Key.logIn.rawValue, forkey: "state")
                                    //2.5 로그인 방법 UserDefaults에 저장
                                    authManager.loginMethod(value: LoginMethod.general.rawValue, forkey: "loginMethod")
                                    verified = true
                                } catch {
                                    // 로그인 과정 or 이메일 불러오는 과정에서 오류 발생 시
                                    authManager.loggedIn = "logOut"
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
                    .padding(.bottom, geo.size.height / 50)
                    
                    Group {
                        HStack {
                            Text("아직 회원이 아니신가요?")
                                .font(.custom("IMHyemin-Bold", size: 16))
                            NavigationLink(destination: RegisterView()){
                                Text("회원가입")
                                    .font(.custom("IMHyemin-Bold", size: 16))
                            }
                        }
                    }
                    .padding(.bottom, geo.size.height / 50)
                    
                    Group {
                        VStack(alignment: .center) {
                            HStack(spacing: geo.size.width / 8) {
                                AppleLogIn()
                                GoogleLogIn()
                                KakaoLogIn()
                            }
                        }
                    }
                    .padding(.bottom, geo.size.height / 50)
                }
                .padding(.horizontal, 20)
                .edgesIgnoringSafeArea(.top)
                .ignoresSafeArea(.keyboard)
                .disableAutocorrection(true)
            }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
            .environmentObject(AuthManager())
            .environmentObject(HabitManager())
            .environmentObject(KeyboardManager())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
        LogInView()
            .environmentObject(AuthManager())
            .environmentObject(HabitManager())
            .environmentObject(KeyboardManager())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
        LogInView()
            .environmentObject(AuthManager())
            .environmentObject(HabitManager())
            .environmentObject(KeyboardManager())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Plus"))
        LogInView()
            .environmentObject(AuthManager())
            .environmentObject(HabitManager())
            .environmentObject(KeyboardManager())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        LogInView()
            .environmentObject(AuthManager())
            .environmentObject(HabitManager())
            .environmentObject(KeyboardManager())
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 mini"))
        LogInView()
            .environmentObject(AuthManager())
            .environmentObject(HabitManager())
            .environmentObject(KeyboardManager())
            .previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
        LogInView()
            .environmentObject(AuthManager())
            .environmentObject(HabitManager())
            .environmentObject(KeyboardManager())
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
