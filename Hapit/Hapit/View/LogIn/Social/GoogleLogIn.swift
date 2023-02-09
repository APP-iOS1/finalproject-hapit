//
//  GoogleLogIn.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI
import GoogleSignInSwift

struct GoogleLogIn: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        GoogleSignInButton {
            authManager.googleSignIn()
        }
        .frame(width: 320, height: 40)
        
//        Button(action: {
//            authManager.googleSignIn()
//        }){
//            Image("btn_google_light_normal_ios")
//                .mask(Circle()).frame(maxWidth: .infinity, maxHeight: 44)
//        }
    }
}

struct GoogleLogIn_Previews: PreviewProvider {
    static var previews: some View {
        GoogleLogIn()
    }
}
