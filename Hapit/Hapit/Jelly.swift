//
//  Jelly.swift
//  Hapit
//
//  Created by 이주희 on 2023/01/18.
//

import Foundation

struct Jelly {
    enum JellyBadge {
        case bearBlue
        case bearGreen
        case bearPurple
        case bearRed
        case bearTurquoise
        case bearWhite
        case bearYellow
        
        func switchString() -> String {
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

}
