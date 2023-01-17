//
//  GoogleLogIn.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct GoogleLogIn: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.indigo)
            .frame(maxWidth: .infinity, maxHeight: 30)
            .overlay {
                Text("구글 로그인")
                    .foregroundColor(.white)
            }
    }
}

struct GoogleLogIn_Previews: PreviewProvider {
    static var previews: some View {
        GoogleLogIn()
    }
}
