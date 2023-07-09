//
//  ProfileModalView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct BearModalView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var showModal: Bool
    @Binding var isSelectedJelly: Int
    
    let bearArray = Jelly.allCases.map({"\($0)"})
    let data = Array(1...20).map { "목록 \($0)"}
    
    @EnvironmentObject var authManager: AuthManager
    
    //화면을 그리드형식으로 꽉채워줌
    let columns = [
        GridItem(.adaptive(minimum: 100),spacing: 5),
        GridItem(.adaptive(minimum: 100),spacing: 5),
        GridItem(.adaptive(minimum: 100),spacing: 5),
        GridItem(.adaptive(minimum: 100),spacing: 5),
        GridItem(.adaptive(minimum: 100),spacing: 5)
    ]
    
    var body: some View {
        VStack {
            Text("프로필 이미지 설정")
                .font(.custom("IMHyemin-Bold", size: 22))
            
            ScrollView {
                VStack {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(authManager.bearBadges) { badge in
                            Button {
                                dismiss()
                                showModal.toggle()
                                if badge.imageName != ""{
                                    self.isSelectedJelly = authManager.bearBadges.firstIndex(of: badge) ?? 0
                                }
                            } label: {
                                if badge.imageName != ""{
                                    Image(uiImage: UIImage(data: badge.imageData) ?? UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .padding(5)
                                        .overlay(RoundedRectangle(cornerRadius: 20)
                                            .stroke(self.isSelectedJelly == authManager.bearBadges.firstIndex(of: badge) ? Color("DarkPinkColor") : Color("GrayFontColor"),
                                                    lineWidth: 2))
                                } else {
                                    Image("bearLock")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .padding(5)
                                        .overlay(RoundedRectangle(cornerRadius: 20)
                                            .stroke(self.isSelectedJelly == authManager.bearBadges.firstIndex(of: badge) ? Color("DarkPinkColor") : Color("GrayFontColor"),
                                                    lineWidth: 2))
                                    
                                }
                            }
                        }
                    }
                }
                .padding(10)
            }
        }
        .padding()
    }
}

