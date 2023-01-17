//
//  SignUpTab.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct SignUpTab: View {
    @State var step: Int = 0
    var body: some View {
        
        TabView(selection: $step) {
            RegisterView(step: $step)
                .tag(0)
            ToSView(step: $step)
                .tag(1)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

struct SignUpTab_Previews: PreviewProvider {
    static var previews: some View {
        SignUpTab()
    }
}
