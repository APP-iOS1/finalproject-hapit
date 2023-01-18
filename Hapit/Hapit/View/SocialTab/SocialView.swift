//
//  SocialView.swift
//  Hapit
//
//  Created by 김예원 on 2023/01/17.
//

import SwiftUI

struct User: Identifiable {
    let id : String
    let name: String
    let profileImage: String
    let challenge: [String]
    
}
struct Users {
    let users = [
        User(id: "1",name: "박민주", profileImage: "bearBlue",challenge: ["물마시기","물마시기2","물마시기3"]),
        User(id: "2",name: "김예원", profileImage: "bearGreen",challenge: ["아침먹기","아침먹기2","아침먹기3"]),
        User(id: "3",name: "추현호", profileImage: "bearYellow",challenge: ["점심먹기3"]),
        User(id: "4",name: "이주희", profileImage: "bearPurple",challenge: ["저녁먹기2","저녁먹기3"])
            ]
}

struct SocialView: View {
    let friends = Users()
    
    var body: some View {
        VStack{
            Text("해핏 친구들 랭킹")
                .font(.title)
                .bold()
                .padding()
            List(friends.users){ user in
               
                FriendsRow(friends: user)
                
            }
            Text("")
        }
    }
}
struct FriendsRow: View {
  let friends: User
  
  var body: some View {
    HStack {
       Image(friends.profileImage)
            .resizable()
            .scaledToFit()
            .frame(width: 40)
        .padding()
        .cornerRadius(6)
      
      Text(friends.name)
      
      Spacer()
        Text("\(friends.challenge.count)")
    }
  }
}


struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
    }
}
