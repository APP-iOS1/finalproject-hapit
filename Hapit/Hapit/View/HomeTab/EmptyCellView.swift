//
//  EmptyCellView.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/20.
//

import SwiftUI

struct EmptyCellView: View {
    var body: some View {
        VStack{
            Spacer()
            //TODO: 트레이에 곰 들어간 사진 만들어보기
            Image(systemName: "tray")
                .scaleEffect(x: 3,y: 3)
                .padding()
            Text("텅")
                .font(.largeTitle)
                .bold()
            Text("아직 완성된 습관이 없습니다!")
                .font(.body)
            Spacer()
        }
    }
}

struct EmptyCellView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyCellView()
    }
}
