//
//  StepBar_15.0.swift
//  Hapit
//
//  Created by 김응관 on 2023/02/13.
//

import SwiftUI

@available(iOS 15, *)
struct StepBar_15: View {
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
        .padding(.top, -30)
    }
}
