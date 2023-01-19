//
//  SignUpView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""

    
    @State private var pw: String = ""
    @State private var showPw: Bool = false
    
    @State private var pwCheck: String = ""
    @State private var showPwCheck: Bool = false
    
    @State private var nickName: String = ""
    
    @FocusState private var emailFocusField: Bool
    @FocusState private var pwFocusField: Bool
    @FocusState private var pwCheckFocusField: Bool
    @FocusState private var nickNameFocusField: Bool
    
    @Binding var isFullScreen: Bool
    
    var body: some View {
            VStack(spacing: 20) {
                
                Spacer().frame(height: 10)
                
                HStack() {
                    StepBar(nowStep: 1)
                        .padding(.leading, -8)
                    Spacer()
                }
                
                // MARK: TITLE
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("기본정보를")
                            .foregroundColor(.pink)
                        Text("입력해주세요")
                    }
                    .font(.largeTitle)
                    .bold()
                    Spacer()
                }
                
                Spacer().frame(height: 20)
                
                
                Group {
                    HStack {
                        VStack {
                            //MARK: 이메일 입력
                            TextField("이메일을 입력해주세요", text: $email)
                                .focused($emailFocusField)
                                .overlay {
                                    HStack {
                                        Spacer()
                                        if checkEmailType(string: email) {
                                            Image(systemName: "checkmark.circle")
                                                .foregroundColor(.green)
                                        }
                                    }
                                }
                            Rectangle()
                                .fill(.gray)
                                .frame(width: .infinity, height: 1)
                            //maxWidth: 가로가 가변적일때 최대 크기 한정
                            //width 없을 때 maxWidth 정해주면 0으로 처리해서,...
                        }
                        
                        Button(action: {
                            
                        }){
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.gray)
                                .frame(maxWidth: 80, maxHeight: 25)
                                .overlay {
                                    Text("중복확인")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                        }
                    }

                    // MARK: 이메일 형식 체크
                    Rectangle()
                        .fill(.white)
                        .frame(width: .infinity, height: 5)
                        .overlay {
                            if emailFocusField {
                                if !email.isEmpty && !checkEmailType(string: email) {
                                    Text("올바른 이메일 형식이 아닙니다")
                                        .foregroundColor(.red)
                                        .font(.footnote)
                                }
                            }
                        }
                
                    // MARK: 비밀번호 입력
                    VStack {
                        SecureField("비밀번호 (영문, 숫자, 특수문자 포함 8~20자 이내)", text: $pw)
                            .textContentType(.oneTimeCode)
                            .focused($pwFocusField)
                            .overlay {
                                HStack {
                                    Spacer()
                                    if checkPasswordType(password: pw) {
                                        Image(systemName: "checkmark.circle")
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                        Rectangle()
                            .fill(.gray)
                            .frame(width: .infinity, height: 1)
                    }
                    
                    // MARK: 비밀번호 형식 체크
                    Rectangle()
                        .fill(.white)
                        .frame(width: .infinity, height: 5)
                        .overlay {
                            if pwFocusField {
                                if !checkPasswordType(password: pw) && !pw.isEmpty {
                                    Text("영문, 숫자, 특수문자를 포함하여 8~20자로 작성해주세요")
                                        .foregroundColor(.red)
                                        .font(.footnote)
                                }
                            }
                        }
                
                    // MARK: 비밀번호 확인 입력
                    VStack {
                        SecureField("비밀번호를 한 번 더 똑같이 입력해주세요", text: $pwCheck)
                            .textContentType(.oneTimeCode)
                            .focused($pwCheckFocusField)
                            .overlay {
                                HStack {
                                    Spacer()
                                    if pw == pwCheck && pw != "" && pwCheck != "" {
                                        Image(systemName: "checkmark.circle")
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                        Rectangle()
                            .fill(.gray)
                            .frame(width: .infinity, height: 1)
                    }
                    
                    // MARK: 비밀번호 확인 체크
                    Rectangle()
                        .fill(.white)
                        .frame(width: .infinity, height: 5)
                        .overlay {
                            if pwCheckFocusField {
                                if pw != pwCheck && pw != "" {
                                    Text("비밀번호가 일치하지 않습니다")
                                        .foregroundColor(.red)
                                        .font(.footnote)
                                } else if pw != pwCheck && pw == "" {
                                    Text("비밀번호를 먼저 입력해주세요")
                                        .foregroundColor(.red)
                                        .font(.footnote)
                                }
                            }
                        }
                
                    // MARK: 닉네임 입력
                    HStack {
                        VStack {
                            TextField("닉네임을 입력해주세요", text: $nickName)
                                .textContentType(.oneTimeCode)
                                .focused($nickNameFocusField)
                            Rectangle()
                                .fill(.gray)
                                .frame(width: .infinity, height: 1)
                        }
                        
                        Spacer().frame(width: 10)
                        
                        Button(action: {}){
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.gray)
                                .frame(maxWidth: 80, maxHeight: 25)
                                .overlay {
                                    Text("중복확인")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                        }
                    }
                    .padding(.bottom)
                }
                
                
                Spacer().frame(height: 80)
                
                // MARK: 완료 버튼
                NavigationLink(destination: ToSView(isFullScreen: $isFullScreen)) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isOk() ? .gray : .pink)
                        .frame(width: .infinity, height: 50)
                        .overlay {
                            Text("완료")
                                .foregroundColor(.white)
                        }
                }
                .disabled(isOk())
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 20)
            .onAppear {
                Task {
                    emailFocusField = true
                }
        }
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

}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterView()
//    }
//}
