//
//  GoogleLogIn.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI

struct GoogleLogIn: View {
    @EnvironmentObject var googleSignInManager: GoogleSignInManager
    
    var body: some View {
        Button(action: {
            Task {
                await googleSignInManager.googleSignIn()
            }
        }){
            Image("googlebtn")
                .mask(Circle())
                .frame(width: 44, height: 44)
        }
    }
}

struct GoogleLogIn_Previews: PreviewProvider {
    static var previews: some View {
        GoogleLogIn()
            .environmentObject(GoogleSignInManager())
    }
}
