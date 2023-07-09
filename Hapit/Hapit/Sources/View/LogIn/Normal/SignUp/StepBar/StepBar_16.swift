//
//  StepBar_16.swift
//  Hapit
//
//  Created by 김응관 on 2023/02/13.
//

import SwiftUI

@available(iOS 16, *)
struct StepBar_16: View {
    var step: Int
    var frameSize: CGFloat
    var fontSize: CGFloat
    
    var body: some View {
        HStack() {
            StepBar(nowStep: step, frameSize: frameSize, fontSize: fontSize)
                .padding(.leading, -8)
            Spacer()
        }
        .frame(height: frameSize)
        .padding(.top, 22)
    }
}
