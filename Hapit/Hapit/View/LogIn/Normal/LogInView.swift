//
//  LogInView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct LogInView: View {
    @State private var id: String = ""
    @State private var pw: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("logo")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 200)
                
                Spacer().frame(height: 120)
                
                Group {
                    VStack {
                        TextField("ID", text: $id)
                        Rectangle()
                            .fill(.gray)
                            .frame(maxWidth: .infinity, maxHeight: 0.3)
                    }
                    
                    Spacer().frame(height: 22)
                    
                    VStack {
                        SecureField("Password", text: $pw)
                        Rectangle()
                            .fill(.gray)
                            .frame(maxWidth: .infinity, maxHeight: 0.3)
                    }
                }
                
                Spacer().frame(height: 20)
                
                Button(action: {
                    
                }){
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.pink)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .overlay {
                            Text("로그인")
                        }
                }
                
                Spacer().frame(height: 15)
                
                HStack {
                    Text("아직 회원이 아니신가요?")
                    NavigationLink(destination: SignUpView().navigationTitle("회원가입").navigationBarTitleDisplayMode(.large)) {
                        Text("회원가입")
                    }
                }
                
                Spacer().frame(height: 35)
                
                Group {
                    KakaoLogIn()
                    AppleLogIn()
                    GoogleLogIn()
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
