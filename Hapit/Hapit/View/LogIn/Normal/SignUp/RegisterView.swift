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
                        Rectangle()
                            .fill(.gray)
                            .frame(maxWidth: .infinity, maxHeight: 0.3)
                    }
                    
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
                
                VStack {
                    SecureField("Password", text: $pw)
                    Rectangle()
                        .fill(.gray)
                        .frame(maxWidth: .infinity, maxHeight: 0.3)
                }
                
                VStack {
                    SecureField("Password Check", text: $pwCheck)
                    Rectangle()
                        .fill(.gray)
                        .frame(maxWidth: .infinity, maxHeight: 0.3)
                }
                
                HStack {
                    VStack {
                        SecureField("Nickname", text: $nickName)
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
            
            Spacer().frame(height: 160)
            
            
            NavigationLink(destination: ToSView()) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.pink)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .overlay {
                        Text("완료")
                            .foregroundColor(.white)
                    }
            }
            .disabled(false)
        }
        .padding(.horizontal, 20)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
