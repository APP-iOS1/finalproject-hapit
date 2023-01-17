//
//  SignUpView.swift
//  Hapit
//
//  Created by 추현호 on 2023/01/17.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    
    @Binding var navStack: NavigationPath
    
    @State var email = ""
    @State var password = ""
    @State var passwordCheck = ""
    @State var name = ""
    @FocusState var isInFocusEmail: Bool
    @FocusState var isInFocusPassword: Bool
    @FocusState var isInFocusPasswordCheck: Bool
    @FocusState var isInFocusName: Bool
    
    @State private var isSecuredPassword = true
    @State private var isSecuredPasswordCheck = true
    @State private var isDuplicated = false
    @State private var isNotDuplicated = false
    
    @State var isSignUpSucced = false
    
    @State private var showBlankAlert: Bool = false
    
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    // MARK: - 이메일 형식 인증
    /// 이메일 형식 abc@email.com 을 검증하는 함수입니다.
    
    func verifyEmailType(string: String) -> Bool {
        let emailFormula = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        
        return  NSPredicate(format: "SELF MATCHES %@", emailFormula).evaluate(with: string)
    }
    
    // MARK: - 비밀번호 형식 인증
    /// 비밀번호 형식을 검증하는 함수입니다.
    func verifyPasswordType(password: String) -> Bool {
        let passwordFormula = "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,20}$"
        
        return password.range(of: passwordFormula, options: .regularExpression) != nil
    }
    
    // MARK: - 이메일 중복 검사
    /// 이메일 중복을 검사하는 함수입니다.
    func verifyEmailDuplicated() {
        Task {
            if await signUpViewModel.isEmailDuplicated(currentUserEmail: email) {
                isDuplicated = true
                isNotDuplicated = false
            } else {
                isDuplicated = false
                isNotDuplicated = true
            }
        }
    }
    
    
    // MARK: - 회원가입 성공 유무 및 계정 생성
    private func signUpWithEmailPassword() {
        Task {
            if await signUpViewModel.createUser(email: email, password: password, name: name) {
                navStack = .init() // 루트뷰(로그인뷰)로 돌아가기
                print("회원가입 성공")
            } else {
                print("회원가입 실패")
            }
        }
    }
    // MARK: - Body
    var body: some View {
        
        VStack {
            ScrollView(showsIndicators: false) {
                
                HStack {
                    Text("반가워요!")
                    Spacer()
                }
                .font(.largeTitle)
                .bold()
                .padding()
                
                // MARK: - 이메일 입력
                VStack {
                    HStack {
                        Text("이메일")
                            .font(.title3)
                            .bold()
                            .padding(.trailing, -8)
                        
                        Text("을 입력해주세요")
                            .font(.title3)
                        
                        Spacer()
                    }
                    .padding(.bottom, 3)
                    
                    HStack {
                        
                        Rectangle()
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                            .opacity(0.1)
                            .frame(width: 300, height: 50)
                            .overlay(
                                HStack {
                                    TextField("이메일 (\("checkit@email.com"))", text: $email)
                                        .disableAutocorrection(true)
                                        .textInputAutocapitalization(.never)
                                        .padding()
                                }
                            )
                        
                        if !email.isEmpty && verifyEmailType(string: email) {
                            
                            if signUpViewModel.emailDuplicationState == .duplicated {
                                
                                HStack {
                                    
                                    Button {
                                        verifyEmailDuplicated()
                                    } label: {
                                        Text("중복 확인")
                                            .font(.footnote)
                                            .foregroundColor(.accentColor)
                                            .padding(5)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.accentColor, lineWidth: 1)
                                            )
                                            .background(Color.white)
                                    }
                                    .frame(minWidth: 53, minHeight: 50)
                                    
                                    

                                }
                            } else if signUpViewModel.emailDuplicationState == .checking {
                                
                                HStack {
                                    
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                        .frame(height: 50)
                                        .padding(.leading, 5)
                                    
                                    Spacer()
                                }
                            } else {
                                
                                HStack {
                                    
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25)
                                        .foregroundColor(.accentColor)
                                    
                                    Spacer()
                                }
                            } // else
                        } else {
                            Spacer()
                        }// else
                        
                        // Spacer()
                    } // HStack
                    //.frame(height: 30)
                    //.padding(.trailing, 20)
                    
                    if !email.isEmpty && !verifyEmailType(string: email) {
                        HStack(alignment: .center, spacing: 5) {
                            Text("올바른 이메일 형식을 입력해주세요")
                            Spacer()
                        }
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 3)
                    } else {
                        Text("")
                            .font(.caption)
                            .padding(.top, 3)
                    }
                    
                } // VStack
                .padding()
                
                // MARK: - 비밀번호 입력
                VStack {
                    HStack {
                        Text("비밀번호")
                            .font(.title3)
                            .bold()
                            .padding(.trailing, -8)
                        
                        Text("를 입력해주세요")
                            .font(.title3)
                        
                        Spacer()
                    }
                    .padding(.bottom, 3)
                    
                    
                    HStack() {
                        
                        Rectangle()
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                            .opacity(0.1)
                            .frame(width: 300, height: 50)
                            .overlay(
                                
                                HStack {
                                    
                                    if isSecuredPassword {
                                        SecureField("비밀번호를 입력해주세요", text: $password)
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .padding()
                                    } else {
                                        TextField("비밀번호를 입력해주세요", text: $password)
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .padding()
                                    }
                                    
                                    Button {
                                        isSecuredPassword.toggle()
                                    } label: {
                                        Image(systemName: self.isSecuredPassword ? "eye.slash" : "eye")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20.5)
                                            .foregroundColor(.gray)
                                            .padding(.horizontal)
                                    }
                                    
                                } // HStack
                            ) // overlay
                        
                        if !password.isEmpty && verifyPasswordType(password: password) {
                            Image(systemName: "checkmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20.5)
                                .foregroundColor(.accentColor)
                        }
                        
                        Spacer()
                    } // HStack
                    
                    if !password.isEmpty && !verifyPasswordType(password: password) {
                        HStack {
                            Text("영문, 숫자, 특수문자를 포함하여 8~20자로 작성해주세요")
                            Spacer()
                        }
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 3)
                    } else {
                        
                        HStack {
                            Text(" ")
                            Spacer()
                        }
                        .font(.caption)
                        .padding(.top, 3)
                    }
                    
                    HStack() {
                        
                        Rectangle()
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                            .opacity(0.1)
                            .frame(width: 300, height: 50)
                            .overlay(
                                HStack {
                                    
                                    if isSecuredPasswordCheck {
                                        SecureField("한 번 더 입력해주세요", text: $passwordCheck)
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .padding()
                                    } else {
                                        TextField("한 번 더 입력해주세요", text: $passwordCheck)
                                            .disableAutocorrection(true)
                                            .textInputAutocapitalization(.never)
                                            .padding()
                                    }
                                    
                                    Button {
                                        isSecuredPasswordCheck.toggle()
                                    } label: {
                                        Image(systemName: self.isSecuredPasswordCheck ? "eye.slash" : "eye")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20.5)
                                            .foregroundColor(.gray)
                                            .padding(.horizontal)
                                    }
                                    
                                } // HStack
                            ) // overlay
                        
                        if !passwordCheck.isEmpty && password == passwordCheck && verifyPasswordType(password: passwordCheck) {
                            Image(systemName: "checkmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20.5)
                                .foregroundColor(.accentColor)
                            
                        }
                        
                        Spacer()
                    } // HStack
                    
                    if !passwordCheck.isEmpty && password != passwordCheck {
                        HStack(alignment: .center, spacing: 5) {
                            Text("비밀번호가 일치하지 않습니다")
                            Spacer()
                        }
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 3)
                    } else {
                        HStack(alignment: .center, spacing: 5) {
                            Text(" ")
                            Spacer()
                        }
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 3)
                    }
                    
                } // VStack : 비밀번호 입력
                .padding(.horizontal)
                
                // MARK: - 이름 입력
                VStack {
                    
                    HStack {
                        Text("이름")
                            .font(.title3)
                            .bold()
                            .padding(.trailing, -8)
                        
                        Text("을 입력해주세요")
                            .font(.title3)
                        
                        Spacer()
                    }
                    .padding(.bottom, 3)
                    
                    HStack() {
                        
                        Rectangle()
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                            .opacity(0.1)
                            .frame(width: 300, height: 50)
                            .overlay(
                                HStack {
                                    TextField("이름을 입력해주세요", text: $name)
                                        .disableAutocorrection(true)
                                        .textInputAutocapitalization(.never)
                                        .padding()
                                }
                            )
                        
                        if !email.isEmpty && verifyEmailType(string: email) {
                            
                        }
                        
                        Spacer()
                    } // HStack
                }
                .padding()
                
                Spacer()
                Spacer()
                
                
            } // ScrollView
            
            Divider()
            
            Button {
                Task {
                    if signUpViewModel.emailDuplicationState == .notDuplicated {
                        showBlankAlert.toggle()
                        signUpWithEmailPassword()
                    } else {
                        verifyEmailDuplicated()
                    }
                }
            } label: {
                
                if signUpViewModel.authenticationState == .authenticating {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .frame(height: 40)
                } else {
                    Text("회원가입")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 360, height: 50)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
                }
            } // Button
            .disabled(email.isEmpty || password.isEmpty || passwordCheck.isEmpty || password != passwordCheck || !verifyEmailType(string: email) || !verifyPasswordType(password: password) || signUpViewModel.emailDuplicationState != .notDuplicated || name.isEmpty ? true : false)
            .padding()

        } // VStack
        //.navigationBarTitle("회원가입", .inline)
    } // Body
} // View
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpView(navStack: .constant(NavigationPath()))
                .environmentObject(SignUpViewModel())
        }
    }
}
