//
//  JellyEmptyView.swift
//  Hapit
//
//  Created by greenthings on 2023/02/09.
//

import Foundation



import SwiftUI

struct JellyEmptyBadgeView: View {
    
    //let badge: Badge
    
    var body: some View {
        VStack {
            
            Image("bear.white")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 90)
                .background(Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 100, height: 100))
                .padding(.bottom, 15)
            
            
                Text("비어 있음")
                    .font(.custom("IMHyemin-Regular", size: 12))
                    .frame(width: 60)
            
        }
        .padding(10)
        
    }
}
