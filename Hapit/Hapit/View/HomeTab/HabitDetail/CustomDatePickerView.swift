//
//  CustomDatePicker.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/30.
//

import SwiftUI

struct CustomDatePickerView: View {
    
    @Binding var currentDate: Date
    
    //MARK: 화살표 버튼을 통해 month를 업데이트 해주는 변수
    
    @State private var currentMonth: Int = 0
    
    var body: some View {
        VStack(spacing: 35){
            
            // Days
            let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(extraData()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text(extraData()[1])
                        .font(.title.bold())
                }
                
                Spacer(minLength: 0)
                
                Button {
                    withAnimation{
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                }//Button
                .animation(.easeIn, value: currentMonth)
                
                Button {
                    withAnimation{
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                }//Button
                
            }// HStack
            HStack(spacing: 0){
                ForEach(days, id: \.self){ day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Dates
            let colums = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: colums, spacing: 15) {
                ForEach(extractDate()){ value in
                    
                    Text("\(value.day)")
                        .font(.title3.bold())
                }
            }
            
            Spacer()
        }//VStack
        .onChange(of: currentMonth) { newValue in
            currentDate = getCurrentMonth()
        }
    }
    // 년 월 추출
    func extraData() -> [String]{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    
    func getCurrentMonth() -> Date{
        
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    func extractDate() -> [DateValue]{
        
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        return currentMonth.getAllDates().compactMap { date -> DateValue in
            
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
    }
}
struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomDatePickerView(currentDate: .constant(Date()))
    }
}

extension Date{
    
    func getAllDates() -> [Date] {
        
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        var range = calendar.range(of: .day, in: .month, for: startDate)!
        range.removeLast()
        
        return range.compactMap { day -> Date in
            
            return calendar.date(byAdding: .day, value: day == 1 ? 0 : day, to: startDate)!
        }
    }
}

