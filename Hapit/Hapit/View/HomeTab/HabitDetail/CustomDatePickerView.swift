//
//  CustomDatePicker.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/30.
//

import SwiftUI

struct CustomDatePickerView: View {
    
    //MARK: - Property Wrappers
    @Binding var currentDate: Date
    @State var isShownModalView: Bool = false
    @State var postsForModalView: [Post] = []
    //MARK: 화살표 버튼을 통해 month를 업데이트 해주는 변수
    @State private var currentMonth: Int = 0
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var modalManager: ModalManager
    @EnvironmentObject var lnManager: LocalNotificationManager
    @Environment(\.scenePhase) var scenePhase
    @Binding var showsCustomAlert: Bool
    @State var showsCreatePostView: Bool = false
    @State var isChallengeAlarmOn: Bool = false // 챌린지의 알림이 켜져있는지 꺼져있는지의 값이 저장되는 변수
    @State var isShowingAlarmSheet: Bool = false // 챌린지 알림을 설정하는 시트를 띄우기 위한 변수
    
    // Login
    @EnvironmentObject var authManager: AuthManager
    
    // MARK: - Properties
    var currentChallenge: Challenge
    
    // MARK: - Body
    var body: some View {
        ZStack{
            VStack(spacing: 35){
                // Days
                let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
                
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(extraData(currentDate)[0])
                            .font(.custom("IMHyemin-Regular", size: 12))
                        Text(extraData(currentDate)[1])
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
                                postsForModalView = []
                                for post in habitManager.posts{
                                    if isSameDay(date1: currentDate, date2: post.createdAt){
                                        postsForModalView.append(post)
                                    }
                                }
                                print(postsForModalView)
                                self.modalManager.openModal()
                            }
                            .animation(.easeIn, value: currentDate)
                    }
                }
                Spacer()
            }//VStack
            .padding()
            .padding(.top, 0)
            .background(Color("CellColor"))
            .cornerRadius(20)
            .navigationBarTitle(currentChallenge.challengeTitle)
            .onChange(of: currentMonth) { newValue in
                currentDate = getCurrentMonth()
            }
            .onChange(of: scenePhase) { newValue in
                //앱이 작동중일 때
                //노티 authorize 해놓고 나가서 거부하고 다시 돌아오면 enable이 되어있음 => 값이 바뀌어서 씬을 업데이트 해준거임
                //
                if newValue == .active {
                    Task {
                        await lnManager.getCurrentSettings()
                        isChallengeAlarmOn = lnManager.isGranted
                    }
                }
            }
            .onAppear{
                // MARK: 포스트 불러오기
                //habitManager.loadPosts(id: "6ZZSFSl3vddeX4HVGL5P")
                habitManager.loadPosts(challengeID: currentChallenge.id, userID: authManager.firebaseAuth.currentUser?.uid ?? "")
                currentDate = Date()
                
                self.modalManager.newModal(position: .closed) {
                    PostModalView(postsForModalView: $postsForModalView)
                }
                Task {
                    await lnManager.getCurrentSettings()
                    print("lnManager.isGranted: \(lnManager.isGranted)")
                }
               
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // 챌린지 삭제
                        showsCustomAlert.toggle()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.gray)
                    } // label
                } // ToolbarItem
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // 챌린지 알림 설정
                        isChallengeAlarmOn.toggle()
                        if isChallengeAlarmOn { // 알림 버튼을 활성화할 때만 알림 설정 시트를 띄워야 함.
                            isShowingAlarmSheet.toggle()
                        } else { // 앱의 알림 설정을 해제시켜줘야 함.
                            lnManager.removeRequest(withIdentifier: currentChallenge.id)
                            isShowingAlarmSheet.toggle()
                        }
                    } label: {
                        Image(systemName: isChallengeAlarmOn ? "bell.fill" : "bell.slash.fill")
                            .foregroundColor(.gray)
                    } // label
                } // ToolbarItem
            } // toolbar
            .halfSheet(showSheet: $isShowingAlarmSheet) { // 챌린지 알림 설정 창 시트
                LocalNotificationSettingView(isChallengeAlarmOn: $isChallengeAlarmOn, challengeID: currentChallenge.id, challengeTitle: currentChallenge.challengeTitle)
                    .environmentObject(LocalNotificationManager())
            }
            
        }
        .sheet(isPresented: $showsCreatePostView) {
            DedicatedWriteDiaryView(currentChallenge: currentChallenge)
        }
    }
    //MARK: Methods
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View{
        VStack{
            if value.day != -1{
                if let diary = habitManager.posts.first(where: { diary in
                    return isSameDay(date1: diary.createdAt, date2: value.date)
                }){
                    Text("\(value.day)")
                        .font(.custom("IMHyemin-Bold", size: 20))
                        .foregroundColor(isSameDay(date1: diary.createdAt, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    Circle()
                    //.fill(isSameDay(date1: diary.createdAt, date2: currentDate) ? .pink : .pi)
                        .fill(.pink)
                        .frame(width: 8, height: 8)
                        .padding(.top, 20)
                    
                }else {
                    
                    Text("\(value.day)")
                        .font(.custom("IMHyemin-Bold", size: 20))
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                }
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
    func extraData(_ currentDate: Date) -> [String]{
        
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

//struct CustomDatePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomDatePickerView(currentChallenge: (Challenge(id: UUID().uuidString, creator: "릴루", mateArray: ["현호", "진형", "예원"], challengeTitle: "물 마시기", createdAt: Date(), count: 0, isChecked: true, uid: "")) , currentDate: .constant(Date()))
//    }
//}

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
