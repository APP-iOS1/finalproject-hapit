//
//  GetStartView.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/18.
//

import SwiftUI

struct GetStartView: View {
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer().frame(height: 27)
            
            HStack() {
                StepBar(nowStep: 3)
                    .padding(.leading, -8)
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hapit")
                        .foregroundColor(.pink)
                    Text("회원가입 완료!")
                }
                .font(.largeTitle)
                .bold()
                Spacer()
            }
            
            Spacer().frame(height: 80)
            
            Image("fourbears")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 310, maxHeight: 170)
            
            Spacer().frame(height: 104)
            
            NavigationLink(destination: LogInView()) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.pink)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .overlay {
                        Text("시작하기")
                            .foregroundColor(.white)
                    }
            }
            .disabled(false)
            
        }
        .padding(.horizontal, 20)
    }
}

struct GetStartView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartView()
    }
}
