//
//  MakersView.swift
//  Hapit
//
//  Created by 박민주 on 2023/03/14.
//

import SwiftUI

struct MakersView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Text("만든 사람들")
                    .font(.custom("IMHyemin-Bold", size: 25))
                    .padding(.top)
                
                VStack {
                    Image("bearYellow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120)
                    Text("김예원")
                }
                
                VStack {
                    Image("bearGreen")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120)
                    Text("김응관")
                }
                
                VStack {
                    Image("bearAlarm")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120)
                    Text("박민주")
                }
                
                VStack {
                    Image("bearBlue")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120)
                    Text("박진형")
                }
                
                VStack {
                    Image("bearPrincess")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120)
                    Text("이주희")
                }
                
                VStack {
                    Image("bearRed")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120)
                    Text("신현준")
                }
                
                VStack {
                    Image("bearChoo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)
                    Text("추현호")
                }
            }
            .frame(maxWidth: .infinity)
            .font(.custom("IMHyemin-Regular", size: 18))
        }
    }
}
