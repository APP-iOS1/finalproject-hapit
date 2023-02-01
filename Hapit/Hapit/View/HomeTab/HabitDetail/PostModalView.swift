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
        ScrollView{
            ForEach(postsForModalView) { view in
                /*@START_MENU_TOKEN@*/Text(view.title)/*@END_MENU_TOKEN@*/
            }
        }
    }
}

struct PostModalView_Previews: PreviewProvider {
    static var previews: some View {
        PostModalView(postsForModalView: .constant([]))
    }
}
