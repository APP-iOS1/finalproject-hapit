//
//  CellSkeletonView.swift
//  Hapit
//
//  Created by 박진형 on 2023/03/11.
//

import SwiftUI

struct CellSkeletonView: View {
    var body: some View {
        ZStack{
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "circle")
                        .font(.title)
                        .foregroundColor(Color("GrayFontColor"))
                }
                .padding(.trailing, 5)
                .buttonStyle(PlainButtonStyle())
                
                //checkButton
                //TODO: 로컬데이터로 개편부탁ㅎ;
                VStack(alignment: .leading, spacing: 1){
                    VStack(alignment: .leading, spacing: 2){
                        Text("스켈레톤용글씨스켈레톤용")
                            .font(.custom("IMHyemin-Regular", size: 13))
                            .foregroundColor(Color("GrayFontColor"))
                        Text("스켈레톤용글씨스켈레톤용")
                            .font(.custom("IMHyemin-Bold", size: 20))
                            .foregroundColor(Color("MainFontColor"))
                    }//VStack
                    
                    HStack(spacing: 5){
                        Text(Image(systemName: "flame.fill"))
                            .foregroundColor(.orange)
                        Text("스켈레톤용글씨일째")
                            .foregroundColor(Color("MainFontColor"))
                        Spacer()
                        
                    }
                }
                .redacted(reason: .placeholder)
                .font(.custom("IMHyemin-Regular", size: 15))//HStack
                
            }//VStack
            Spacer()
            
        }//HStack
        .padding(20)
        .background(
            ZStack{
                Color("CellColor")
            }
        )
        .cornerRadius(20)
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 20))
        
    }
}

struct CellSkeletonView_Previews: PreviewProvider {
    static var previews: some View {
        CellSkeletonView()
    }
}
