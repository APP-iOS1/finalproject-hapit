//
//  BadgeGridView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct JellyGridView: View {
    let data = Array(1...20).map { "목록 \($0)"}
    
    @EnvironmentObject var authManager: AuthManager
    
    var badgeList: [Badge] = []
    
    //화면을 그리드형식으로 꽉채워줌
    let columns = [
        GridItem(.adaptive(minimum: 100),spacing: 30),
        GridItem(.adaptive(minimum: 100),spacing: 30),
        GridItem(.adaptive(minimum: 100),spacing: 30),
    ]
    
    var body: some View {
        ScrollView{
            VStack{
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(authManager.bearimagesDatas, id: \.self) { badge in
                        JellyBadgeView(badge: badge)
                    }
                }
                
            }
            .padding()
        }
        .onAppear{
            Task{
                // String에 뱃지 이름을 String으로 가져옴.
                try await authManager.fetchBadgeList(uid: authManager.firebaseAuth.currentUser?.uid ?? "")
                // String 타입인 뱃지이름을 활용하여 Data를 가져옴.
                self.authManager.fetchImages(paths: authManager.badges)
                
                for badge in authManager.badges{
                    let newBadge = Badge(imageName: badge, title: showmetheTitle(imageName: badge))
                    print(newBadge.title)
                    //badgeList.append(newBadge)
                }
            }
        }
    }
    
    func showmetheTitle(imageName: String) -> String{
        
        switch imageName{
            case "bearBlue1":
                return "첫 습관 달성"
            case "bearBlue2":
                return "첫 챌린지 생성"
            case "bearGreen":
                return "작심삼일"
            case "bearPurpleB":
                return "첫 친구"
            case "bearRed":
                return "마음이 갈대밭"
            case "bearTurquoise":
                return "처음 가입"
            case "bearYellow":
                return "보너스"
            default:
                return "비어 있음"
        }
    }
}

struct JellyGridView_Previews: PreviewProvider {
    static var previews: some View {
        JellyGridView()
    }
}

//
//// TODO: 뱃지 존재 여부에 따라 색깔 바꾸기
//if index == 0 {
//    JellyBadgeView(jellyImage: "bearBlue", jellyName: "첫 습관 달성")
//} else if index == 1 {
//    JellyBadgeView(jellyImage: "bearTurquoise", jellyName: "작심삼일")
//} else if index == 2 {
//    JellyBadgeView(jellyImage: "bearYellow", jellyName: "첫 친구")
//} else if index == 3 {
//    JellyBadgeView(jellyImage: "bearGreen", jellyName: "마음이 갈대밭")
//} else {
//    JellyBadgeView(jellyImage: "bearWhite", jellyName: "???")
//}
