//
//  GuideText_16.swift
//  Hapit
//
//  Created by 김응관 on 2023/02/14.
//

import SwiftUI

struct ToSGuideText: View {
    var fontSize: CGFloat
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Hapit")
                        .foregroundColor(Color.accentColor)
                    Text("이용 약관에")
                }
                Text("동의해주세요")
            }
            .font(.custom("IMHyemin-Bold", size: fontSize))
            Spacer()
        }
    }
}
