//
//  User.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/20.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let email: String
    let pw: String
    let proImage: String
    let badge: [String]
}
