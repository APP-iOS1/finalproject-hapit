//
//  MessageFullscreenView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/18.
//

import SwiftUI

struct MessageFullscreenView: View {
    var body: some View {
        
        ZStack {
            ScrollView {
                VStack {
                    Text("현재 도착한 메시지가 없습니다.")
                }.frame(maxWidth: .infinity)
            }
        }.background(Color("BackgroundColor"))
    }
}

struct MessageFullscreenView_Previews: PreviewProvider {
    static var previews: some View {
        MessageFullscreenView()
    }
}
