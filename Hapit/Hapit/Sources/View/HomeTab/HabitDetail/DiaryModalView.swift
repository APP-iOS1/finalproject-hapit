//
//  DiaryModalView.swift
//  Hapit
//
//  Created by 추현호 on 2023/01/30.
//

import SwiftUI

struct DiaryModalView: View {
    var body: some View {
        
        ZStack{
            VStack {

                Image("diaryImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .frame(height: 400) //정방형으로만 등록할 수 있도록 하는 법 찾아보기
                    .padding()
                    .background(Color(.white), in: RoundedRectangle(cornerRadius: 10.0)
                        //.frame(width:300, height: 300)
                    )
                    .padding()
                Text("대충 글")
            }
        }
    }
}
