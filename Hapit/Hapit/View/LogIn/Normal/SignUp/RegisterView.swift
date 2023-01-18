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
    @State private var pwCheck: String = ""
    @State private var nickName: String = ""
  

    @FocusState private var emailFocusField: Bool
    @FocusState private var pwFocusField: Bool
    @FocusState private var pwCheckFocusField: Bool
    @FocusState private var nickNameFocusField: Bool
    
    @Binding var isFullScreen: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer().frame(height: 20)
            
            HStack() {
                StepBar(nowStep: 1)
                    .padding(.leading, -8)
                Spacer()
            }
            
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
            
            Spacer().frame(height: 30)
            
            Group {
                HStack {
                    VStack {
                        TextField("Email", text: $email)
                            .focused($emailFocusField)
                        Rectangle()
                            .fill(.gray)
                            .frame(maxWidth: .infinity, maxHeight: 0.3)
                    }
                    
                    Button(action: {
                        
                    }){
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.gray)
                            .frame(maxWidth: 80, maxHeight: 30)
                            .overlay {
                                Text("중복확인")
                                    .foregroundColor(.white)
                            }
                    }
                }
                
                // 이메일 쳤는데 타입이 잘못된 경우
                if emailFocusField {
                    if !email.isEmpty && !checkEmailType(string: email) {
                        HStack(spacing: 5) {
                            Text("이메일 형식이 올바르지 않습니다")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                VStack {
                    SecureField("Password", text: $pw)
                        .focused($pwFocusField)
                    Rectangle()
                        .fill(.gray)
                        .frame(maxWidth: .infinity, maxHeight: 0.3)
                    
                    if pwFocusField {
                        if !checkPasswordType(password: pw) && !pw.isEmpty {
                            Text("영문, 숫자, 특수문자를 포함하여 8~20자로 작성해주세요")
                                .foregroundColor(.red)
                                .font(.footnote)
                        }
                    }
                }
                
                VStack {
                    SecureField("Password Check", text: $pwCheck)
                        .focused($pwCheckFocusField)
                    Rectangle()
                        .fill(.gray)
                        .frame(maxWidth: .infinity, maxHeight: 0.3)
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

                HStack {
                    VStack {
                        TextField("Nickname", text: $nickName)
                            .focused($nickNameFocusField)
                        Rectangle()
                            .fill(.gray)
                            .frame(maxWidth: .infinity, maxHeight: 0.3)
                    }

                    Spacer().frame(width: 10)

                    Button(action: {}){
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.gray)
                            .frame(maxWidth: 80, maxHeight: 30)
                            .overlay {
                                Text("중복확인")
                                    .foregroundColor(.white)
                            }
                    }
                }
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            
            
            Spacer().frame(height: 160)
            
            
            NavigationLink(destination: ToSView(isFullScreen: $isFullScreen)) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isOk() ? .gray : .pink)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .overlay {
                        Text("완료")
                            .foregroundColor(.white)
                    }
            }
            .disabled(isOk())
        }
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
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterView()
//    }
//}
