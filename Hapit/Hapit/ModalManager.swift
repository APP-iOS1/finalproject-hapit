//
//  ModalManager.swift
//  Hapit
//
//  Created by 박진형 on 2023/02/01.
//

import Foundation
import SwiftUI

class ModalManager: ObservableObject {
    
    @Published var modal: Modal = Modal(position: .closed, content: nil)
    
    func newModal<Content: View>(position: ModalState, @ViewBuilder content: () -> Content ) {
        modal = Modal(position: position, content: AnyView(content()))
    }
    
    func openModal() {
        modal.position = .open
    }
    
    func closeModal() {
        modal.position = .closed
    }
    
}

