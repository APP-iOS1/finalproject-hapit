//
//  ProfileView.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/17.
//

import SwiftUI

struct ProfileCellView: View {
    @State private var nickName = "릴루"
    @State private var email = "minju@world.com"
    @State private var isSelectedJelly = 0
    @State private var showBearModal = false
    @State private var showNicknameModal = false
    let bearArray = Jelly.allCases.map({"\($0)"})
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Button {
                        showBearModal = true
                    } label: {
                        Image(bearArray[isSelectedJelly % 7])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 60)
                            .background(Circle()
                                .fill(Color(.systemGray6))
                                .frame(width: 90, height: 90))
                    }
                    .disabled(showBearModal)
                    .padding(30)
                }.sheet(isPresented: $showBearModal) { BearModalView(showModal: $showBearModal, isSelectedJelly: $isSelectedJelly)
                        .presentationDetents([.medium])
                        .interactiveDismissDisabled()
                }
                
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(nickName)")
                                .font(.title3)
                                .bold()
                            
                            Text("\(email)")
                                .font(.caption)
                        }
                        .padding(.leading, 10)
                        Spacer()
                    }

                    Button {
                        showNicknameModal = true
                    } label: {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke()
                            .frame(width: 210, height: 25)
                            .overlay{
                                Text("닉네임 수정")
                                    .foregroundColor(.accentColor)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                            }
                    }
                    .sheet(isPresented: $showNicknameModal) { NicknameModalView(showModal: $showNicknameModal, userNickname: $nickName)
                            .presentationDetents([.medium])
                            .interactiveDismissDisabled()
                    }
                }
            }
            .padding(10)
        }
        .background()
        .cornerRadius(20)
        .shadow(color: Color(.systemGray4), radius:3)
        .padding(.horizontal)
        .padding(.top)
    }
}

struct ProfileCellView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCellView()
    }
}
