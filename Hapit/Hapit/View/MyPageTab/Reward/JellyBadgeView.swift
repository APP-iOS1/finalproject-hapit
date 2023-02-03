//
//  JellyBadgeView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct JellyBadgeView: View {
    @State var jellyImage = "bearBlue"
    @State var jellyName = "내가 가장\n오래 젤리"
    
    var body: some View {
        VStack {
            Image(jellyImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
                .background(Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 100, height: 100))
                .padding(.bottom, 15)
            
            Text(jellyName)
                .font(.custom("IMHyemin-Regular", size: 12))
                .frame(width: 60)
        }
        .padding(10)
    }
}

struct JellyBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        JellyBadgeView()
    }
}
