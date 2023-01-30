//
//  ChallengeCellView.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/18.
//

import SwiftUI

struct ChallengeCellView: View {
 
    var challenge: Challenge
    
    @EnvironmentObject var habitManager: HabitManager
    
    // MARK: - Body
    var body: some View {
        
        
        HStack{
            Button {
                // firestore에 업데이트 함수 제작 요망
                //challenge.isChecked.toggle()
                Task{
                    await habitManager.updateChallengeIsChecked(challenge: challenge)
                    
                }
                
            } label: {
                Image(systemName: challenge.isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundColor(challenge.isChecked ? .green : .gray)
                
            }
            
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 5)
            //checkButton
            
            VStack(alignment:.leading, spacing: 1){
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
                    Spacer()
                    ForEach(0..<3){ bear in
                        Image("bearBlue")
                        
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .offset(y:5)
                            .frame(width: 25)
                            .background(Color(.white))
                            .clipShape(Circle())
                            .overlay(Circle().stroke())
                            .foregroundColor(.gray)
                            .padding(.trailing, -12)
                        
                    }
                    
                }
                .font(.subheadline)//HStack
                
            }//VStack
            Spacer()
            
        }//HStack
        .padding(20)
        .foregroundColor(.black)
        .background(
            .white
        )
        .overlay(
            VStack{
                Spacer()
                ZStack{
                    Rectangle()
                        .frame(height: 4)
                        .padding([.top, .leading, .trailing], 10)
                        .foregroundColor(Color(UIColor.lightGray))
                    
                    HStack{
                        //                    Image("duckBoat")
                        //                        .resizable()
                        //                        .aspectRatio(contentMode: .fit)
                        //                        .frame(width: 20)
                        
                        
                        Rectangle()
                        //.frame(width: (CGFloat(dateFromStart)/CGFloat(66)) * UIScreen.main.bounds.size.width ,height: 4)
                            .padding([.top, .leading, .trailing], 10)
                        Spacer()
                    }
                }
            }
        )
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.bottom, 5)
        
        
        
    }// body
}

//struct ChallengeCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChallengeCellView(challenge: .constant(Challenge(id: UUID().uuidString, creator: "박진주", mateArray: [], challengeTitle: "물 500ml 마시기", createdAt: Date(), count: 0, isChecked: false)))
//    }
//}


//MARK: 습관 모델이 만들어지면 수정할 부분
//    var title: String = "나의 습관명"
//    var dateFromStart: Int = 20
//    var dayWithOutStop: Int = 5
//    var dayStarted: String = "2023년 1월 1일 ~"
