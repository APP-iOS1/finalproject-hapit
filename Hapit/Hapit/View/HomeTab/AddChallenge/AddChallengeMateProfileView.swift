//
//  AddChallengeMateProfileView.swift
//  Hapit
//
//  Created by 김예원 on 2023/01/31.
//

import SwiftUI

struct AddChallengeMateProfileView: View {
    @State private var isSelectedJelly = 0
    @State private var showBearModal = false
  //  @State var selectedMate: SelectedMateArray
    let bearArray = Jelly.allCases.map({"\($0)"})
    var mateName: String
    var proImage: String
    
    var body: some View {
                   
                VStack{
                    // 이미지 부분에 해당하는 사람의 프로필 데이터를 받아와야 함
                    Image(bearArray[isSelectedJelly % 7])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 40)
                        .background(Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 60, height: 60))
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    Text("\(mateName)")
                }
            
    }
}

//struct AddChallengeMateProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddChallengeMateProfileView(selectedMate: .init(mateName: "yewon"))
//    }
//}
