//
//  Dairy.swift
//  Hapit
//
//  Created by 추현호 on 2023/01/17.
//

import SwiftUI

struct Dairy: Identifiable {
    var id = UUID().uuidString
    var title: String
    var description: String
    var doneFlag: Bool
    var date: Date
}
