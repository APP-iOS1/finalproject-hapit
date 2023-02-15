//
//  Badge.swift
//  Hapit
//
//  Created by greenthings on 2023/02/07.
//

import Foundation

class Badge: Identifiable, Equatable {
    var id: String
    var imageName: String
    var title: String
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
