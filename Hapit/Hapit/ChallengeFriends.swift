//
//  ChallengeFriends.swift
//  Hapit
//
//  Created by 김예원 on 2023/02/03.
//

import Foundation

struct ChallengeFriends: Identifiable, Hashable {
    var id = UUID()
    var isChecked: Bool = false
    var uid: String
    var proImage: String
    var name: String
 }
