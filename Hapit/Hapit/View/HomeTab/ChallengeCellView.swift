//
//  ChallengeCellView.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/18.
//

import SwiftUI

struct ChallengeCellView: View {
    //MARK: 습관 모델이 만들어지면 수정할 부분
    var title: String = "나의 습관명"
    var dateFromStart: Int = 20
    var dayWithOutStop: Int = 5
    var dayStarted: String = "2023년 1월 1일 ~"
    
    @Binding var challenge: Challenge
    
    // MARK: - Body
    var body: some View {
        HStack{
            VStack(alignment:.leading, spacing: 5){
                VStack(alignment: .leading, spacing: 2){
                    Text(challenge.createdDate)
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text(challenge.challengeTitle)
                        .bold()
                        .font(.title2)
                }//VStack
                
                HStack(spacing: 5){
                    Text(Image(systemName: "flame.fill"))
                        .foregroundColor(.orange)
                    Text("연속 \(challenge.count)일째")
                    

                }
                
                .font(.subheadline)//HStack
            }//VStack
            Spacer()
            Button {
                challenge.isChecked.toggle()
            } label: {
                Image(systemName: challenge.isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundColor(challenge.isChecked ? .green : .gray)
            }
            
            .buttonStyle(PlainButtonStyle())
        }//HStack

        .padding(20)
        .foregroundColor(.black)
        .background(Color("CellColor"))
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.bottom, 5)
        
    }
    
}



struct ChallengeCellView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCellView(challenge: .constant(Challenge(id: UUID().uuidString, creator: "박진주", mateArray: [], challengeTitle: "물 500ml 마시기", createdAt: Date(), count: 0, isChecked: false)))
    }
}
