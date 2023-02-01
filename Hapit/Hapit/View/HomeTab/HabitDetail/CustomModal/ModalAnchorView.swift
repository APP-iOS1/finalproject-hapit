//
//  ModalAnchorView.swift
//  Hapit
//
//  Created by 박진형 on 2023/02/01.
//

import SwiftUI

struct ModalAnchorView: View {
    
    @EnvironmentObject var modalManager: ModalManager
    
    var body: some View {
        ModalView(modal: $modalManager.modal)
    }
}

struct ModalAnchorView_Previews: PreviewProvider {
    static var previews: some View {
        ModalAnchorView()
    }
}
