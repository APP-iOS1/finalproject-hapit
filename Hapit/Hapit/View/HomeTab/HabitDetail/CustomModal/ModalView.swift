//
//  ModalView.swift
//  Hapit
//
//  Created by 박진형 on 2023/02/01.
//

import SwiftUI

struct ModalView: View {
    
    // Modal State
    @Binding var modal: Modal
    @GestureState var dragState: DragState = .inactive
    
    var animation: Animation {
        Animation
            .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0)
            .delay(0)
    }
    
    var body: some View {
        // 30 이상 드래그 해야지 인식하는 drag 제스쳐
        let drag = DragGesture(minimumDistance: 30)
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
        }
        .onChanged {
            self.modal.dragOffset = $0.translation
        }
        .onEnded(onDragEnded)
        
        return GeometryReader(){ geometry in
            ZStack(alignment: .top) {
                Color.black
                    .opacity(self.modal.position != .closed ? 0.3 : 0)
                    .ignoresSafeArea()
                ZStack(alignment: .top) {
                    self.modal.content
                        .frame(height: UIScreen.main.bounds.height - (self.modal.position.offsetFromTop() + geometry.safeAreaInsets.top + self.dragState.translation.height))
                }
                .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .offset(y: max(0, self.modal.position.offsetFromTop() + self.dragState.translation.height + geometry.safeAreaInsets.top))
                .gesture(drag)
                .animation(self.dragState.isDragging ? nil : self.animation, value: modal.position)
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
    //MARK: 드래그가 끝나면 호출되는 함수
    private func onDragEnded(drag: DragGesture.Value) {
        
        // Setting stops
        let higherStop: ModalState
        let lowerStop: ModalState
        
        // Nearest position for drawer to snap to.
        let nearestPosition: ModalState
        
        // drag gesture의 방향을 결정해주는 변수
        let dragDirection = drag.predictedEndLocation.y - drag.location.y
        let offsetFromTopOfView = modal.position.offsetFromTop() + drag.translation.height
        
        // Determining whether drawer is above or below `.partiallyRevealed` threshold for snapping behavior.
        if offsetFromTopOfView <= ModalState.partiallyRevealed.offsetFromTop() {
            higherStop = .open
            lowerStop = .partiallyRevealed
        } else {
            higherStop = .partiallyRevealed
            lowerStop = .closed
        }
        
        // Determining whether drawer is closest to top or bottom
        if (offsetFromTopOfView - higherStop.offsetFromTop()) < (lowerStop.offsetFromTop() - offsetFromTopOfView) {
            nearestPosition = higherStop
        } else {
            nearestPosition = lowerStop
        }
        
        // Determining the drawer's position.
        if dragDirection > 0 {
            modal.position = lowerStop
        } else if dragDirection < 0 {
            modal.position = higherStop
        } else {
            modal.position = nearestPosition
        }
        
    }
    
}

enum DragState {
    
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}
