//
//  NavigationBarColor.swift
//  Hapit
//
//  Created by 김응관 on 2023/02/06.
//

import Foundation
import SwiftUI

struct NavigationBarModifier: ViewModifier {

    var backgroundColor: UIColor?

    init(backgroundColor: UIColor?) {
        self.backgroundColor = .clear
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.largeTitleTextAttributes = [.font : UIFont(name: "IMHyemin-Bold", size: 30)!]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }

    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {
    func navigationBarColor(backgroundColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }
}
