//
//  SignUpView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var mailDuplicated: Bool = false
    @State private var emailTmp: String = ""
    
    var dupEmail: Bool {
        return email == emailTmp
    }
    
    @State private var pw: String = ""
    @State private var showPw: Bool = false
    
    @State private var pwCheck: String = ""
    @State private var showPwCheck: Bool = false
    
    @State private var nickName: String = ""
    @State private var nameCheck: Bool = false
    
    @State private var isSecuredPassword: Bool = true
    @State private var isSecuredCheckPassword: Bool = true
    
    @FocusState private var emailFocusField: Bool
    @FocusState private var pwFocusField: Bool
    @FocusState private var pwCheckFocusField: Bool
    @FocusState private var nickNameFocusField: Bool
    
    @State private var canGoNext: Bool = false
    @State private var isClicked: Bool = false
    
    @Binding var isFullScreen: Bool
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        VStack(spacing: 20) {

            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    
                    HStack() {
                        StepBar(nowStep: 1)
                            .padding(.leading, -8)
                        Spacer()
                    }
                    
                    // MARK: TITLE
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("기본정보를")
                                .foregroundColor(Color.accentColor)
                            Text("입력해주세요")
                        }
                        .font(.largeTitle)
                        .bold()
                        Spacer()
                    }
                    .padding(.bottom, 100)
                    //Spacer()
                    
                    VStack(spacing: 50) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                TextField("이메일을 입력해주세요.", text: $email)
                                    .focused($emailFocusField)
                                    .modifier(ClearTextFieldModifier())
                                
                                // email이 비어있지 않으면서, 형식이 올바를 때 체크 아이콘 띄움.
                                if !email.isEmpty && checkEmailType(string: email) {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20.5)
                                        .foregroundColor(.green)
                                }
                            } // HStack - TextField, Secured Image, Check Image
                            .frame(height: 30) // TextField가 있는 HStack의 height 고정 <- 아이콘 크기 변경 방지
                            
                            Rectangle()
                                .modifier(TextFieldUnderLineRectangleModifier(stateTyping: emailFocusField))
                            
                            //이메일 형식은 맞는데, 중복판정받았고, email이 중복판정받은 email로 쓰여있을 때
                            if !email.isEmpty && checkEmailType(string: email) && mailDuplicated && dupEmail {
                                HStack(alignment: .center, spacing: 5) {
                                    Image(systemName: "exclamationmark.circle")
                                    Text("이미 사용중인 이메일입니다.")
                                }
                                .foregroundColor(.red)
                                .font(.caption)
                            } else if !email.isEmpty && !checkEmailType(string: email) {
                                HStack(alignment: .center, spacing: 5) {
                                    Image(systemName: "exclamationmark.circle")
                                    Text("올바른 이메일 형식이 아닙니다.")
                                }
                                .foregroundColor(.red)
                                .font(.caption)
                            } else {
                                Text("") // TextField 자리 고정
                            }
                        }
                        .frame(height: 30)
                        
                        // MARK: 비밀번호 입력
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                // 비밀번호 숨김 아이콘일 때
                                if isSecuredPassword {
                                    SecureField("비밀번호를 입력해주세요.", text: $pw)
                                        .textContentType(.oneTimeCode)
                                        .textContentType(.newPassword)
                                        .focused($pwFocusField) // 커서가 올라가있을 때 상태를 저장.
                                        .modifier(ClearTextFieldModifier())
                                } else { // 비밀번호 보임 아이콘일 때
                                    TextField("비밀번호를 입력해주세요.", text: $pw)
                                        .focused($pwFocusField)
                                        .modifier(ClearTextFieldModifier())
                                }
                                
                                Button(action: {
                                    // 비밀번호 보임/숨김을 설정함.
                                    isSecuredPassword.toggle()
                                }) {
                                    Image(systemName: self.isSecuredPassword ? "eye.slash" : "eye")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20.5)
                                        .accentColor(.gray)
                                }
                                // password가 비어있지 않으면서, 6자리 이상일 때 체크 아이콘 띄움.
                                if !pw.isEmpty && checkPasswordType(password: pw) {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20.5)
                                        .foregroundColor(.green)
                                }
                            } // HStack - TextField, Secured Image, Check Image
                            .frame(height: 30) // TextField가 있는 HStack의 height 고정 <- 아이콘 크기 변경 방지

                            
                            Rectangle()
                                .modifier(TextFieldUnderLineRectangleModifier(stateTyping: pwFocusField))
                            
                            // 비밀번호 형식이 아닐 경우 경고 메시지
                            if !pw.isEmpty && !checkPasswordType(password: pw) {
                                HStack(alignment: .center, spacing: 5) {
                                    Image(systemName: "exclamationmark.circle")
                                    Text("영문, 숫자, 특수문자를 포함하여 8~20자로 작성해주세요.")
                                }
                                .foregroundColor(.red)
                                .font(.caption)
                            }
                            else {
                                Text("") // TextField 자리 고정
                            }
                        } // VStack - HStack과 밑줄 Rectangle
                        .frame(height: 30)
                        
                        
                        
                        // MARK: 비밀번호 확인 입력
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                // 비밀번호 숨김 아이콘일 때
                                if isSecuredCheckPassword {
                                    SecureField("비밀번호를 다시 입력해주세요.", text: $pwCheck)
                                        .textContentType(.oneTimeCode)
                                        .textContentType(.newPassword)
                                        .focused($pwCheckFocusField) // 커서가 올라가있을 때 상태를 저장.
                                        .modifier(ClearTextFieldModifier())
                                } else { // 비밀번호 보임 아이콘일 때
                                    TextField("비밀번호를 다시 입력해주세요", text: $pwCheck)
                                        .focused($pwCheckFocusField)
                                        .modifier(ClearTextFieldModifier())
                                }
                                
                                Button(action: {
                                    // 비밀번호 보임/숨김을 설정함.
                                    isSecuredCheckPassword.toggle()
                                }) {
                                    Image(systemName: self.isSecuredCheckPassword ? "eye.slash" : "eye")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20.5)
                                        .accentColor(.gray)
                                }
                                // password가 비어있지 않으면서, 6자리 이상일 때 체크 아이콘 띄움.
                                if !pwCheck.isEmpty && checkPasswordType(password: pwCheck) {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20.5)
                                        .foregroundColor(.green)
                                }
                            } // HStack - TextField, Secured Image, Check Image
                            .frame(height: 30) // TextField가 있는 HStack의 height 고정 <- 아이콘 크기 변경 방지
                            
                            Rectangle()
                                .modifier(TextFieldUnderLineRectangleModifier(stateTyping: pwCheckFocusField))
                            
                            
                            // 비밀번호 형식이 아닐 경우 경고 메시지
                            if pw != pwCheck && pw != "" && pwCheck != "" {
                                HStack(alignment: .center, spacing: 5) {
                                    Image(systemName: "exclamationmark.circle")
                                    Text("비밀번호가 일치하지 않습니다")
                                }
                                .foregroundColor(.red)
                                .font(.caption)
                            } else if pw != pwCheck && pw == "" {
                                HStack(alignment: .center, spacing: 5) {
                                    Image(systemName: "exclamationmark.circle")
                                    Text("비밀번호를 먼저 입력해주세요")
                                }
                                .foregroundColor(.red)
                                .font(.caption)
                            } else {
                                Text("") // TextField 자리 고정
                            }
                        } // VStack - HStack과 밑줄 Rectangle
                        .frame(height: 30)
                        
                        
                        // MARK: 닉네임 입력
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                TextField("닉네임을 입력해주세요.", text: $nickName)
                                    .focused($nickNameFocusField)
                                    .modifier(ClearTextFieldModifier())
                                
                                // email이 비어있지 않으면서, 형식이 올바를 때 체크 아이콘 띄움.
                                if !nickName.isEmpty && nickName.count >= 2 {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20.5)
                                        .foregroundColor(.green)
                                }
                                                         
                            } // HStack - TextField, Secured Image, Check Image
                            .frame(height: 30) // TextField가 있는 HStack의 height 고정 <- 아이콘 크기 변경 방지
                            
                            Rectangle()
                                .modifier(TextFieldUnderLineRectangleModifier(stateTyping: nickNameFocusField))
                            
                            if nickName != "" && nickName.count < 2 {
                                HStack(alignment: .center, spacing: 5) {
                                    Image(systemName: "exclamationmark.circle")
                                    Text("닉네임을 2글자 이상 입력해주세요")
                                }
                                .foregroundColor(.red)
                                .font(.caption)
                            } else {
                                Text("")
                            }
                        }
                        .frame(height: 30)
                    }
                    
                    Spacer()
                }
            }
            .padding(.top, 30)
                
            // MARK: 완료 버튼
            
            Button(action: {
                Task {
                    
                    authManager.isEmailDuplicated(email: email)
                    print(authManager.result)
                    nameCheck = authManager.isNicknameDuplicated(nickName: nickName)
                    
                    if mailDuplicated {
                        emailTmp = email
                        emailFocusField = true
                    }
                    
                    if nameCheck {
                        
                    }
                    canGoNext = isDuplicated() // false --> 다음으로 못감
                    isClicked = true
                    
                }
            }){
                Text("완료")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(isOk() ? .gray : Color.accentColor)
                    }
            }
            .disabled(isOk())
            .padding(.vertical, 5)
            .navigationDestination(isPresented: $canGoNext) {
                ToSView(isFullScreen: $isFullScreen, email: $email, pw: $pw, nickName: $nickName)
            }
            
            
            
            
            
            
            
//            Button(action: {
//                Task {
//                    isClicked.toggle()
//
//                    do {
//                        try await authManager.register(email: email, pw: pw, name: nickName)
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//                }
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
//                    isActive.toggle()
//                }
//            }){
//                if isClicked {
//                    ProgressView()
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background {
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(agreeAll ? Color.accentColor : .gray)
//                        }
//                } else {
//                    Text("가입하기")
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background {
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(agreeAll ? Color.accentColor : .gray)
//                        }
//                }
//            }
//            .navigationDestination(isPresented: $isActive) {
//                GetStartView(isFullScreen: $isFullScreen)
//            }
//        }

//            NavigationLink(destination: ToSView(isFullScreen: $isFullScreen, email: $email, pw: $pw, nickName: $nickName)) {
//
//                Text("완료")
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background {
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(isOk() ? .gray : Color.accentColor)
//                    }
//            }
//            .disabled(isOk())
//            .padding(.vertical, 5)

        }
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .padding(.horizontal, 20)
    }
    
    
    // 이메일 유효성 검증
    func checkEmailType(string: String) -> Bool {
        let emailFormula = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        
        return  NSPredicate(format: "SELF MATCHES %@", emailFormula).evaluate(with: string)
    }
    
    //비밀번호 유효성 검증
    func checkPasswordType(password: String) -> Bool {
        let passwordFormula = "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,20}$"
        
        return password.range(of: passwordFormula, options: .regularExpression) != nil
    }
    
    //다음단계로 넘어갈 수 있는지 검증해주는 함수
    func isOk() -> Bool {
        if pw == pwCheck && checkPasswordType(password: pw) && checkEmailType(string: email) && nickName != "" {
            return false
        } else {
            return true
        }
    }
    
    //이메일과 닉네임이 중복되지 않았는가를 검증해주어 -> 완료버튼 활성화 결정해주는 함수
    func isDuplicated() -> Bool {
        //mailDuplicated = true --> 중복
        if mailDuplicated || nameCheck {
            return false
        } else {
            return true
        }
    }
    
}

struct ClearTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .font(.subheadline)
    }
}

// MARK: - Modifier : TextField 아래 밑줄을 표현하기 위한 Rectangle 속성
struct TextFieldUnderLineRectangleModifier: ViewModifier {
    let stateTyping: Bool
    var padding: CGFloat = 20
    func body(content: Content) -> some View {
        content
            .frame(height: (stateTyping ? 1.5 : 1.0))
            .foregroundColor(stateTyping ? .accentColor : .gray)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(isFullScreen: .constant(true))
    }
}

