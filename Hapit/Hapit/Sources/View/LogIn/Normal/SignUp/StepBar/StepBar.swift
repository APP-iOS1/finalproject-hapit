//
//  StepBar.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/18.
//

import SwiftUI

struct StepBar: View {
    let nowStep: Int
    let frameSize: CGFloat
    let fontSize: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1...3, id: \.self) { index in
                
                if index <= nowStep {
                    Spacer().frame(width: 8)
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: frameSize)
                        .overlay {
                            Text("\(index)")
                                .font(.custom("IMHyemin-Bold", size: fontSize))
                                .foregroundColor(Color.white)
                        }
                } else {
                    Spacer().frame(width: 8)
                    Circle()
                        .stroke(Color("GrayFontColor"), lineWidth: 0.7)
                        .frame(width: frameSize)
                        .overlay {
                            Text("\(index)")
                                .font(.custom("IMHyemin-Bold", size: fontSize))
                                .foregroundColor(index == nowStep ? Color.white : Color("GrayFontColor"))
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
                                .fill(Color("GrayFontColor"))
                                .frame(width: 3)
                            Circle()
                                .fill(Color("GrayFontColor"))
                                .frame(width: 3)
                            Circle()
                                .fill(Color("GrayFontColor"))
                                .frame(width: 3)
                        }
                    }
                }
            }
        }
    }
}
