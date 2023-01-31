//
//  HabitCellView.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/18.
//

import SwiftUI

struct HabitCellView: View {
    //MARK: 습관 모델이 만들어지면 수정할 부분
    var habit: Challenge
    @EnvironmentObject var habitManager: HabitManager
    
    // MARK: - Body
    var body: some View {

        HStack{
            Button {
                // 업데이트 함수 요망
                // habit.isChecked.toggle()
//                Task{
//                    await habitManager.updateChallengeIsChecked(challenge: )
//
//                }
                
            } label: {
                Image(systemName: habit.isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundColor(habit.isChecked ? .green : .gray)
                
            }
            
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 5)
            //checkButton
            
            VStack(alignment: .leading, spacing: 1){
                VStack(alignment: .leading, spacing: 2){
                    Text(habit.createdDate)
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text(habit.challengeTitle)
                        .bold()
                        .font(.title2)
                }//VStack
                
                HStack(spacing: 5){
                    Text(Image(systemName: "sun.max.fill"))
                        .foregroundColor(.orange)
                    Text("\(habit.count + 66)일째 진행중")
                    Spacer()

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
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.bottom, 5)
   
    }// body
}
//struct HabitCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        HabitCellView(didHabit: Bool, title: <#T##String#>, dateFromStart: <#T##Int#>, dayWithOutStop: <#T##Int#>)
//    }
//}
