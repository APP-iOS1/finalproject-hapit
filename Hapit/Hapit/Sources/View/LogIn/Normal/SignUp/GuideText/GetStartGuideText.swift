//
//  GetStartGuideText.swift
//  Hapit
//
//  Created by 김응관 on 2023/02/14.
//

import SwiftUI

struct GetStartGuideText: View {
    var fontSize: CGFloat
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Hapit")
                    .foregroundColor(Color.accentColor)
                Text("회원가입 완료!")
            }
            .font(.custom("IMHyemin-Bold", size: fontSize))
            Spacer()
        }
    }
}
