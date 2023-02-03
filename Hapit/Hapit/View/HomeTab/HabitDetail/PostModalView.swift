//
//  PostModalView.swift
//  Hapit
//
//  Created by 박진형 on 2023/02/01.
//

import SwiftUI

struct PostModalView: View {
    @Binding var postsForModalView: [Post]
    var body: some View {
        
        VStack{
            ScrollView(.horizontal){
                //TODO: Post 구조체에 작성자도 있어야함
                ForEach(postsForModalView) { post in
                    if let postCreator = post.id{
                        Text(postCreator)
                    }
                }
            }
            DiaryModalView()
        }
        .frame(width: 300, height: 500)
        .background(
            Rectangle()
                .foregroundColor(Color("CellColor"))
                .cornerRadius(20)
   
        )
    }
}

struct PostModalView_Previews: PreviewProvider {
    static var previews: some View {
        PostModalView(postsForModalView: .constant([]))
    }
}
