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
    @State var showModal = false
    @State var jellyBadge: Jelly = .bearBlue
    let bearArray = Jelly.allCases.map({"\($0)"})
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                //프로필 사진
                HStack {
                    VStack {
                        // User.profile
                        Button {
                            showModal = true
                        } label: {
                            Image(bearArray[isSelectedJelly % 7])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 45, height: 60)
                                .background(Circle()
                                    .fill(Color(.systemGray6))
                                    .frame(width: 90, height: 90))
                        }
                        .disabled(showModal)
                        .padding(30)
                    }.sheet(isPresented: $showModal) { ProfileModalView(showModal: $showModal, isSelectedJelly: $isSelectedJelly)
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
                            .padding(.leading, 12)
                            Spacer()
                        }
                        
                        // TODO: 프로필 편집 - 닉네임 변경
                        Button {
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke()
                                .frame(width: 210, height: 25)
                                .overlay{
                                    Text("프로필 편집")
                                        .foregroundColor(.accentColor)
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                }
                        }
                    }
                }
            }
            .padding()
            .background()
            .cornerRadius(20)
            .shadow(color: Color(.systemGray4), radius:3)
            Spacer()
        }
    }
}

struct ProfileCellView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCellView()
    }
}
