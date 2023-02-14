//
//  KeyboardReadable.swift
//  Hapit
//
//  Created by 김응관 on 2023/02/13.
//

import Foundation
import UIKit
import Combine

extension KeyboardReadable {
    var keyboardEventPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge (
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in return true },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in return false }
            )
        .eraseToAnyPublisher()
    }
}

