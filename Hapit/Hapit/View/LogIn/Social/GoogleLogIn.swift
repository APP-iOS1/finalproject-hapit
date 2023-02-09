//
//  GoogleLogIn.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct GoogleLogIn: View {
    @EnvironmentObject var authManager: AuthManager
    @Binding var isFullScreen: String
    
    var body: some View {
        Button(action: {
            authManager.googleSignIn()
        }){
            Image("btn_google_light_normal_ios")
                .mask(Circle()).frame(maxWidth: .infinity, maxHeight: 44)
        }
    }
}

struct GoogleLogIn_Previews: PreviewProvider {
    static var previews: some View {
        GoogleLogIn(isFullScreen: .constant("logOut"))
    }
}
