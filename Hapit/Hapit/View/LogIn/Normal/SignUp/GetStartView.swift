//
//  GetStartView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/18.
//

import SwiftUI

struct GetStartView: View {
    
    @EnvironmentObject var keyboardManager: KeyboardManager
    @EnvironmentObject var authManager: AuthManager

    @Binding var email: String
    @Binding var pw: String
    
    var deviceWidth = UIScreen.main.bounds.size.width
    var deviceHeight = UIScreen.main.bounds.size.height
    
    // 화면비율 1/4 : 1/12.5 : 1/50
    var body: some View {
        GeometryReader { geo in
            VStack {
                Group {
                    // 2. iOS 버전을 기준으로 StepBar 분기처리
                    // 3. 분기 내에서 디바이스 높이를 기준으로 GuideText 분기처리
                    if #available(iOS 16.0, *) {
                        if deviceHeight < CGFloat(700.0) {
                            StepBar_16(step: 1, frameSize: 25, fontSize: 15)
                            GetStartGuideText(fontSize: 26)
                        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(750.0) {
                            StepBar_16(step: 1, frameSize: 27, fontSize: 17)
                            GetStartGuideText(fontSize: 22)
                        } else if deviceHeight >= CGFloat(750.0) && deviceHeight < CGFloat(860.0) {
                            StepBar_16(step: 1, frameSize: 28, fontSize: 18)
                            GetStartGuideText(fontSize: 34)
                        } else {
                            StepBar_16(step: 1, frameSize: 30, fontSize: 20)
                            GetStartGuideText(fontSize: 34)
                        }
                    } else {
                        if deviceHeight < CGFloat(700.0) {
                            StepBar_15(step: 1, frameSize: 25, fontSize: 15)
                                .padding(.top, -20)
                            GetStartGuideText(fontSize: 26)
                                .padding(.top, -50)
                        } else if deviceHeight >= CGFloat(700.0) && deviceHeight < CGFloat(750.0) {
                            StepBar_15(step: 1, frameSize: 27, fontSize: 17)
                            GetStartGuideText(fontSize: 27)
                        } else if deviceHeight >= CGFloat(750.0) && deviceHeight < CGFloat(860.0) {
                            StepBar_15(step: 1, frameSize: 28, fontSize: 18)
                            GetStartGuideText(fontSize: 28)
                        } else {
                            StepBar_15(step: 1, frameSize: 30, fontSize: 20)
                            GetStartGuideText(fontSize: 34)
                        }
                    }
                }
                .padding(.bottom, geo.size.height / 4)
                
                Spacer()
                
                Image("fourbears")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 310, maxHeight: 170)
                    .padding(.vertical, geo.size.height / 12.5)
                
                Button {
                    Task {
                        do {
                            try await authManager.login(with: email, pw)
                            authManager.loggedIn = "logIn"
                            authManager.save(value: Key.logIn.rawValue, forkey: "state")
                        } catch {
                            throw(error)
                        }
                    }
                } label: {
                    Text("시작하기")
                        .font(.custom("IMHyemin-Bold", size: 16))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.accentColor)
                        }
                }
                .padding(.vertical, geo.size.height / 50)
                //.padding(.vertical, 5)
            }
            .padding(.horizontal, 20)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct GetStartView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartView(email: .constant(""), pw: .constant(""))
    }
}
