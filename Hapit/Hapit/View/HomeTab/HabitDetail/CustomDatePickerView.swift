//
//  CustomDatePicker.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/30.
//

import SwiftUI
import RealmSwift

struct CustomDatePickerView: View {
    
    private let timeIntervalAfter66Days: TimeInterval = 60 * 60 * 24 * 66
    //MARK: - Property Wrappers
    @Binding var currentDate: Date
    @State var isShownModalView: Bool = false
    @State var postsForModalView: [Post] = []
    //MARK: 화살표 버튼을 통해 month를 업데이트 해주는 변수
    @State private var currentMonth: Int = 0
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var modalManager: ModalManager
    @EnvironmentObject var lnManager: LocalNotificationManager
    @EnvironmentObject var userInfoManager: UserInfoManager
    @Environment(\.scenePhase) var scenePhase
    @State private var showsCustomAlert: Bool = false
    @State var showsCreatePostView: Bool = false
    @State var isChallengeAlarmOn: Bool = false // 챌린지의 알림이 켜져있는지 꺼져있는지의 값이 저장되는 변수
    @State var isShowingAlarmSheet: Bool = false // 챌린지 알림을 설정하는 시트를 띄우기 위한 변수
    @State private var isAlertOn = false // OptionView에서 설정해달라고 애원하는 시트
    @ObservedRealmObject var localChallenge: LocalChallenge // 로컬챌린지에서 각 필드를 업데이트 해주기 위해 선언 - 담을 그릇
    @ObservedResults(LocalChallenge.self) var localChallenges // 새로운 로컬챌린지 객체를 담아주기 위해 선언 - 데이터베이스

    @AppStorage("isUserAlarmOn") var isUserAlarmOn: Bool = false
    
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
                        currentMonth -= 1
                    } label: {
                        Image(systemName: "chevron.left")
                    }//Button
                    .animation(.easeIn, value: currentMonth)
                    
                    Button {
                        currentMonth += 1
                    } label: {
                        Image(systemName: "chevron.right")
                    }//Button
                    
                }// HStack
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
                .padding(.top, -20)
                
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
                                self.modalManager.openModal()
                                habitManager.currentMateInfos = []
                                
                                Task{
                                    // customModalView에서 불러온 mateArray의 순서를 변경할 필요가 있다.
                                    // CurrentUser의 uid가 mateArray[0으로 와야함]
                                    habitManager.currentMateInfos = []
                                    let current = authManager.firebaseAuth
                                    let currentUser = current.currentUser?.uid
                                    let mateArray = habitManager.currentChallenge.mateArray
                                    var sortedMateArray = sortMateArray(mateArray, currentUserUid: currentUser ?? "")
                                    
                                    // currentMateInfo를 초기화 해주는 부분.
                                    // 초기화를 하지 않는다면 onAppear 할 때마다 currentInfo가 늘어난다.
                                    for member in sortedMateArray {
                                        let userInfo = try await userInfoManager.getUserInfoByUID(userUid: member)
                                        habitManager.currentMateInfos.append(userInfo ?? User(id: "", name: "", email: "", pw: "", proImage: "", badge: [], friends: []))
                                    }
                                }
                                
                            }
                            .animation(.easeIn, value: currentDate)
                    }
                }
                .padding(.top, -20)
                //Spacer()
            }//VStack
            .padding([.top, .leading, .trailing])
            .background(Color("CellColor"))
            .cornerRadius(20)
            .navigationBarTitle(currentChallenge.challengeTitle)
            .ignoresSafeArea()
            .onChange(of: currentMonth) { newValue in
                currentDate = getCurrentMonth()
            }
            .onChange(of: scenePhase) { newValue in
                //앱이 작동중일 때
                //노티 authorize 해놓고 나가서 거부하고 다시 돌아오면 enable이 되어있음 => 값이 바뀌어서 씬을 업데이트 해준거임
                if newValue == .active {
                    Task {
                        await lnManager.getCurrentSettings()
                        // 마이페이지에서 알림이 꺼지면 해당 뷰에서의 알림이 같이 꺼져야 함.
                        // 하지만 그 반대는 생각 안 해줘도 됨. 마이페이지에서 알림이 켜져있다면 해당 뷰에서 알림 껐켰은 자유
                        if !lnManager.isAlarmOn {
                            isChallengeAlarmOn = lnManager.isAlarmOn
                            // Realm에 해당 챌린지 알림 설정 업데이트
                            $localChallenge.isChallengeAlarmOn.wrappedValue = lnManager.isAlarmOn
                        } else {
                            isChallengeAlarmOn = $localChallenge.isChallengeAlarmOn.wrappedValue
                        }
                        
                        // 아이폰 설정 알림이 꺼지면 해당 뷰에서의 알림이 같이 꺼져야 함.
                        // 하지만 그 반대는 생각 안 해줘도 됨. 아이폰 설정 알림이 켜져있다면 해당 뷰에서 알림 껐켰은 자유
                        if !lnManager.isGranted {
                            isChallengeAlarmOn = lnManager.isGranted
                            // Realm에 해당 챌린지 알림 설정 업데이트
                            $localChallenge.isChallengeAlarmOn.wrappedValue = lnManager.isAlarmOn
                        }
                    }
                }
            }
            .onAppear{
                // MARK: 포스트 불러오기
                habitManager.fetchChallenge(challengeID: currentChallenge.id)
                habitManager.loadPosts(challengeID: currentChallenge.id, userID: authManager.firebaseAuth.currentUser?.uid ?? "")
                currentDate = Date()
                
                self.modalManager.newModal(position: .closed) {
                    PostModalView(postsForModalView: $postsForModalView)
                        .offset(y: 200)
                }
                Task {
                    await lnManager.getCurrentSettings()
                }
                
                lnManager.isAlarmOn = isUserAlarmOn
                
                // 마이페이지에서 알림이 꺼지면 해당 뷰에서의 알림이 같이 꺼져야 함.
                // 하지만 그 반대는 생각 안 해줘도 됨. 마이페이지에서 알림이 켜져있다면 해당 뷰에서 알림 껐켰은 자유
                if !lnManager.isAlarmOn {
                    isChallengeAlarmOn = lnManager.isAlarmOn
                    // Realm에 해당 챌린지 알림 설정 업데이트
                    $localChallenge.isChallengeAlarmOn.wrappedValue = lnManager.isAlarmOn
                } else {
                    isChallengeAlarmOn = $localChallenge.isChallengeAlarmOn.wrappedValue
                }
                
                // 아이폰 설정 알림이 꺼지면 해당 뷰에서의 알림이 같이 꺼져야 함.
                // 하지만 그 반대는 생각 안 해줘도 됨. 아이폰 설정 알림이 켜져있다면 해당 뷰에서 알림 껐켰은 자유
                if !lnManager.isGranted {
                    isChallengeAlarmOn = lnManager.isGranted
                    // Realm에 해당 챌린지 알림 설정 업데이트
                    $localChallenge.isChallengeAlarmOn.wrappedValue = lnManager.isAlarmOn
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //MARK: 챌린지 삭제
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
                        
                        // Realm에 해당 챌린지 알림 설정 업데이트
                        $localChallenge.isChallengeAlarmOn.wrappedValue = isChallengeAlarmOn
                        
                        if isChallengeAlarmOn { // 알림 버튼을 활성화할 때만 알림 설정 시트를 띄워야 함.
                            if lnManager.isAlarmOn {
                                isAlertOn = false
                                isShowingAlarmSheet = true
                                isChallengeAlarmOn = true
                                
                            } else {
                                isAlertOn = true
                                isShowingAlarmSheet = false
                                isChallengeAlarmOn = false
                            }
                        } else { // 앱의 알림 설정을 해제시켜줘야 함.
                            // lnManger schedule에서 삭제
                            lnManager.removeRequest(withIdentifier: currentChallenge.id)
                            isShowingAlarmSheet = false
                            isChallengeAlarmOn = false
                        }
                    } label: {
                        Image(systemName: isChallengeAlarmOn ? "bell.fill" : "bell.slash.fill")
                            .foregroundColor(.gray)
                    } // label
                } // ToolbarItem
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //MARK: 챌린지 추가
                        showsCreatePostView.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.gray)
                    } // label
                } // ToolbarItem
            } // toolbar
            .halfSheet(showSheet: $isShowingAlarmSheet) { // 챌린지 알림 설정 창 시트
                ForEach(localChallenges) { localChallenge in
                    if localChallenge.challengeId == currentChallenge.id {
                        LocalNotificationSettingView(localChallenge: localChallenge, isChallengeAlarmOn: $isChallengeAlarmOn, isShowingAlarmSheet: $isShowingAlarmSheet, challengeID: currentChallenge.id, challengeTitle: currentChallenge.challengeTitle)
                            .environmentObject(LocalNotificationManager())
                            .environmentObject(HabitManager())
                    }
                }
            }
        }
        .sheet(isPresented: $showsCreatePostView) {
            DedicatedWriteDiaryView(currentChallenge: currentChallenge)
        }
        .customAlert( // 커스텀 알림창 띄우기
            isPresented: $isAlertOn,
            title: "알림을 켜주세요!",
            message: "마이페이지 > 설정 > 알림",
            primaryButtonTitle: "확인",
            primaryAction: { isAlertOn = false },
            withCancelButton: false)
        .customAlert( // 커스텀 알림창 띄우기
            isPresented: $showsCustomAlert,
            title: "챌린지를 삭제하시겠어요?",
            message: "삭제된 챌린지는 복구할 수 없어요.",
            primaryButtonTitle: "삭제",
            primaryAction: {
                // Firestore에서 챌린지 삭제
                habitManager.removeChallenge(challenge: currentChallenge)
                // Realm에서 챌린지 삭제
                $localChallenges.remove(localChallenge)
            },
            withCancelButton: true)
        
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
                    
                } else {
                    
                    Text("\(value.day)")
                        .font(.custom("IMHyemin-Bold", size: 20))
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                }
            }
            if (isSameDay(date1: value.date, date2: currentChallenge.createdAt.addingTimeInterval(timeIntervalAfter66Days))){
                Text("D-day")
                    .font(.custom("IMHyemin-Regular", size: 10))
                    .foregroundColor(.accentColor)
                    
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
    
    func sortMateArray(_ mateArray: [String], currentUserUid: String) -> [String] {
        var currentUserArray: [String] = []
        var otherMatesArray: [String] = []
        
        for uid in mateArray {
            
            if uid == currentUserUid {
                currentUserArray.append(uid)
            }
            else {
                otherMatesArray.append((uid))
            }
        }
        
        let tempArray = currentUserArray + otherMatesArray
        
        return tempArray
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
