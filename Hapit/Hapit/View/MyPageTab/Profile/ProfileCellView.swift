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
    @State var showModal = false
    
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
                            Image("bearBlue")
                                .resizable()
                                .frame(width: 45, height: 60)
                                .background(Circle()
                                    .fill(Color(.systemGray6))
                                    .frame(width: 100, height: 100))
                        }
                        .disabled(showModal)
                        .padding(30)
                    }.sheet(isPresented: $showModal) { ProfileModalView(showModal: $showModal)
                            .presentationDetents([.medium])
                    }
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(nickName)")
                                    .font(.title3)
                                    .bold()
                                
                                Text("\(email)")
                                    .font(.title3)
                            }
                            .padding(.leading, 10)
                            Spacer()
                        }
                        
                        Button {
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke()
                                .frame(width: 220, height: 25)
                                .overlay{
                                    Text("프로필 편집")
                                        .foregroundColor(.accentColor)
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                }
                        }
                        .padding(.leading, 5)
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
