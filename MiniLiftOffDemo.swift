//
//  MiniLiftOffDemo.swift
//  TransitionBackground
//
//  Created by Petros Bantolas on 06/06/2025.
//

import SwiftUI

struct MiniLiftOffDemo: View {
    @State private var showSheet = false
    @State private var transitionProgress = 0.0

    var body: some View {
        LiftOffDemoHomeView {
            showSheet = true
        }
        .scaleEffect(1.0 - transitionProgress * 0.1)
        .blur(radius: transitionProgress * 20.0)
        .miniLiftOff(
            isPresented: $showSheet,
            progress: $transitionProgress,
            animation: .easeInOut,
            onDismiss: {
                showSheet = false
            }
        ) {
            LiftOffDemoSheetView {
                showSheet = false
            }
        }
    }
}

struct LiftOffDemoHomeView: View {
    var onAction: (() -> Void)? = nil
    let meterHeightPct = 0.5

    let padding = 16.0

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ///header
                HStack {
                    Text("MiniLiftOff Demo")
                    Spacer()
                }
                .font(.title)

                VStack(spacing: 4) {
                    Text("750ml")
                        .font(.title)
                        .fontDesign(.rounded)

                    Text("Smooth transitions, 34% progress")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, padding)

                RoundedRectangle(cornerRadius: 20)
                    .fill(.tertiary)
                    .frame(width: 100, height: meterHeightPct * 700)
                    .overlay(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.brown.gradient)
                            .frame(height: 0.34 * meterHeightPct * 700)
                    }
                    .padding(.top, padding)

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { id in
                            RoundedRectangle(cornerRadius: 16)
                                .fill([.red, .blue, .green, .purple].randomElement() ?? .gray)
                                .frame(width: 80, height: 100)
                        }
                    }
                }
                .padding(.top, padding)

                Text("there is more text down here that goes below the fold")
                    .font(.title2)
                    .frame(maxWidth: 300)
                    .padding(.top, padding)
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            Button {
                onAction?()
            } label: {
                HStack {
                    Image(systemName: "airplane.departure")
                        .font(.title2.weight(.bold))
                        .fontDesign(.rounded)
                    Text("LIFT OFF")
                        .font(.title2.weight(.bold))
                        .fontDesign(.rounded)
                }
                .foregroundStyle(.primary)
                .padding(18)
                .frame(maxWidth: .infinity)
                .background(Capsule().fill(.blue))
            }
            .buttonStyle(.plain)
        })
        .padding(.horizontal, 16)
    }
}

struct LiftOffDemoSheetView: View {
    let onDismiss: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("MiniLiftOff Sheet")
                Spacer()
                Button {
                    onDismiss()
                } label: {
                    Image(systemName: "xmark.app.fill")
                        .foregroundStyle(.white, .gray)
                }
            }
            .font(.title)
            .padding([.horizontal, .bottom], 16)

            Divider()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 32) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(.green.opacity(0.3))
                            .frame(width: 80, height: 80)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Custom Effects")
                                .font(.title3)
                            Text("Apply blur, scale, and any other effects to your background content during transitions!")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .contentMargins(.vertical, 32)
        }
    }
}

#Preview {
    MiniLiftOffDemo()
}
