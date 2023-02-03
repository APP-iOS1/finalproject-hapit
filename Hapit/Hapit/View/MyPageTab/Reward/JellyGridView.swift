//
//  BadgeGridView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct JellyGridView: View {
    let data = Array(1...20).map { "목록 \($0)"}
    
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
                        if index == 0 {
                            JellyBadgeView(jellyImage: "bearBlue", jellyName: "첫 습관 달성")
                        } else if index == 1 {
                            JellyBadgeView(jellyImage: "bearTurquoise", jellyName: "작심삼일")
                        } else if index == 2 {
                            JellyBadgeView(jellyImage: "bearYellow", jellyName: "첫 친구")
                        } else if index == 3 {
                            JellyBadgeView(jellyImage: "bearGreen", jellyName: "마음이 갈대밭")
                        } else {
                            JellyBadgeView(jellyImage: "bearWhite", jellyName: "???")
                        }
                        
                    }
                }
                
            }
            .padding()
        }
    }
}

struct JellyGridView_Previews: PreviewProvider {
    static var previews: some View {
        JellyGridView()
    }
}
