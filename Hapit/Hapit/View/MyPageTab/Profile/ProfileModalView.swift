//
//  ProfileModalView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct ProfileModalView: View {
    @Binding var showModal: Bool
    
    let data = Array(1...40).map { "목록 \($0)"}
    
    //화면을 그리드형식으로 꽉채워줌
    let columns = [
        GridItem(.adaptive(minimum: 100),spacing: 5),
        GridItem(.adaptive(minimum: 100),spacing: 5),
        GridItem(.adaptive(minimum: 100),spacing: 5),
        GridItem(.adaptive(minimum: 100),spacing: 5),
        GridItem(.adaptive(minimum: 100),spacing: 5)
    ]
    
    var body: some View {
        ScrollView{
            VStack{
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(data, id: \.self) {i in
                        Image("bearYellow")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(5)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke( Color.gray, lineWidth: 2))
                    }
                }
                
            }.padding()
        }
    }
}

struct ProfileModalView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileModalView(showModal: .constant(false))
    }
}
