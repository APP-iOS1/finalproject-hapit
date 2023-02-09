//
//  BadgeGridView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct JellyGridView: View {
    //let data = Array(1...20)
    
    @EnvironmentObject var authManager: AuthManager
    
    @State var badgeList: [Badge] = []
    
    // @State var imageData: Data = Data()
    
    //화면을 그리드형식으로 꽉채워줌
    let columns = [
        GridItem(.adaptive(minimum: 100),spacing: 30),
        GridItem(.adaptive(minimum: 100),spacing: 30),
        GridItem(.adaptive(minimum: 100),spacing: 30),
    ]
    
    var body: some View {
        ScrollView{
            VStack{
                
                LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                    
                    ForEach(authManager.bearBadges, id: \.id) { badge in
                            JellyBadgeView(badge: badge)
                        }
                }
                
            }
            .padding()
        }
        .onAppear{
            
            authManager.bearBadges.removeAll()
  

            Task{
                
                //the ID bearGreen occurs multiple times within the collection, this will give undefined results!
                //authManager.bearBadges = []
                //badgeList = []
                
                for badge in 0..<20{
                    
                    let id = UUID().uuidString
                    
                    authManager.bearBadges.append(Badge(id: id, imageName: "", title: "", imageData: Data()))
                }
                
                for (badgeName, data) in zip(authManager.newBadges, authManager.bearimagesDatas){
                    // This is closure, and I can use return value.
                    // Below is only one programming
                    //self.imageData = authManager.bearimagesData
                    //print("imagedata in view \(imageData)")
                    let id = UUID().uuidString
                    let newBadge = Badge(id: id, imageName: badgeName, title: showmetheTitle(imageName: badgeName), imageData: data)
                    //badgeList.append(newBadge)
                    print("badge title: \( newBadge.title )")
                    print("new name: \( newBadge.imageName )")
                    //                    print("bearbadges: \(authManager.bearBadges)")
                    
                    //                    print("new badge: \( newBadge.imageData )")
                    // 탭을 다른 곳으로 갔다와야 출력이 됨.
                    //authManager.bearBadges.append(newBadge)
                    // 비어있는 곰을 출력하기 위한 노력
                    authManager.bearBadges.append(newBadge)
                    // 멀티플 아이디 에러생김 the ID bearBlue2 occurs multiple times within the collection, this will give undefined results!
//                    for index in 0..<badgeList.count{
//
//                        badgeList[index] = newBadge
//
//                    }
                    //badgeList.p
                    
                    // Initialization BearimageData for getting much bear data
                    //authManager.bearimagesData = Data()
                }
                print("badgelist: \(badgeList)")
                print("bearbadges: \(authManager.bearBadges)")
                authManager.bearBadges = authManager.bearBadges.reversed()
            }
        }
    }
    
    func showmetheTitle(imageName: String) -> String{
        
        switch imageName{
            case "bearBlue1":
                return "첫 습관 달성"
            case "bearBlue2":
                return "첫 챌린지!!"
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
