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
    
    @Binding var isFullScreen: Bool
    
    var body: some View {
        VStack(spacing: 20) {

            HStack() {
                StepBar(nowStep: 2)
                    .padding(.leading, -8)
                Spacer()
            }
            .padding(.top, 30)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Hapit")
                            .foregroundColor(Color.accentColor)
                        Text("이용 약관에")
                    }
                    Text("동의해주세요")
                }
                .font(.largeTitle)
                .bold()
                Spacer()
            }
            
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
                        .font(.title2)
                        .bold()
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
                        Spacer()
                        NavigationLink(destination: ServiceToS()){
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .padding(.horizontal, 10)
                
                Spacer()
                Spacer()
                
                NavigationLink(destination: GetStartView(isFullScreen: $isFullScreen)) {
                    
                    Text("가입하기")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(agreeAll ? Color.accentColor : .gray)
                        }
                }
                .disabled(!agreeAll)
                .padding(.vertical, 5)
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
        ToSView(isFullScreen: .constant(false))
    }
}
