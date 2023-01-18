//
//  ChallengeCellView.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/18.
//

import SwiftUI

struct ChallengeCellView: View {
    
    @Binding var didHabit: Bool
    
    //MARK: 습관 모델이 만들어지면 수정할 부분
    var title: String = "나의 습관명"
    var dateFromStart: Int = 20
    var dayWithOutStop: Int = 5
    var dayStarted: String = "2023년 1월 1일 ~"
    var body: some View {
        HStack{
            VStack(alignment:.leading, spacing: 5){
                VStack(alignment: .leading, spacing: 2){
                    Text(dayStarted)
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text(title)
                        .bold()
                        .font(.title2)
                }//VStack
                
                HStack(spacing: 5){
                    Text(Image(systemName: "flame.fill"))
                        .foregroundColor(.orange)
                    Text("연속 \(dayWithOutStop)일째")
                    

                }
                
                .font(.subheadline)//HStack
            }//VStack
            Spacer()
            Button {
                didHabit.toggle()
            } label: {
                Image(systemName: didHabit ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundColor(didHabit ? .green : .gray)
            }
            
            .buttonStyle(PlainButtonStyle())
        }//HStack

        .padding(20)
        .foregroundColor(.black)
        .background(Color("CellColor"))
        .cornerRadius(20)
        .padding(.horizontal, 20)
        
    }
    
}



struct ChallengeCellView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCellView(didHabit: .constant(true))
    }
}
