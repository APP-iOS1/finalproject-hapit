//
//  KakaoLogIn.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct KakaoLogIn: View {
    @EnvironmentObject var kakaoSignInManager: KakaoSignInManager
    
    var body: some View {
        Button(action: {
            Task {
                await kakaoSignInManager.kakaoSignIn()
            }
        }){
            Image("kakaobtn")
                .mask(Circle())
                .frame(width: 44, height: 44)
        }
    }
}
