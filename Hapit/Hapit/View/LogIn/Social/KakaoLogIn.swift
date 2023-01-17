//
//  KakaoLogIn.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct KakaoLogIn: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(.yellow)
            .frame(maxWidth: .infinity, maxHeight: 30)
            .overlay {
                Text("카카오 로그인")
                    .foregroundColor(.white)
            }
    }
}

struct KakaoLogIn_Previews: PreviewProvider {
    static var previews: some View {
        KakaoLogIn()
    }
}
