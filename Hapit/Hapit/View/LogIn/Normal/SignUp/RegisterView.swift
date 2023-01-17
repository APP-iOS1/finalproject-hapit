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
    
    //@Binding var step: Int
    var totalPage: Int = 3

    var body: some View {
        VStack {
            Group {
                HStack {
                    VStack {
                        TextField("Email", text: $email)
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
                
                Spacer().frame(height: 22)
                
                VStack {
                    SecureField("Password", text: $pw)
                    Rectangle()
                        .fill(.gray)
                        .frame(maxWidth: .infinity, maxHeight: 0.3)
                }
                
                Spacer().frame(height: 22)
                
                VStack {
                    SecureField("Password Check", text: $pwCheck)
                    Rectangle()
                        .fill(.gray)
                        .frame(maxWidth: .infinity, maxHeight: 0.3)
                }
                
                Spacer().frame(height: 22)
                
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
            
            Spacer().frame(height: 40)
            
            
            NavigationLink(destination: ToSView()) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.pink)
                    .frame(maxWidth: .infinity, maxHeight: 40)
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
