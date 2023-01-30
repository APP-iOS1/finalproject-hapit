//
//  DiaryView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct DiaryView: View {
    @State var imageURL = "https://avatars.githubusercontent.com/u/82339184?v=4"
//    "https://i.pinimg.com/564x/ac/0a/9b/ac0a9b6c84d82e7cb1d02a67f1f0f1a5.jpg"
    @State var diaryText = "오늘은 물도 마시고 운동도 하고 책도 읽었다 ! 갓생산 것 같아서 너무너무 뿌듯했다 ! 릴루 ! 릴루 ! 릴루 ! 릴루 !"
    //    "오늘은 물도 마시고 운동도 하고 책도 읽었다 ! 갓생산 것 같아서 너무너무 뿌듯했다 !"
    let screenWidth = UIScreen.main.bounds.size.width
    var body: some View {
        VStack {
            HStack {
                Image("bearBlue")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(y:5)
                    .frame(width: 20)
                    .background(Color(.white))
                    .clipShape(Circle())
                    .overlay(Circle().stroke())
                    .foregroundColor(.gray)
                
                Text("민주왕자님")
                    .foregroundColor(Color.accentColor)
                Spacer()
            }
                
            HStack {
                Text(diaryText)
                    .bold()
                    .lineLimit(3)
                Spacer()
                if imageURL == "" {
                    
                } else {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipped()
//                            .cornerRadius(20)
                            .padding(-15)
                        
                    } placeholder: {
                        ProgressView()
                    }.padding()
                    
                }
            }.frame(height: 80)
        }
        .padding()
        .frame(width: screenWidth - 30, height: 150)
        .background(RoundedRectangle(cornerRadius: 20)
            .fill(Color(.systemGray6)))
        
    }
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryView()
    }
}
