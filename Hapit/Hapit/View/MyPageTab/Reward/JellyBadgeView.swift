//
//  JellyBadgeView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct JellyBadgeView: View {
    @State var jellyImage = ""
    var body: some View {
        VStack {
            VStack{
                Image(jellyImage)
                    .resizable()
                    .frame(width: 65, height: 80)
                    .background(Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 200, height: 110))
                    .padding()
            }
            
            Text("내가 가장\n오래 젤리")
                .font(.caption)
                .frame(width: 50)
        }.padding(10)
    }
}

struct JellyBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        JellyBadgeView()
    }
}
