//
//  DiaryView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct DiaryView: View {
    @State var imageURL = "https://i.pinimg.com/564x/ac/0a/9b/ac0a9b6c84d82e7cb1d02a67f1f0f1a5.jpg"
    @State var diaryText = "오늘은 물도 마시고 운동도 하고 책도 읽었다 ! 갓생산 것 같아서 너무너무 뿌듯했다 !"
    var body: some View {
        VStack {
            if imageURL == "" {

            } else {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                    //                    .frame(width: 300, height: 210)
                } placeholder: {
                    ProgressView()
                }.padding()
            }
            
            Text(diaryText)
        }
    }
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryView()
    }
}
