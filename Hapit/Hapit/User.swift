//
//  User.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/20.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    var id: String
    var email: String
    var pw: String
    var name: String
    var image: String
}
