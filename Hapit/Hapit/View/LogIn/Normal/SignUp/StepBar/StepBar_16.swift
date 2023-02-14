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
    
    var body: some View {
        HStack() {
            StepBar(nowStep: step)
                .padding(.leading, -8)
            Spacer()
        }
        .frame(height: 30)
        .padding(.top, 22)
    }
}

//struct StepBar_16_Previews: PreviewProvider {
//    static var previews: some View {
//        StepBar_16(step: 2, frameSize: 30, fontSize: 15)
//    }
//}
