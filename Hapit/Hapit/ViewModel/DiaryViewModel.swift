////
////  DiaryViewModel.swift
////  Hapit
////
////  Created by 추현호 on 2023/01/17.

//import SwiftUI

//class DairyViewModel: ObservableObject {
//    @Published var storedDairy: [Dairy] = [
//        Dairy(title: "Meeting", description: "Discuss team task for the day", doneFlag: true, date: Date(timeInterval: 60, since: Date.now)),
//        Dairy(title: "English leeding", description: "", doneFlag: false, date: Date(timeInterval: 60*5, since: Date.now)),
//        Dairy(title: "lunch", description: "with Kevin", doneFlag: true, date: Date(timeInterval: 60*10, since: Date.now)),
//        Dairy(title: "breakfast", description: "with Alice", doneFlag: false, date: Date(timeInterval: 60*15, since: Date.now)),
//        Dairy(title: "coding", description: "It should be at least 100 lines.", doneFlag: false, date: Date(timeInterval: 60*20, since: Date.now)),
//        Dairy(title: "learn Go", description: "", doneFlag: true, date: Date(timeInterval: 60*25, since: Date.now)),
//        Dairy(title: "game", description: "", doneFlag: true, date: Date(timeInterval: 60*30, since: Date.now)),
//        Dairy(title: "buy the iphone", description: "", doneFlag: false, date: Date(timeInterval: 60*35, since: Date.now)),
//    ]
//    
//    // MARK: - Current Day
//    @Published var currentDay: Date = Date()
//    
//    // MARK: - Filtering Today Tasks
//    @Published var filteredDiary: [Dairy]?
//    
//    // MARK: - Initializing
//    init() {
//        filterTodayDiary()
//    }
//    
//    // MARK: - Filter Today Tasks
//    func filterTodayDiary() {
//        DispatchQueue.global(qos: .userInteractive).async {
//            let calendar = Calendar.current
//            let filtered = self.storedDairy.filter {
//                return calendar.isDate($0.date, inSameDayAs: self.currentDay)
//            }
//                .sorted { task1, task2 in
//                    return task2.date > task1.date
//                }
//            
//            DispatchQueue.main.async {
//                withAnimation {
//                    self.filteredDiary = filtered
//                }
//            }
//        }
//    }
//    
//    // MARK: - Checking if the currentHour is task Hour
//    func isCurrentHour(date: Date) -> Bool {
//        let calendar = Calendar.current
//        
//        let hour = calendar.component(.hour, from: date)
//        let currentHour = calendar.component(.hour, from: Date())
//        
//        return hour == currentHour
//    }
//}
//
