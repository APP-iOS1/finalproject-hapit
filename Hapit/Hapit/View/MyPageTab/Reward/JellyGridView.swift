//
//  BadgeGridView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct JellyGridView: View {
    let data = Array(1...40).map { "목록 \($0)"}
    
    //화면을 그리드형식으로 꽉채워줌
    let columns = [
        GridItem(.adaptive(minimum: 100),spacing: 30),
        GridItem(.adaptive(minimum: 100),spacing: 30),
        GridItem(.adaptive(minimum: 100),spacing: 30),
    ]
    
    var body: some View {
        ScrollView{
            VStack{
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<data.count, id: \.self) { index in
                        // TODO: 뱃지 존재 여부에 따라 색깔 바꾸기
                        if index == 1 {
                            JellyBadgeView(jellyImage: "bearBlue")
                        } else if index == 2 {
                            JellyBadgeView(jellyImage: "bearTurquoise")
                        } else if index == 4 {
                            JellyBadgeView(jellyImage: "bearGreen")
                        } else {
                            JellyBadgeView(jellyImage: "bearWhite")
                        }
                        
                    }
                }
                
            }.padding(.horizontal)
        }
    }
}

struct JellyGridView_Previews: PreviewProvider {
    static var previews: some View {
        JellyGridView()
    }
}
