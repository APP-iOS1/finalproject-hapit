//
//  GetStartView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/18.
//

import SwiftUI

struct GetStartView: View {
    @EnvironmentObject var normalSignInManager: NormalSignInManager
    @EnvironmentObject var authManager: AuthManager

    @Binding var email: String
    @Binding var pw: String
    
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
    
    // 화면비율 1/4 : 1/12.5 : 1/50
    var body: some View {
        GeometryReader { geo in
            VStack {
                Group {
                    // 1. iOS 버전을 기준으로 StepBar 분기처리
                    // 2. 분기 내에서 디바이스 높이를 기준으로 GuideText 분기처리
                    if #available(iOS 16.0, *) {
                        if deviceHeight < CGFloat(700.0) {
                            StepBar_16(step: 3, frameSize: 23, fontSize: 13)
                                .padding(.top, 45)
                            GetStartGuideText(fontSize: 23)
                                .padding(.top, -30)
                        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(820.0) {
                            StepBar_16(step: 3, frameSize: 25, fontSize: 15)
                                .padding(.top, 45)
                            GetStartGuideText(fontSize: 25)
                                .padding(.top, -30)
                        } else if deviceHeight >= CGFloat(820.0) && deviceHeight < CGFloat(860.0) {
                            StepBar_16(step: 3, frameSize: 28, fontSize: 18)
                                .padding(.top, 45)
                            GetStartGuideText(fontSize: 30)
                                .padding(.top, -30)
                        } else {
                            StepBar_16(step: 3, frameSize: 30, fontSize: 20)
                                .padding(.top, 45)
                            GetStartGuideText(fontSize: 34)
                                .padding(.top, -30)
                        }
                    } else {
                        if deviceHeight < CGFloat(700.0) {
                            StepBar_15(step: 3, frameSize: 23, fontSize: 13)
                            GetStartGuideText(fontSize: 23)
                                .padding(.top, -30)
                            Spacer()
                        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(820.0) {
                            StepBar_15(step: 3, frameSize: 25, fontSize: 15)
                            GetStartGuideText(fontSize: 25)
                                .padding(.top, -30)
                        } else if deviceHeight >= CGFloat(820.0) && deviceHeight < CGFloat(860.0) {
                            StepBar_15(step: 3, frameSize: 28, fontSize: 18)
                            GetStartGuideText(fontSize: 30)
                                .padding(.top, -30)
                        } else {
                            StepBar_15(step: 3, frameSize: 30, fontSize: 20)
                            GetStartGuideText(fontSize: 34)
                                .padding(.top, -30)
                        }
                    }
                }
                .padding(.bottom, geo.size.height / 16)
                //.padding(.bottom, geo.size.height / 4)
                
                Spacer()
                
                Image("fourbears")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 310, maxHeight: 170)
                    .padding(.vertical, geo.size.height / 12.5)
                
                Button {
                    Task {
                        do {
                            try await normalSignInManager.login(with: email, pw)
                            let localNickname = try await authManager.getNickName(uid: authManager.firebaseAuth.currentUser?.uid ?? "")
                            UserDefaults.standard.set(localNickname, forKey: "localNickname")
                            normalSignInManager.loggedIn = "logIn"
                            normalSignInManager.save(value: Key.logIn.rawValue, forkey: "state")
                            normalSignInManager.save(value: Newby.newby.rawValue, forkey: "newby")
                        } catch {
                            throw(error)
                        }
                    }
                } label: {
                    Text("시작하기")
                        .font(.custom("IMHyemin-Bold", size: fontSize))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.accentColor)
                        }
                }
                .padding(.vertical, geo.size.height / 50)
            }
            .padding(.horizontal, 20)
            .navigationBarBackButtonHidden(true)
        }
    }
}
