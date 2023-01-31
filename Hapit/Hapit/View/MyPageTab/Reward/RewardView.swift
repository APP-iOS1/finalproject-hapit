//
//  RewardView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct RewardView: View {
    var body: some View {
        VStack {
            // 타이틀
            VStack {
                HStack {
                    Text("곰젤리 전시관")
                        .font(.title2)
                        .bold()
                    Spacer()
                }.padding(.bottom, 5)
                HStack {
                    Text("획득 젤리")
                        .bold()
                    Spacer()
                    Text("6 / 30")
                        .foregroundColor(Color.accentColor)
                        .bold()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            //                .padding()
            Divider()
            // 이미지 그리드
            JellyGridView()
                .padding(10)
        }
        .background()
        .cornerRadius(20)
        .padding(EdgeInsets(top: 5, leading: 20, bottom: 20, trailing: 20))
    }
}

struct RewardView_Previews: PreviewProvider {
    static var previews: some View {
        RewardView()
    }
}
