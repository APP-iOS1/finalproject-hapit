//
//  OptionView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/31.
//

import SwiftUI

struct OptionView: View {
    @EnvironmentObject var authManager: AuthManager
    @Binding var isFullScreen: Bool
    
    var body: some View {
        VStack {
            List {
                NavigationLink {
                    
                } label: {
                    Text("해핏에 대해서")
                        .modifier(ListTextModifier())
                }.listRowSeparator(.hidden)
                
                NavigationLink {
                    
                } label: {
                    Text("오픈소스 라이선스")
                        .modifier(ListTextModifier())
                }.listRowSeparator(.hidden)
                
                NavigationLink {
                    
                } label: {
                    Text("이용약관")
                        .modifier(ListTextModifier())
                }.listRowSeparator(.hidden)
                
                NavigationLink {
                    
                } label: {
                    Text("개인정보 처리방침")
                        .modifier(ListTextModifier())
                }.listRowSeparator(.hidden)
                
                NavigationLink {
                    
                } label: {
                    Text("크레딧")
                        .modifier(ListTextModifier())
                }.listRowSeparator(.hidden)
                
            }
            .listStyle(PlainListStyle())
            
            // TODO: 로그아웃 alert 띄우기
            Button {
                Task {
                    do {
                        try await authManager.logOut()
                        isFullScreen = true
                    } catch {
                        throw(error)
                    }
                }
            } label: {
                Text("로그아웃")
                    .font(.custom("IMHyemin-Regular", size: 16))
                    .foregroundColor(.gray)
                    .frame(width: 350, height: 50)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(.gray))
                    .padding()
            }
            
            HStack {
                Spacer()
                
                Button {
                    // TODO: 회원탈퇴 기능 추가
                } label: {
                    Text("회원탈퇴")
                        .font(.custom("IMHyemin-Regular", size: 16))
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 350)
            .padding(.bottom)
        }
    }
}

struct ListTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("IMHyemin-Bold", size: 16))
            .foregroundColor(.black)
    }
}

struct OptionView_Previews: PreviewProvider {
    static var previews: some View {
        OptionView(isFullScreen: .constant(true))
    }
}
