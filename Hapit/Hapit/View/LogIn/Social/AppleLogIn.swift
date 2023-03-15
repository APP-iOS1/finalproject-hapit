//
//  AppleLogIn.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct AppleLogIn: View {
    
    @EnvironmentObject var appleSignInManager: AppleSignInManager
    
    var body: some View {
        Button(action: {
            Task {
                await appleSignInManager.startSignInWithAppleFlow()
            }
        }){
            Image("appleLogo_dark")
                .mask(Circle())
                .frame(width: 44, height: 44)
        }
    }
}

struct AppleLogIn_Previews: PreviewProvider {
    static var previews: some View {
        AppleLogIn()
            .environmentObject(AppleSignInManager())
    }
}
