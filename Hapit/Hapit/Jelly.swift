//
//  Jelly.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/18.
//

import Foundation

// CaseIterable 프로토콜을 채택하면 enum을 array처럼 순회 가능
enum Jelly: CaseIterable {
    case bearBlue
    case bearGreen
    case bearPurple
    case bearRed
    case bearTurquoise
    case bearWhite
    case bearYellow
    
    // TODO: 지울지 말지 고민중
    func jellyString() -> String {
        switch self {
        case .bearBlue:
            return "bearBlue"
        case .bearGreen:
            return "bearGreen"
        case .bearPurple:
            return "bearPurple"
        case .bearRed:
            return "bearRed"
        case .bearTurquoise:
            return "bearTurquoise"
        case .bearWhite:
            return "bearWhite"
        case .bearYellow:
            return "bearYellow"
        }
    }
}
