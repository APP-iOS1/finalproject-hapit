//
//  User.swift
//  Hapit
//
//  Created by 추현호 on 2023/01/17.
//

import Foundation

struct User: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    var userEmail: String // 유저 이메일
    var userImg: String //유저 이미지
    var userName: String //유저 이름
}
