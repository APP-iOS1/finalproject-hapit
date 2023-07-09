//
//  GuideText_15.swift
//  Hapit
//
//  Created by 김응관 on 2023/02/14.
//

import SwiftUI

struct RegisterGuideText: View {
    var fontSize: CGFloat
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("기본정보를")
                    .foregroundColor(Color.accentColor)
                Text("입력해주세요")
            }
            .font(.custom("IMHyemin-Bold", size: fontSize))
            Spacer()
        }
    }
}
