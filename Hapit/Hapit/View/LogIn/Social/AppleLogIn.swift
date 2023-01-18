//
//  AppleLogIn.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct AppleLogIn: View {
    var body: some View {
        Image("Logo - SIWA - Logo-only - White")
            .mask(Circle()).frame(maxWidth: .infinity, maxHeight: 44)
    }
}

struct AppleLogIn_Previews: PreviewProvider {
    static var previews: some View {
        AppleLogIn()
    }
}
