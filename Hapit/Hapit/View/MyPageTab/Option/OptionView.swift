//
//  OptionView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/31.
//

import SwiftUI
import FirebaseAuth

struct OptionView: View {
    @EnvironmentObject var authManager: AuthManager
    @Binding var isFullScreen: Bool
    @Binding var index: Int
    @State private var isLogoutAlert = false
    
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
                    Text("만든 사람들")
                        .modifier(ListTextModifier())
                }.listRowSeparator(.hidden)
                
            }
            .listStyle(PlainListStyle())
            
            // TODO: 로그아웃 alert 띄우기
            Button {
                isLogoutAlert = true
            } label: {
                Text("로그아웃")
                    .font(.custom("IMHyemin-Regular", size: 16))
                    .foregroundColor(.gray)
                    .frame(width: 350, height: 50)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(.gray))
                    .padding()
            }
            .customAlert(isPresented: $isLogoutAlert,
                         title: "",
                         message: "로그아웃하시겠습니까?",
                         primaryButtonTitle: "로그아웃",
                         primaryAction: { Task {
                do {
                    isFullScreen = true
                    index = 0
                    try await authManager.logOut()
                } catch {
                    throw(error)
                }
            } },
                         withCancelButton: true)
            
            HStack {
                Spacer()
                
                Button {
                    // TODO: 회원탈퇴 기능 추가
                    Task {
                        do {
                            try await authManager.deleteUser(uid: authManager.firebaseAuth.currentUser?.uid ?? "")
                            isFullScreen = true
                            index = 0
                        } catch {
                            throw(error)
                        }
                    }
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
        OptionView(isFullScreen: .constant(true), index: .constant(0))
    }
}
