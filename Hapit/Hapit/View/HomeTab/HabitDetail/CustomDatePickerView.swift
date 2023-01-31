//
//  CustomDatePicker.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/30.
//

import SwiftUI

struct CustomDatePickerView: View {

    var currentChallenge: Challenge
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
                        .font(.custom("IMHyemin-Regular", size: 12))
                        .fontWeight(.semibold)
                    Text(extraData()[1])
                        .font(.custom("IMHyemin-Bold", size: 28))
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
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                }//Button
                
            }// HStack
            .padding()
            .padding(.top, -20)
            HStack(spacing: 0){
                ForEach(days, id: \.self){ day in
                    VStack{
                        Text(day)
                            .font(.custom("IMHyemin-Bold", size: 16))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(getDayColor(day))
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(getDayColor(day))
                    }
                }
            }
            
            // Dates
            let colums = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: colums, spacing: 15) {
                ForEach(extractDate()){ value in
                    
                    CardView(value: value)
                        .background{
                            Circle()
                                .fill(Color("DarkPinkColor"))
                                .padding(.top, -20)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                        }
                        .onTapGesture {
                            currentDate = value.date
                            //MARK: 탭 했을 때 해당 날짜에 대한 Diaries가 뜨도록
                        }
                        .animation(.easeIn, value: currentDate)
                }
            }
//
//            VStack(spacing: 15){
//                Text("Tasks")
//                    .font(.title2.bold())
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                if let task = tasks.first(where: { task in
//                    return isSameDay(date1: task.taskDate, date2: currentDate)
//                }){
//                    ForEach(task.task){task in
//
//                        VStack(alignment: .leading, spacing: 10){
//
//                            Text(task.time
//                                .addingTimeInterval(CGFloat.random(in: 0...5000)),style: .time)
//
//                            Text(task.title)
//                                .font(.title2.bold())
//                        }
//                        .padding(.vertical, 10)
//                        .padding(.horizontal)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .background(
//
//                            Color.purple
//                                .opacity(0.5)
//                                .cornerRadius(10)
//
//                        )
//                    }
//                }
//                else{
//
//                    Text("No Task Found")
//                }
//            }
//            .padding()
//            .padding(.top, 20)
//
            Spacer()
        }//VStack
        .padding()
        .padding(.top, 0)
        .onChange(of: currentMonth) { newValue in
            currentDate = getCurrentMonth()
                
        }
    }
    
    //MARK: Methods
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View{
        VStack{
            if value.day != -1{
//                if let habit = HabitManager.challenges.first(where: { challenge in
//                    return isSameDay(date1: challenge.date, date2: value.date)
//                }){
//
//                    Text("\(value.day)")
//                        .font(.title3.bold())
//                        .foregroundColor(isSameDay(date1: task.taskDate, date2: currentDate) ? .white : .primary)
//                        .frame(maxWidth: .infinity)
//                    Spacer()
//                    Circle()
//                        .fill(isSameDay(date1: task.taskDate, date2: currentDate) ? .white : .pink)
//                        .frame(width: 8, height: 8)
//
//                }

                    Text("\(value.day)")
                        .font(.custom("IMHyemin-Bold", size: 20))
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                
            }
        }
        .padding(.vertical, 8)
        .frame(height: 60, alignment: .top)
    }
    func getDayColor(_ day: String) -> Color {
        if day == "일"{
            return .red
        }
        else if day == "토"{
            return .blue
        }
        else{
            return Color("AccentColor")
        }
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    // 년 월 추출
    func extraData() -> [String]{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY M월"
        
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
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
            
        }
        
        let firstWeekDay = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekDay - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
            
        return days
    }
}
struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomDatePickerView(currentChallenge: (Challenge(id: UUID().uuidString, creator: "릴루", mateArray: ["현호", "진형", "예원"], challengeTitle: "물 마시기", createdAt: Date(), count: 0, isChecked: true)) , currentDate: .constant(Date()))
    }
}

extension Date{
    
    func getAllDates() -> [Date] {
        
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1 , to: startDate)!
        }
    }
}
