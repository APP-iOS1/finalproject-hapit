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
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("logo")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 200)
                
                Spacer().frame(height: 120)
                
                Group {
                    VStack {
                        TextField("Email", text: $email)
                            .focused($emailFocusField)
                        Rectangle()
                            .fill(.gray)
                            .frame(maxWidth: .infinity, maxHeight: 0.3)
                    }
                    
                    Spacer().frame(height: 22)
                    
                    VStack {
                        SecureField("Password", text: $pw)
                            .focused($pwFocusField)
                        Rectangle()
                            .fill(.gray)
                            .frame(maxWidth: .infinity, maxHeight: 0.3)
                    }
                }
                
                Spacer().frame(height: 20)
                
                Button(action: {
                    if email == "" {
                        emailFocusField = true
                    } else if pw == "" {
                        pwFocusField = true
                    }
                    
                    isFullScreen = false
                }){
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.pink)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .overlay {
                            Text("로그인")
                                .foregroundColor(.white)
                                .bold()
                        }
                }
                
                Spacer().frame(height: 15)
                
                HStack {
                    Text("아직 회원이 아니신가요?")
                    NavigationLink(destination: RegisterView(isFullScreen: $isFullScreen)) {
                        Text("회원가입")
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
