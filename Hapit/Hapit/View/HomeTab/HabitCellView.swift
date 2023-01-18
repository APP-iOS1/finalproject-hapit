//
//  HabitCellView.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/18.
//

import SwiftUI

struct HabitCellView: View {
    //MARK: 습관 모델이 만들어지면 수정할 부분
    @Binding var habit: Challenge
    
    var body: some View {
        HStack{
            

            VStack(alignment: .leading, spacing: 2){
                Text(habit.createdDate)
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text(habit.challengeTitle)
                    .bold()
                    .font(.title2)
            }//VStack
            Spacer()
            Button {
                habit.isChecked.toggle()
            } label: {
                Image(systemName: habit.isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundColor(habit.isChecked ? .green : .gray)
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

//struct HabitCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        HabitCellView(didHabit: Bool, title: <#T##String#>, dateFromStart: <#T##Int#>, dayWithOutStop: <#T##Int#>)
//    }
//}
