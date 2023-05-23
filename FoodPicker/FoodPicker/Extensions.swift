//
//  Extensions.swift
//  FoodPicker
//
//  Created by Yu ZHANG on 2023/5/23.
//
import SwiftUI

extension View {
    func mainButtonStyle() -> some View{
        buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
    }
    
    func roundedRectBackgroud(radius: CGFloat = 8, fill: some ShapeStyle = .bg) -> some View {
        background(RoundedRectangle(cornerRadius: radius).foregroundStyle(fill))
    }
}

extension Animation {
    static let mySpring = Animation.spring(dampingFraction: 0.55)
    static let myEase = Animation.easeInOut(duration: 0.6)
}

extension ShapeStyle where Self == Color {
    static var bg: Color { Color(.systemBackground) }
    static var bg2: Color { Color(.secondarySystemBackground) }
}

extension AnyTransition {
    static let delayInsertionOpacity = AnyTransition.asymmetric(insertion: .opacity.animation(.easeInOut(duration: 0.5).delay(0.2)), removal: .opacity.animation(.easeInOut(duration: 0.4)))
    static let moveUpWithOpacity = AnyTransition.move(edge: .top).combined(with: .opacity)
}
