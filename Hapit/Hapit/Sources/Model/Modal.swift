//
//  Modal.swift
//  Hapit
//
//  Created by 박진형 on 2023/02/01.
//

import Foundation
import SwiftUI

enum ModalState: CGFloat {
    
    case closed ,partiallyRevealed, open
    
    func offsetFromTop() -> CGFloat {
        switch self {
        case .closed:
            return UIScreen.main.bounds.height
        case .partiallyRevealed:
            return UIScreen.main.bounds.height * (1 / 4)
        case .open:
            return 0
        }
    }
}

struct Modal {
    var position: ModalState = .closed
    var dragOffset: CGSize = .zero
    var content: AnyView?
}
