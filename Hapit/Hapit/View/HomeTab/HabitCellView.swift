//
//  HabitCellView.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/18.
//

import SwiftUI

struct HabitCellView: View {
    @Binding var didHabit: Bool
    
    //MARK: 습관 모델이 만들어지면 수정할 부분
    var title: String = "나의 습관명"
    var dateFromStart: Int = 20
    var dayWithOutStop: Int = 5
    var dayCompleted: String = "~ 2023년 1월 1일"
    var body: some View {
        HStack{
            

            VStack(alignment: .leading, spacing: 2){
                Text(dayCompleted)
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text(title)
                    .bold()
                    .font(.title2)
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

//struct HabitCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        HabitCellView(didHabit: Bool, title: <#T##String#>, dateFromStart: <#T##Int#>, dayWithOutStop: <#T##Int#>)
//    }
//}
