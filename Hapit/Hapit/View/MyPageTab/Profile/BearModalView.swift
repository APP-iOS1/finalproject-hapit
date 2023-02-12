//
//  ProfileModalView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct BearModalView: View {
    @Binding var showModal: Bool
    @Binding var isSelectedJelly: Int
    let bearArray = Jelly.allCases.map({"\($0)"})
    let data = Array(1...20).map { "목록 \($0)"}
    
    //화면을 그리드형식으로 꽉채워줌
    let columns = [
        GridItem(.adaptive(minimum: 100),spacing: 5),
        GridItem(.adaptive(minimum: 100),spacing: 5),
        GridItem(.adaptive(minimum: 100),spacing: 5),
        GridItem(.adaptive(minimum: 100),spacing: 5),
        GridItem(.adaptive(minimum: 100),spacing: 5)
    ]
    
    var body: some View {
        VStack {
            Text("대표 이미지 설정")
                .font(.custom("IMHyemin-Bold", size: 22))
            
            ScrollView {
                VStack {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(Array(zip(0..<data.count, data)), id: \.0) { index, item in
                            Button {
                                showModal.toggle()
                                self.isSelectedJelly = index
                            } label: {
                                Image(bearArray[index % 7])
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding(5)
                                    .overlay(RoundedRectangle(cornerRadius: 20)
                                        .stroke(self.isSelectedJelly == index ? Color("DarkPinkColor") : Color.gray ,
                                                lineWidth: 2))
                            }
                        }
                    }
                }
                .padding(10)
            }
        }
        .padding()
    }
}

struct BearModalView_Previews: PreviewProvider {
    static var previews: some View {
        BearModalView(showModal: .constant(false), isSelectedJelly: .constant(Int(1)))
    }
}
