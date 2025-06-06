//
//  MiniLiftOff.swift
//  A focused SwiftUI component for smooth slide-up sheet transitions with progress tracking
//
//  Created by Petros Bantolas (petros@bantolas.dev)
//  
//  MIT License
//
//  Copyright (c) 2025 Petros Bantolas
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import SwiftUI

// MARK: - Public API

extension View {
    func miniLiftOff<Content: View>(
        isPresented: Binding<Bool>,
        progress: Binding<Double>,
        animation: Animation = .easeInOut,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(
            MiniLiftOffModifier(
                isPresented: isPresented,
                progress: progress,
                animation: animation,
                onDismiss: onDismiss,
                sheetContent: content
            )
        )
    }
}

// MARK: - Implementation

private struct MiniLiftOffModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var progress: Double
    let animation: Animation
    let onDismiss: (() -> Void)?
    let sheetContent: () -> SheetContent
    
    @State private var screenHeight: Double = 0.0
    
    private var heightOffset: Double {
        -progress * screenHeight
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .offset(y: heightOffset)
            
            sheetContent()
                .offset(y: screenHeight + heightOffset)
        }
        .background {
            GeometryReader { geometry in
                Color.clear
                    .preference(
                        key: ScreenHeightPreferenceKey.self,
                        value: geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
                    )
            }
        }
        .onPreferenceChange(ScreenHeightPreferenceKey.self) { height in
            if let height {
                screenHeight = height
            }
        }
        .onChange(of: isPresented) { _, newValue in
            withAnimation(animation) {
                progress = newValue ? 1.0 : 0.0
            }
            
            if !newValue {
                onDismiss?()
            }
        }
    }
}

// MARK: - Supporting Types

private struct ScreenHeightPreferenceKey: PreferenceKey {
    static var defaultValue: Double? = nil
    
    static func reduce(value: inout Double?, nextValue: () -> Double?) {
        value = nextValue() ?? value
    }
}