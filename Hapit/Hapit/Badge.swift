//
//  Badge.swift
//  Hapit
//
//  Created by greenthings on 2023/02/07.
//

import Foundation

class Badge: Identifiable, Equatable {
    // 서버에서 이미지를 가져오는 순서
    // storage에 접근
    // storage에 Jellysbear 폴더에 접근
    // 해당 이름 "bearYellow"
    // 가져옵니다. (.png) 형식으로
    // 로컬에 Data 형식으로 저장을 해요.
    // 이것이 Badge에 imageData 이에여.
    // imageData만 있으면, 이미지 표시 가능.
    
    // Foreach문을 위해
    var id: String
    // BearYellow
    var imageName: String
    // 첫 가입 축하
    var title: String
    // UIImage에 넣을 데이타
    var imageData: Data
    
    init(id: String, imageName: String, title: String, imageData: Data) {
        self.id = id
        self.imageName = imageName
        self.title = title
        self.imageData = imageData
    }
    
    static func ==(lhs: Badge, rhs: Badge) -> Bool {
        return lhs.id == rhs.id && lhs.imageName == rhs.imageName && lhs.title == rhs.title && lhs.imageData == rhs.imageData
    }
    
    subscript(index: Int) -> String {
        switch index {
        case 0: return imageName
        case 1: return id
        //case 2: return imageData
        default: return ""
        }
    }
    
    
}
