//
//  Date.swift
//  Hapit
//
//  Created by 박진형 on 2023/01/30.
//

import Foundation

//MARK: 캘린더 뷰에 사용되는 모델
struct DateValue: Identifiable{
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
