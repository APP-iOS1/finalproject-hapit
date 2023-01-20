//
//  WriterView.swift
//  Hapit
//
//  Created by 김예원 on 2023/01/20.
//

import SwiftUI

struct WriterView: View {
    @State private var nickName = "릴루"
    @State private var date = "2023년 01월 20일 금요일"
    @State private var isSelectedJelly = 0

    let bearArray = Jelly.allCases.map({"\($0)"})
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Image(bearArray[isSelectedJelly % 7])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height:20)
                        .background(Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 30, height: 30))
                            
                }.padding(10)
                
                
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(nickName)")
                                .font(.subheadline)
                                .bold()
                            
                            Text("\(date)")
                                .font(.subheadline)
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
        
        struct WriterView_Previews: PreviewProvider {
            static var previews: some View {
                WriterView()
            }
        }
