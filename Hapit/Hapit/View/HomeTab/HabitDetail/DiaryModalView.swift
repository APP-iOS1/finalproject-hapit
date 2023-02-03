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
//            Color("AccentColor")
//                .ignoresSafeArea()
//            
            VStack {
//                HStack{
//                    // 이거 버튼 구조체 만들어서 이미지 이름만 넣게 하고 ForEach로 돌리면 댐
//                    Image("bearBlue")
//                        .resizable()
//                        .scaledToFit()
//                        .clipShape(Circle())
//                        .frame(width: 60)
//                    Image("bearBlue")
//                        .resizable()
//                        .scaledToFit()
//                        .clipShape(Circle())
//                        .frame(width: 60)
//                    Image("bearBlue")
//                        .resizable()
//                        .scaledToFit()
//                        .clipShape(Circle())
//                        .frame(width: 60)
//                    Image("bearBlue")
//                        .resizable()
//                        .scaledToFit()
//                        .clipShape(Circle())
//                        .frame(width: 60)
//                }
//                .background(Color(.white), in: RoundedRectangle(cornerRadius: 10.0))
//
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

struct DiaryModalView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryModalView()
    }
}
