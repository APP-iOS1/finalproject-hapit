//
//  View+ShakeEffect.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/31.
//

import Foundation
import SwiftUI

extension View {

  /// 흔들리는 효과를 줍니다! 트리거가 true 가 되면 흔들림
  func shakeEffect(trigger: Bool) -> some View {
    modifier(ShakeEffect(trigger: trigger))
  }
}

struct ShakeEffect: ViewModifier {

  var trigger: Bool

  @State private var isShaking = false

  func body(content: Content) -> some View {
    content // 수정자가 적용되는 곳 '위' 까지의 View
      .offset(x: isShaking ? -6 : .zero)
      .animation(.default.repeatCount(3).speed(6), value: isShaking)
      .onChange(of: trigger) { newValue in
        guard newValue else { return }
        isShaking = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          isShaking = false
        }
      }
  }
}
