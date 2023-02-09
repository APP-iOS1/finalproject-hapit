//
//  Badge.swift
//  Hapit
//
//  Created by greenthings on 2023/02/07.
//

import Foundation

class Badge: Identifiable{
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
    
}
