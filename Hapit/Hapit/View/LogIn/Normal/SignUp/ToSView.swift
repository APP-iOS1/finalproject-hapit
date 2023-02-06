//
//  ToSView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct ToSView: View {
    @State private var agreeAll: Bool = false
    @State private var agreeService: Bool = false
    @State private var agreePrivate: Bool = false
    @State private var agreeAD: Bool = false
    
    @State private var isActive: Bool = false
    @State private var isClicked: Bool = false
    
    @Binding var isFullScreen: Bool
    
    @Binding var email: String
    @Binding var pw: String
    @Binding var nickName: String
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        VStack(spacing: 20) {
            HStack() {
                StepBar(nowStep: 2)
                    .padding(.leading, -8)
                Spacer()
            }
            .frame(height: 40)
            .padding(.top, -18)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Hapit")
                            .foregroundColor(Color.accentColor)
                        Text("이용 약관에")
                    }
                    Text("동의해주세요")
                }
                .font(.custom("IMHyemin-Bold", size: 34))
                Spacer()
            }
            
            Spacer()
            Spacer()
            
            Group {
                HStack {
                    Button(action: {
                        agreeAll.toggle()
                        
                        if agreeAll {
                            agreeService = true
                            agreePrivate = true
                            agreeAD = true
                        } else {
                            agreeService = false
                            agreePrivate = false
                            agreeAD = false
                        }
                    }){
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(agreeAll ? Color.accentColor : .gray)
                            .font(.title)
                    }
                    Text("약관 전체동의")
                        .font(.custom("IMHyemin-Bold", size: 22))
                    Spacer()
                }
                
                Divider()
                    .foregroundColor(.gray)
                
                Group {
                    HStack {
                        Button(action: {
                            agreeService.toggle()
                            isAllChecked(service: agreeService, privates: agreePrivate, ad: agreeAD)
                        }){
                            Image(systemName: "checkmark")
                                .foregroundColor(agreeService ? Color.accentColor : .gray)
                        }
                        Text("(필수) 서비스 이용약관 동의")
                            .font(.custom("IMHyemin-Regular", size: 16))
                        Spacer()
                        NavigationLink(destination: ServiceToS()){
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    HStack {
                        Button(action: {
                            agreePrivate.toggle()
                            isAllChecked(service: agreeService, privates: agreePrivate, ad: agreeAD)
                        }){
                            Image(systemName: "checkmark")
                                .foregroundColor(agreePrivate ? Color.accentColor : .gray)
                        }
                        Text("(필수) 개인정보 수집 및 이용동의")
                            .font(.custom("IMHyemin-Regular", size: 16))
                        Spacer()
                        NavigationLink(destination: PrivateToS()){
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    HStack {
                        Button(action: {
                            agreeAD.toggle()
                        }){
                            Image(systemName: "checkmark")
                                .foregroundColor(agreeAD ? Color.accentColor : .gray)
                        }
                        Text("(선택) E-mail 광고성 정보 수신동의")
                            .font(.custom("IMHyemin-Regular", size: 16))
                        Spacer()
                        NavigationLink(destination: ServiceToS()){
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .padding(.horizontal, 10)
                
                Spacer()
                
                // 회원가입 버튼을 누르면 progress view가 나타남
                // Fallback on earlier versions
                
                NavigationLink(destination: GetStartView(isFullScreen: $isFullScreen, email: $email, pw: $pw), isActive: $isActive) {
                    Button(action: {
                        isClicked = true
                        Task {
                            do {
                                try await authManager.register(email: email, pw: pw, name: nickName)
                            } catch {
                                throw(error)
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                            isActive.toggle()
                        }
                    }){
                        if isClicked {
                            ProgressView()
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(agreeAll ? Color.accentColor : .gray)
                                }
                        } else {
                            Text("가입하기")
                                .font(.custom("IMHyemin-Bold", size: 16))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(agreeAll ? Color.accentColor : .gray)
                                }
                        }
                    }
                    .disabled(!agreeAll)
                    .padding(.vertical, 5)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    func isAllChecked(service: Bool, privates: Bool, ad: Bool) {
        if service && privates {
            agreeAll = true
        } else {
            agreeAll = false
        }
    }
}

struct ToSView_Previews: PreviewProvider {
    static var previews: some View {
        ToSView(isFullScreen: .constant(false), email: .constant(""), pw: .constant(""), nickName: .constant(""))
    }
}
