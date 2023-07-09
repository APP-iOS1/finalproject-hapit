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
    
    @FocusState private var emailFocusField: Bool
    @FocusState private var pwFocusField: Bool
    
    @State private var logInResult: Bool = false
    @State private var verified: Bool = false
    
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var normalSignInManager: NormalSignInManager
    
    let deviceHeight = UIScreen.main.bounds.height
    
    var fontSize: CGFloat {
        if deviceHeight < CGFloat(700.0) {
            return 14
        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(820.0) {
            return 15
        } else if deviceHeight >= CGFloat(820.0) && deviceHeight < CGFloat(860.0) {
            return 16
        } else {
            return 17
        }
    }
    
    var errorFontSize: CGFloat {
        if deviceHeight < CGFloat(700.0) {
            return 10
        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(820.0) {
            return 11
        } else if deviceHeight >= CGFloat(820.0) && deviceHeight < CGFloat(860.0) {
            return 12
        } else {
            return 13
        }
    }
    
    var frameSize: CGFloat {
        if deviceHeight < CGFloat(700.0) {
            return 28
        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(820.0) {
            return 29
        } else if deviceHeight >= CGFloat(820.0) && deviceHeight < CGFloat(860.0) {
            return 30
        } else {
            return 31
        }
    }

    var stackSpacing: CGFloat {
        if deviceHeight < CGFloat(700.0) {
            return 10
        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(820.0) {
            return 12
        } else if deviceHeight >= CGFloat(820.0) && deviceHeight < CGFloat(860.0) {
            return 14
        } else {
            return 16
        }
    }
    
    // 화면비율: 1/20 : 1/50 : 1/50
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    
                    if #available(iOS 16, *) {
                        if deviceHeight < CGFloat(700.0) {
                            Image("new_logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.bottom, geo.size.height / 10)
                                .padding(.horizontal, 20)
                                .padding(.top, 70)
                        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(820.0) {
                            Image("new_logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.bottom, geo.size.height / 10)
                                .padding(.horizontal, 20)
                                .padding(.top, 70)
                        } else if deviceHeight >= CGFloat(820.0) && deviceHeight < CGFloat(860.0) {
                            Image("new_logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.bottom, geo.size.height / 10)
                                .padding(.horizontal, 10)
                                .padding(.top, 106)
                        } else {
                            Image("new_logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.bottom, geo.size.height / 10)
                                .padding(.horizontal, 10)
                                .padding(.top, 126)
                        }
                    } else {
                        if deviceHeight < CGFloat(700.0) {
                            Image("new_logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.bottom, geo.size.height / 13)
                                .padding(.horizontal, 20)
                                .padding(.top, 5)
                        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(820.0) {
                            Image("new_logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.bottom, geo.size.height / 11)
                                .padding(.horizontal, 20)
                                .padding(.top, 10)
                        } else if deviceHeight >= CGFloat(820.0) && deviceHeight < CGFloat(860.0) {
                            Image("new_logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.bottom, geo.size.height / 9)
                                .padding(.horizontal, 10)
                                .padding(.top, 25)
                        } else {
                            Image("new_logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.bottom, geo.size.height / 8)
                                .padding(.horizontal, 10)
                                .padding(.top, 30)
                        }
                    }
                    
                    Group {
                        VStack(spacing: 25) {
                            VStack() {
                                TextField("이메일", text: $email)
                                    .keyboardType(.emailAddress)
                                    .font(.custom("IMHyemin-Bold", size: fontSize))
                                    .focused($emailFocusField)
                                    .modifier(ClearTextFieldModifier())
                                Rectangle()
                                    .modifier(TextFieldUnderLineRectangleModifier(stateTyping: emailFocusField))
                            }
                            .frame(height: frameSize)
                            
                            VStack() {
                                SecureField("비밀번호", text: $pw)
                                    .font(.custom("IMHyemin-Bold", size: fontSize))
                                    .focused($pwFocusField)
                                    .modifier(ClearTextFieldModifier())
                                    .padding(.bottom, 0.2)
                                Rectangle()
                                    .modifier(TextFieldUnderLineRectangleModifier(stateTyping: pwFocusField))
                            }
                            .frame(height: frameSize)
                        }
                        
                        HStack(alignment: .center, spacing: 5) {
                            if UserDefaults.standard.string(forKey: "state") ?? "" == "logOut" && verified {
                                Image(systemName: "exclamationmark.circle")
                                Text("이메일과 비밀번호가 일치하지 않습니다")
                                Spacer()
                            } else {
                                Text("")
                                    .foregroundColor(.clear)
                            }
                        }
                        .font(.custom("IMHyemin-Bold", size: errorFontSize))
                        .foregroundColor(.red)
                        .padding(.bottom, 15)
                    }
                    .disableAutocorrection(true)
                    
                        Button(action: {
                            Task {
                                //이메일 또는 비밀번호를 입력하지 않았을 경우
                                if email == "" {
                                    emailFocusField = true
                                } else if pw == "" {
                                    pwFocusField = true
                                } else {
                                    do {
                                        try await normalSignInManager.login(with: email, pw)
                                        
                                        //2.3 로그인 상태 변경
                                        normalSignInManager.loggedIn = "logIn"
                                        //2.4 로그인 상태 UserDefaults에 저장
                                        normalSignInManager.save(value: Key.logIn.rawValue, forkey: "state")
                                        //2.5 로그인 방법 UserDefaults에 저장
                                        normalSignInManager.save(value: LoginMethod.general.rawValue, forkey: "loginMethod")
                                        verified = true
                                        
                                        let localNickname = try await authManager.getNickName(uid: authManager.firebaseAuth.currentUser?.uid ?? "")
                                        
                                        UserDefaults.standard.set(localNickname, forKey: "localNickname")
                                    } catch {
                                        // 로그인 과정 or 이메일 불러오는 과정에서 오류 발생 시
                                        normalSignInManager.loggedIn = "logOut"
                                        normalSignInManager.save(value: Key.logOut.rawValue, forkey: "state")
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
                                        .font(.custom("IMHyemin-Bold", size: fontSize))
                                        .foregroundColor(.white)
                                }
                        }
                        .padding(.bottom, geo.size.height / 50)
                        
                        Group {
                            HStack {
                                Text("아직 회원이 아니신가요?")
                                    .font(.custom("IMHyemin-Bold", size: fontSize))
                                NavigationLink(destination: RegisterView()){
                                    Text("회원가입")
                                        .font(.custom("IMHyemin-Bold", size: fontSize))
                                }
                            }
                        }
                        .padding(.bottom, geo.size.height / 20)
                        
                        Group {
                            VStack(alignment: .center) {
                                HStack(spacing: geo.size.width / 8) {
                                    AppleLogIn()
                                    GoogleLogIn()
                                    KakaoLogIn()
                                }
                            }
                        }
                        Spacer()
                        //.padding(.bottom, geo.size.height / 20)
                }
                .ignoresSafeArea(.keyboard)
                .padding(.horizontal, 20)
            }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
            .environmentObject(AuthManager())
            .environmentObject(HabitManager())
    }
}
