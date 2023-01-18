//
//  ProfileModalView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct ProfileModalView: View {
    @Binding var showModal: Bool
    // TODO: 현재 사용자가 선택한 프로필 사진 인덱스로 초기화
    @Binding var isSelectedJelly : Int
    // TODO: bearArray 나중에 Enum으로 관리
    let bearArray = ["bearYellow", "bearBlue", "bearGreen", "bearPurple", "bearTurquoise", "bearRed", "bearWhite"]
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
                .font(.title2)
                .bold()
            ScrollView {
                VStack {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(Array(zip(0..<data.count, data)), id: \.0) { index, item in
                            Button {
                                self.isSelectedJelly = index
                            } label: {
                                Image(bearArray[index % 7])
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding(5)
                                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(self.isSelectedJelly == index ? Color.blue : Color.gray , lineWidth: 2))
                            }
                        }
                    }
                }
                .padding(10)
            }
            Button {
                showModal = false
            } label: {
                Text("확인")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 15)
                        .fill(Color.accentColor))
            }
            
        }
        .padding()
    }
}

struct ProfileModalView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileModalView(showModal: .constant(false), isSelectedJelly: .constant(Int(1)))
    }
}
