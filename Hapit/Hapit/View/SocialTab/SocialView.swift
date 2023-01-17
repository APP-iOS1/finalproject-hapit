//
//  SocialView.swift
//  Hapit
//
//  Created by 김예원 on 2023/01/17.
//

import SwiftUI

var dummyFriendsData: [String] = ["진형", "응관", "예원", "민주", "주희", "현호", "현준" ]

var currentFriendsData: [String] = []

struct SocialView: View {
    @State var searchText: String = ""
    
    
    var data = dummyFriendsData.map(DummyFriendData.init)
    var filteredData: [DummyFriendData] {
        if searchText.isEmpty{
            return data
        } else {
            return data.filter { $0.name.localizedStandardContains(searchText)}
        }

    }
    
    
    var body: some View {
        NavigationStack{
            List(filteredData){ data in
                Text(data.name)
            }
        }
        
        .searchable(text: $searchText, prompt: "친구의 아이디")
        .onSubmit(of: .search) {
            currentFriendsData.append(searchText)
        }
        .navigationTitle("소셜")
    }
}

struct DummyFriendData: Identifiable{
    var name: String
    var id: String { self.name }
}


struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
    }
}
