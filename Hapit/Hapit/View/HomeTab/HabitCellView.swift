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

            VStack(alignment: .leading, spacing: 1){
                VStack(alignment: .leading, spacing: 2){

                    Text(habit.createdDate)
                        .font(.custom("IMHyemin-Regular", size: 13))
                        .foregroundColor(Color("GrayFontColor"))
                    Text(habit.challengeTitle)
                        .font(.custom("IMHyemin-Bold", size: 22))
                }//VStack
                
                HStack(spacing: 5) {
                    Text(Image(systemName: "sun.max.fill"))
                        .foregroundColor(.orange)
                    Text("\(habit.count)일째 진행중")
                    Spacer()

                }
                .font(.custom("IMHyemin-Regular", size: 15))//HStack
                
            }//VStack
            Spacer()
            
        }//HStack
        .padding(20)
        .background(
            Color("CellColor")
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
