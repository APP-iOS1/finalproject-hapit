//
//  CustomAlert.swift
//  Hapit
//
//  Created by 박민주 on 2023/02/01.
//

import SwiftUI

struct CustomAlert: View {

  @Binding var isPresented: Bool
  let title: String
  let message: String
  let primaryButtonTitle: String
  let primaryAction: () -> Void
  let withCancelButton: Bool

  var body: some View {
    VStack(spacing: 12) {
      Text(title)
        .foregroundColor(.black)
        .font(.custom("IMHyemin-Bold", size: 20))
        .bold()

      Text(message)
            .font(.custom("IMHyemin-Regular", size: 17))
        .foregroundColor(.black)
        .multilineTextAlignment(.leading)
        .frame(minHeight: 60)

      HStack {
        if withCancelButton {
          Button(action: { isPresented = false }) {
            Text("취소")
                  .font(.custom("IMHyemin-Bold", size: 17))
              .padding(.vertical, 6)
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(.bordered)
          .tint(.accentColor)
        }

        Button {
          primaryAction()
          isPresented = false
        } label: {
          Text(primaryButtonTitle)
                .font(.custom("IMHyemin-Bold", size: 17))
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.accentColor)
      }
    }
    .padding(16)
    .frame(width: 300)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .stroke(Color.accentColor.opacity(0.5))
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(.white)
        )
    )
  }
}

struct CustomAlert_Previews: PreviewProvider {
  static var previews: some View {
    CustomAlert(
      isPresented: .constant(true),
      title: "타이틀",
      message: "메시지메시지메시지~",
      primaryButtonTitle: "확인!",
      primaryAction: { },
      withCancelButton: true)
  }
}

