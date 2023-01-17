//
//  LoginView.swift
//  Hapit
//
//  Created by 추현호 on 2023/01/17.
//



import SwiftUI
//import Firebase
//import GoogleSignIn
import _AuthenticationServices_SwiftUI

// MARK: - Extension View
/// 키보드 밖 화면 터치 시 키보드 사라지는 함수를 선언하기 위한 extension 입니다.
extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct LoginView: View {
    
    @Binding var isFirstLaunching: Bool
    
    @EnvironmentObject var loginModel: AppleLoginViewModel
    @EnvironmentObject var authManager: GoogleAuthManager
    @EnvironmentObject private var signupViewModel: SignUpViewModel
    @Environment(\.dismiss) private var dismiss

    @State var email = ""
    @State var password = ""
    @FocusState var isInFocusEmail: Bool
    @FocusState var isInFocusPassword: Bool
    @State private var isLoggedInFailed = false
    @State private var isLoggedInSucceed = false


    
    @State var navStack = NavigationPath()
    
    //MARK: - 로그인 함수
    private func logInWithEmailPassword() {
        Task {
            await signupViewModel.requestUserLogin(withEmail: email, withPassword: password)
            
            if signupViewModel.currentUser?.userEmail != nil {
                isLoggedInSucceed = true
                isLoggedInFailed = false
                dismiss()
                signupViewModel.fetchUserInfo(user: signupViewModel.currentUser!)
                
                
                print("로그인 성공 - 이메일: \(signupViewModel.currentUser?.userEmail ?? "???")")
            } else {
                isLoggedInFailed = true
                print("로그인 실패")
            }
        }
    }
    
    var body: some View {
        NavigationStack(path: $navStack) {
            VStack {
                Spacer()
                
                // 로고자리
                VStack(alignment: .center) {
                    ZStack{
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 100, height: 100)
                            .overlay(
                                        Circle()
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                        Image(systemName: "person.bust.fill")
                            .padding()
                    }
                    Text("MANTRA")
                }
                .padding()
                .font(.largeTitle)
                .bold()
                // 로고자리
                //Image("logo")
//                .resizable()
//                .frame(maxWidth: .infinity, maxHeight: 200)
                
                Spacer()
                
                // MARK: - 이메일 입력
                VStack {
                    
                    HStack {
                        Text("이메일")
                            .bold()
                            .padding(.trailing, -8)
                        Spacer()
                    }
                    .padding(.leading, 35)
                    .padding(.bottom, 3)
                    .font(.title3)
                    
                    HStack(alignment: .center) {
                        
                        Rectangle()
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                            .opacity(0.1)
                            .frame(width: 300, height: 50)
                            .overlay(
                                HStack {
                                    TextField("이메일", text: $email)
                                        .disableAutocorrection(true)
                                        .textInputAutocapitalization(.never)
                                        .padding()
                                }
                            )
                    }
                }
                .padding()
                
                // MARK: - 비밀번호 입력
                VStack {
                    
                    HStack {
                        Text("비밀번호")
                            .bold()
                            .padding(.trailing, -8)
                        Spacer()
                    }
                    .padding(.leading, 35)
                    .padding(.bottom, 3)
                    .font(.title3)
                    
                    HStack(alignment: .center) {
                        
                        Rectangle()
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                            .opacity(0.1)
                            .frame(width: 300, height: 50)
                            .overlay(
                                HStack {
                                    SecureField("비밀번호", text: $password)
                                        .disableAutocorrection(true)
                                        .textInputAutocapitalization(.never)
                                        .padding()
                                }
                            )
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                                
                VStack{
                    Button {
                        logInWithEmailPassword()
                        
                        if signupViewModel.loginRequestState == .loggingIn {
                            
                        } else {
                            
                            if isLoggedInSucceed {
                                                            
                                print("로그인 버튼 \(isFirstLaunching)")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    isFirstLaunching.toggle()
                                })
                            }
                        }

                    } label: {
                        Text("이메일로 로그인")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                    }
                    .disabled(email.isEmpty || password.isEmpty)
                    
                    HStack() {
                        
                        NavigationLink(value: "") {
                            Text("회원가입")
                                .font(.subheadline)
                                .foregroundColor(.accentColor)
                        }
                        .navigationDestination(for: String.self) { value in
                            
                            SignUpView(navStack: $navStack)
                        }
                        .navigationBarBackButtonHidden(true)
                        
                    
                    }
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 40, trailing: 0))
                    
                    Spacer()
                    
                    Divider()

                    
                    SignInWithAppleButton { (request) in
                        loginModel.nonce = randomNonceString()
                        request.requestedScopes = [.email, .fullName]
                        request.nonce = sha256(loginModel.nonce)
                    } onCompletion: { (result) in
                        switch result{
                        case .success(let user):
                            print("success")
                            guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                                print("error with firebase")
                                return
                            }
                            loginModel.authenticate(credential: credential)
                            isFirstLaunching.toggle()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(width: 310, height: 50)

                    
                    GoogleSignInButton()
                        .cornerRadius(15)
                        .frame(width: 320)
                        .onTapGesture {
                            authManager.signIn()
                        }
                    
                    //카카오 로그인 버튼
                    
                } // Buttons VStack
                Spacer()
            } // VStack
        } // NavigationStack
    }
}

//MARK: - 구글로그인 버튼

struct GoogleSignInButton: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
    
    private var button = GIDSignInButton()
    
    func makeUIView(context: Context) -> GIDSignInButton {
        button.colorScheme = colorScheme == .dark ? .dark : .light
        return button
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        button.colorScheme = colorScheme == .dark ? .dark : .light
    }
}


struct LoginView_Previews: PreviewProvider {
    
    @Binding var isFirstLaunching: Bool
    
    static var previews: some View {
        LoginView(isFirstLaunching: .constant(false))
            .environmentObject(SignUpViewModel())
    }
}

