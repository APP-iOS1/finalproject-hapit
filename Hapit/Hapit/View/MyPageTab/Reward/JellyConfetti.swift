//
//  JellyConfetti.swift
//  Hapit
//
//  Created by greenthings on 2023/02/11.
//

import Foundation
import SwiftUI

struct JellyConfetti: View{
    
    var title: String
    
    var body: some View {
        ZStack {
            Image("bearTurquoise")
                .resizable()
                .aspectRatio(contentMode: .fit)
//                .fill(Color.blue)
                .frame(width:CGFloat(Int.random(in: 100..<150)) ,height: CGFloat(Int.random(in: 100..<150)))
                .rotationEffect(.degrees(Double(Int.random(in: -360..<0))))
                                                .rotation3DEffect(.degrees(Double(Int.random(in: 0..<45))), axis: (x: 1, y: 1, z: 1))
                .modifier(ParticlesModifier())
                .offset(x: 40, y: 50)
                    
            Image("bearYellow")
                .resizable()
                .aspectRatio(contentMode: .fit)
//                .fill(Color.red)
                .frame(width:CGFloat(Int.random(in: 100..<150)) ,height: CGFloat(Int.random(in: 100..<150)))
                .rotationEffect(.degrees(Double(Int.random(in: -360..<0))))
                                                .rotation3DEffect(.degrees(Double(Int.random(in: 0..<45))), axis: (x: 1, y: 1, z: 1))
                .modifier(ParticlesModifier())
                .offset(x: 40, y: 50)
        }
    }
}

struct ParticlesModifier: ViewModifier {
    @State var time = 0.0
    @State var scale = 0.8
    let duration = 5.0
    
    func body(content: Content) -> some View {
        ZStack {
            ForEach(0..<10, id: \.self) { index in
                content
                    .hueRotation(Angle(degrees: time * 80))
                    .scaleEffect(scale)
                    .modifier(FireworkParticlesGeometryEffect(time: time))
                    .opacity(((duration - time) / duration))
            }
        }
        .onAppear {
            withAnimation (.easeOut(duration: duration)) {
                self.time = duration
                self.scale = 1.0
            }
        }
    }
}

struct FireworkParticlesGeometryEffect : GeometryEffect {
    var time: Double
    var speed = Double.random(in: 20 ... 200)
    var direction = Double.random(in: -Double.pi ... Double.pi)
    
    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        let xTranslation = speed * cos(direction) * time
        let yTranslation = speed * sin(direction) * time
        let affineTranslation = CGAffineTransform(translationX: xTranslation, y: yTranslation)
        return ProjectionTransform(affineTranslation)
    }
}
