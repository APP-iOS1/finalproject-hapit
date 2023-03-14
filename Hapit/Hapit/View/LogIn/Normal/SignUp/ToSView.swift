//
//  ToSView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct ToSView: View {
    @EnvironmentObject var keyboardManager: KeyboardManager
    
    @State private var agreeAll: Bool = false
    @State private var agreeService: Bool = false
    @State private var agreePrivate: Bool = false
    @State private var agreeAD: Bool = false
    
    @State private var isActive: Bool = false
    @State private var isClicked: Bool = false
    
    @Binding var email: String
    @Binding var pw: String
    @Binding var nickName: String
    
    @EnvironmentObject var normalSignInManager: NormalSignInManager
    
    var deviceHeight = UIScreen.main.bounds.size.height
    
    var fontSize: CGFloat {
        if deviceHeight < CGFloat(700.0) {
            return 14
        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(820.0) {
            return 15
        } else if deviceHeight >= CGFloat(820.0) && deviceHeight < CGFloat(860.0) {
            return 16
        } else {
            return 17
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Group {
                    // 1. iOS 버전을 기준으로 StepBar 분기처리
                    // 2. 분기 내에서 디바이스 높이를 기준으로 GuideText 분기처리
                    if #available(iOS 16.0, *) {
                        if deviceHeight < CGFloat(700.0) {
                            StepBar_16(step: 2, frameSize: 23, fontSize: 13)
                            ToSGuideText(fontSize: 23)
                                .padding(.top, -30)
                        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(820.0) {
                            StepBar_16(step: 2, frameSize: 25, fontSize: 15)
                            ToSGuideText(fontSize: 25)
                                .padding(.top, -30)
                        } else if deviceHeight >= CGFloat(820.0) && deviceHeight < CGFloat(860.0) {
                            StepBar_16(step: 2, frameSize: 28, fontSize: 18)
                            ToSGuideText(fontSize: 30)
                                .padding(.top, -30)
                        } else {
                            StepBar_16(step: 2, frameSize: 30, fontSize: 20)
                            ToSGuideText(fontSize: 34)
                                .padding(.top, -30)
                        }
                    } else {
                        if deviceHeight < CGFloat(700.0) {
                            StepBar_15(step: 2, frameSize: 23, fontSize: 13)
                            ToSGuideText(fontSize: 23)
                                .padding(.top, -30)
                            Spacer()
                        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(820.0) {
                            StepBar_15(step: 2, frameSize: 25, fontSize: 15)
                            ToSGuideText(fontSize: 25)
                                .padding(.top, -30)
                        } else if deviceHeight >= CGFloat(820.0) && deviceHeight < CGFloat(860.0) {
                            StepBar_15(step: 2, frameSize: 28, fontSize: 18)
                            ToSGuideText(fontSize: 30)
                                .padding(.top, -30)
                        } else {
                            StepBar_15(step: 2, frameSize: 30, fontSize: 20)
                            ToSGuideText(fontSize: 34)
                                .padding(.top, -30)
                        }
                    }
                }
                .padding(.bottom, geo.size.height / 16)
                
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
                                .foregroundColor(agreeAll ? Color.accentColor : Color("GrayFontColor"))
                                .font(.title)
                        }
                        Text("약관 전체동의")
                            .font(.custom("IMHyemin-Bold", size: 22))
                        Spacer()
                    }
                    
                    Divider()
                        .foregroundColor(Color("GrayFontColor"))
                    
                    Group {
                        HStack {
                            Button(action: {
                                agreeService.toggle()
                                isAllChecked(service: agreeService, privates: agreePrivate, ad: agreeAD)
                            }){
                                Image(systemName: "checkmark")
                                    .foregroundColor(agreeService ? Color.accentColor : Color("GrayFontColor"))
                            }
                            Text("(필수) 서비스 이용약관 동의")
                                .font(.custom("IMHyemin-Regular", size: 16))
                            Spacer()
                            NavigationLink(destination: ServiceToS(urlToLoad: "https://placid-llama-50b.notion.site/badf083532df4e6999e987e374b4a469")){
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
                                    .foregroundColor(agreePrivate ? Color.accentColor : Color("GrayFontColor"))
                            }
                            Text("(필수) 개인정보 수집 및 이용동의")
                                .font(.custom("IMHyemin-Regular", size: 16))
                            Spacer()
                            NavigationLink(destination: PrivateToS(urlToLoad: "https://placid-llama-50b.notion.site/e210f96695484a59b8b850f16f0a76a5")){
                                Image(systemName: "chevron.right")
                            }
                        }
                        .padding(.horizontal, 10)
                        
                        HStack {
                            Button(action: {
                                agreeAD.toggle()
                            }){
                                Image(systemName: "checkmark")
                                    .foregroundColor(agreeAD ? Color.accentColor : Color("GrayFontColor"))
                            }
                            Text("(선택) E-mail 광고성 정보 수신동의") // 크게 중요해보이지 않음
                                .font(.custom("IMHyemin-Regular", size: 16))
                            Spacer()
                            NavigationLink(destination: ServiceToS(urlToLoad: "https://placid-llama-50b.notion.site/78c7981b89a94d3d81fa5d29d31b43dc")){
                                Image(systemName: "chevron.right")
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, geo.size.height / 50)
                    
                    // 회원가입 버튼을 누르면 progress view가 나타남
                    // Fallback on earlier versions
                    
                    // 약관에 관한 글들은 어디서 가져오는지
                    // 주의해야할 점이 있는지
                    // 서비스 이용약관/개인정보 처리 --> 개인정보포털사이트, 검색해서 상식적으로 이해하는 정도로만 넣어도 문제될일은 없을 것이다..
                    
                    NavigationLink(destination: GetStartView(email: $email, pw: $pw), isActive: $isActive) {
                        Button(action: {
                            isClicked = true
                            Task {
                                do {
                                    try await normalSignInManager.register(email: email, pw: pw, name: nickName)
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
                                            .fill(agreeAll ? Color.accentColor : Color("GrayFontColor"))
                                    }
                            } else {
                                Text("가입하기")
                                    .font(.custom("IMHyemin-Bold", size: fontSize))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(agreeAll ? Color.accentColor : Color("GrayFontColor"))
                                    }
                            }
                        }
                    }
                    .disabled(!agreeAll)
                    .padding(.vertical, geo.size.height / 50)
                }
            }
            .padding(.horizontal, 20)
        }
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
        ToSView(email: .constant(""), pw: .constant(""), nickName: .constant(""))
    }
}
