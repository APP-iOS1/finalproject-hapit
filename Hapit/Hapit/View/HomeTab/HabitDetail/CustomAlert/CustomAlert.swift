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
        .font(.custom("IMHyemin-Bold", size: 20))
        .padding(.top, 30)

      Text(message)
        .font(.custom("IMHyemin-Regular", size: 17))
        .multilineTextAlignment(.center)
        .padding(.bottom, 50)

      HStack {
        if withCancelButton {
          Button(action: { isPresented = false }) {
            Text("취소")
                  .font(.custom("IMHyemin-Bold", size: 17))
              .padding(.vertical, 10)
              .foregroundColor(.gray)
              .frame(maxWidth: .infinity)
          }
        }

        Button {
          primaryAction()
          isPresented = false
        } label: {
          Text(primaryButtonTitle)
                .font(.custom("IMHyemin-Bold", size: 17))
            .padding(.vertical, 10)
            .foregroundColor(.accentColor)
            .frame(maxWidth: .infinity)
        }
      }
    }
    .padding(15)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(Color("CellColor"))
    )
    .shadow(radius: 20)
    .padding(.horizontal, 40)
  }
}

struct CustomAlert_Previews: PreviewProvider {
  static var previews: some View {
    CustomAlert(
      isPresented: .constant(true),
      title: "타이틀",
      message: "메시지메시지메시지~",
      primaryButtonTitle: "확인",
      primaryAction: { },
      withCancelButton: true)
  }
}
