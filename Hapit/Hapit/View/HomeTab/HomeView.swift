//
//  HomeView.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/17.
//

import SwiftUI
import SegmentedPicker

struct HomeView: View {
    
    @ObservedObject var fcmManager: FCMManager = FCMManager()

    @State private var isAddHabitViewShown: Bool = false
    @State private var habitTypeList: [String] = ["챌린지", "습관"]
    @State var selectedIndex: Int = 0
    
    @EnvironmentObject var habitManager: HabitManager
    @EnvironmentObject var authManager: AuthManager

    init() {
        // Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "IMHyemin-Bold", size: 30)!]
        
        // Use this if NavigationBarTitle is with displayMode = .inline
        // UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 20)!]
    }
    
    var body: some View {
        NavigationView{
            VStack {
                //MARK: 세그먼트 뷰.
                //챌린지와 완성된 습관을 세그먼트 뷰로 확인할 수 있습니다.
                SegmentedPicker(
                    habitTypeList,
                    selectedIndex: Binding(
                        get: { selectedIndex },
                        set: { selectedIndex = $0 ?? 0 }),
                    selectionAlignment: .bottom,
                    content: { item, isSelected in
                        Text(item)
                            .foregroundColor(isSelected ? Color.accentColor : Color.gray )
                        //.padding(.horizontal, 70)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .font(.custom("IMHyemin-Bold", size: 17))
                    },
                    selection: {
                        VStack(spacing: 0) {
                            Spacer()
                            Color.accentColor.frame(height: 2)
                                .clipShape(Capsule())
                                .frame(maxWidth: .infinity)
                        }
                        
                    })
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                .animation(.easeInOut(duration: 0.3)) // iOS 15는 animation을 사용할 때 value를 꼭 할당해주거나 withAnimation을 써야 함.
                .onAppear {
                    selectedIndex = 0
                }
                //.padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
                
                //MARK: 세그먼트디테일뷰
                HabitSegmentDetailView(selectedIndex: $selectedIndex)
            }//VStack
            .background(Color("BackgroundColor").ignoresSafeArea())
            .navigationBarTitle(getToday())
            //MARK: 툴바 버튼. 습관 작성하기 뷰로 넘어간다.
            .toolbar {
                Button {
                    isAddHabitViewShown.toggle()
                } label: {
                    Label("Add Habit", systemImage: "plus.app")
                }
                
            }//toolbar
        }//NavigationView
        .sheet(isPresented: $isAddHabitViewShown) {
            AddChallengeView()
        }
    }//body
    
    func getToday() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yy년 MM월 dd일" // "yyyy-MM-dd HH:mm:ss"
        
        let dateCreatedAt = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
        
        return dateFormatter.string(from: dateCreatedAt)
    }
}
