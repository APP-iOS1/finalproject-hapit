//
//  StepBar.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/18.
//

import SwiftUI

struct StepBar: View {
    let nowStep: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1...3, id: \.self) { index in
                
                if index <= nowStep {
                    Spacer().frame(width: 8)
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 30)
                        .overlay {
                            Text("\(index)")
                                .font(.custom("IMHyemin-Bold", size: 28))
                                .foregroundColor(Color.white)
                        }
                } else {
                    Spacer().frame(width: 8)
                    Circle()
                        .stroke(Color.gray, lineWidth: 0.7)
                        .frame(width: 30)
                        .overlay {
                            Text("\(index)")
                                .font(.custom("IMHyemin-Bold", size: 28))
                                .foregroundColor(index == nowStep ? Color.white : Color.gray)
                        }
                }
                
                Spacer().frame(width: 8)
                
                if index != 3 {
                    if index < nowStep {
                        HStack {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 3)
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 3)
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 3)
                        }
                    } else {
                        HStack {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 3)
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 3)
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 3)
                        }
                    }
                }
            }
        }
    }
}

//struct StepBar_Previews: PreviewProvider {
//    static var previews: some View {
//        StepBar(nowStep: 2)
//    }
//}
