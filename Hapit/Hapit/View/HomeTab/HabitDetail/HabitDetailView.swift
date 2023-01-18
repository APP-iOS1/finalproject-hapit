//
//  HabitDetailView.swift
//  Hapit
//
//  Created by 추현호 on 2023/01/17.
//

import SwiftUI

struct HabitDetailView: View {
    @StateObject var dairyModel: DairyViewModel = DairyViewModel()
    
    private let calendar: Calendar
    private let monthDayFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    
    @State private var selectedDate = Self.now
    private static var now = Date()
    //글쓰기 이동용
    @State private var isWriteSheetOn: Bool = false
    
    init(calendar: Calendar) {
        self.calendar = calendar
        self.monthDayFormatter = DateFormatter(dateFormat: "MM/dd", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "d", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEE", calendar: calendar)
        self.timeFormatter = DateFormatter(dateFormat: "H:mm", calendar: calendar)
    }
    
    var body: some View {
        
        VStack {
            HStack {
                VStack(alignment: .center, spacing: 10) {
                    Text("\(Date().formatted(date: .abbreviated, time: .omitted)) 부터 시작한 습관")
                        .foregroundColor(.gray)
                    
                    Text("N일째 지속중 🔥")
                        .font(.title.bold())
                }

            }
            .padding(.leading)
            
            CalendarWeekListView(
                calendar: calendar,
                date: $selectedDate,
                content: { date in
                    Button(action: {
                        selectedDate = date
                        
                        withAnimation {
                            dairyModel.currentDay = date
                        }
                    }) {
                        VStack(spacing: 10) {
                            Text(dayFormatter.string(from: date))
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                            
                            Text(weekDayFormatter.string(from: date))
                                .font(.system(size: 14))
                            
                            Circle()
                                .fill(.white)
                                .frame(width: 8, height: 8)
                                .opacity(calendar.isDate(date, inSameDayAs: selectedDate) ? 1 : 0)
                            
                        }
                        .foregroundStyle(calendar.isDate(date, inSameDayAs: selectedDate) ? .primary : .secondary)
                        .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate) ? .white : .black)
                        .frame(width: 45, height: 90)
                        .background(
                            ZStack {
                                if calendar.isDate(date, inSameDayAs: selectedDate) {
                                    Capsule()
                                        .fill(Color.black)
                                }
                            }
                        )
                    }
                },
                title: { date in
                    HStack {
                        Text(monthDayFormatter.string(from: selectedDate))
                            .font(.headline)
                            .padding(5)
                        Spacer()
                    }
                    .padding([.bottom, .leading], 10)
                }, weekSwitcher: { date in
                    Button {
                        withAnimation(.easeIn) {
                            guard let newDate = calendar.date(
                                byAdding: .weekOfMonth,
                                value: -1,
                                to: selectedDate
                            ) else {
                                return
                            }
                            
                            selectedDate = newDate
                        }
                    } label: {
                        Label(
                            title: { Text("Previous") },
                            icon: { Image(systemName: "chevron.left") }
                        )
                            .labelStyle(IconOnlyLabelStyle())
                            .padding(.horizontal)
                    }
                    Button {
                        withAnimation(.easeIn) {
                            guard let newDate = calendar.date(
                                byAdding: .weekOfMonth,
                                value: 1,
                                to: selectedDate
                            ) else {
                                return
                            }
                            
                            selectedDate = newDate
                        }
                    } label: {
                        Label(
                            title: { Text("Next") },
                            icon: { Image(systemName: "chevron.right") }
                        )
                            .labelStyle(IconOnlyLabelStyle())
                            .padding(.horizontal)
                    }
                }
            )
            
            ScrollView() {
                
                DiaryPerDayView()
            }
        }
        .fullScreenCover(isPresented: $isWriteSheetOn, content: WriteDiaryView.init)
    }
    
    func DiaryPerDayView() -> some View {
        LazyVStack(spacing: 10) {
            if let tasks = dairyModel.filteredDiary {
                if tasks.isEmpty {
                    Button {
                        isWriteSheetOn = true
                    } label: {
                        Text("챌린지 일지 작성")
                    }

                } else {
                    DiaryView()
                }
            } else {
                ProgressView()
                    .offset(y: 100)
            }
        }
        .padding()
        .padding(10)
        // MARK: - Updating Tasks
        .onChange(of: dairyModel.currentDay) { newValue in
            dairyModel.filterTodayDiary()
        }
    }
}
    
    
// MARK: - Component

public struct CalendarWeekListView<Day: View, Title: View, WeekSwiter: View>: View {
    // Injected dependencies
    private var calendar: Calendar
    @Binding private var date: Date
    private let content: (Date) -> Day
    private let title: (Date) -> Title
    private let weekSwitcher: (Date) -> WeekSwiter
    
    // Constants
    private let daysInWeek = 7
    
    public init(
        calendar: Calendar,
        date: Binding<Date>,
        @ViewBuilder content: @escaping (Date) -> Day,
        @ViewBuilder title: @escaping (Date) -> Title,
        @ViewBuilder weekSwitcher: @escaping (Date) -> WeekSwiter
    ) {
        self.calendar = calendar
        self._date = date
        self.content = content
        self.title = title
        self.weekSwitcher = weekSwitcher
    }
    
    public var body: some View {
        let month = date.startOfMonth(using: calendar)
        let days = makeDays()
        
        VStack {
            HStack {
                self.title(month)
                self.weekSwitcher(month)
            }
            HStack {
                ForEach(days, id: \.self) { date in
                    content(date)
                }
                
            }
            
            Divider()
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
}
    
// MARK: - Conformances
    
extension CalendarWeekListView: Equatable {
    public static func == (lhs: CalendarWeekListView<Day, Title, WeekSwiter>, rhs: CalendarWeekListView<Day, Title, WeekSwiter>) -> Bool {
        lhs.calendar == rhs.calendar && lhs.date == rhs.date
    }
}
    
// MARK: - Helpers
    
private extension CalendarWeekListView {
    func makeDays() -> [Date] {
        guard let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: date),
                let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: firstWeek.end - 1)
        else {
            return []
        }
            
        let dateInterval = DateInterval(start: firstWeek.start, end: lastWeek.end)
            
        print(calendar.generateDays(for: dateInterval))
            
        return calendar.generateDays(for: dateInterval)
    }
}
    
private extension Calendar {
    func generateDates(
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates = [dateInterval.start]
            
        enumerateDates(
            startingAfter: dateInterval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date = date else { return }
                
            guard date < dateInterval.end else {
                stop = true
                return
            }
                
            dates.append(date)
        }
            
        return dates
    }
        
    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(
            for: dateInterval,
                matching: dateComponents([.hour, .minute, .second], from: dateInterval.start)
        )
    }
}
    
private extension Date {
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
        
    func startOfDayTime(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.hour, .minute], from: self)
        ) ?? self
    }
}
    
private extension DateFormatter {
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
    }
}
// MARK: - Previews

#if DEBUG
struct CalendarWeekView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HabitDetailView(calendar: Calendar(identifier: .gregorian))
        }
    }
}
#endif
