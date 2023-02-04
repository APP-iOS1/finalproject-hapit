//
//  EditFriendView.swift
//  Hapit
//
//  Created by 이주희 on 2023/02/04.
//

import SwiftUI

struct EditFriendView: View {
    @Binding var friends: [User]
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    // TODO: 본인 표시 해줘야함 -> 셀 색깔로?
                    ForEach(Array(friends.enumerated()), id: \.1) { (index, friend) in
                        FriendsRemoveRow(friend: friend)
                    }
                }
            }
        }.background(Color("BackgroundColor"))
    }
}

struct FriendsRemoveRow: View {
    let friend: User
    
    var body: some View {
        HStack {
            Image(friend.proImage)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(10)
            
                Text(friend.name)
                    .foregroundColor(.black)
                    .bold()
            
            Spacer()
            
            Button {
                
            } label: {
                Text("삭제")
                    .foregroundColor(.white)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .fill(Color.accentColor))
            }

        }
        .padding()
        .background(.white)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

//struct EditFriendView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditFriendView(friends: [User]())
//    }
//}
