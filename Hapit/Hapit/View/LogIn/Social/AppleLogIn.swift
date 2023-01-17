//
//  AppleLogIn.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct AppleLogIn: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(.black)
            .frame(maxWidth: .infinity, maxHeight: 30)
            .overlay {
                Text("애플 로그인")
                    .foregroundColor(.white)
            }
    }
}

struct AppleLogIn_Previews: PreviewProvider {
    static var previews: some View {
        AppleLogIn()
    }
}
