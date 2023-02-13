//
//  StepBar_15.0.swift
//  Hapit
//
//  Created by 김응관 on 2023/02/13.
//

import SwiftUI

struct StepBar_15: View {
    var body: some View {
        HStack() {
            StepBar(nowStep: 1)
                .padding(.leading, -8)
            Spacer()
        }
        .frame(height: 30)
        .padding(.top, -25)
    }
}

struct StepBar_15_Previews: PreviewProvider {
    static var previews: some View {
        StepBar_15()
    }
}
