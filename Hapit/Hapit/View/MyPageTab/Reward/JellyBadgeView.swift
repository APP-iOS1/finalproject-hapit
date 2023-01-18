//
//  JellyBadgeView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct JellyBadgeView: View {
    @State var jellyImage = "bearBlue"
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
            
            Text("내가 가장\n오래 젤리")
                .font(.caption)
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
