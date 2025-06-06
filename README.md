# MiniLiftOff

A focused SwiftUI component that provides smooth, customizable slide-up sheet transitions with built-in progress tracking.

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Swift 5.5+](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-iOS%2013+-green.svg)](https://developer.apple.com/xcode/swiftui/)

## Overview

MiniLiftOff creates a fullscreen cover that slides up from the bottom, similar to iOS sheets but with full control over the transition progress. This enables custom effects like background scaling, blurring, or any transformation based on the sheet's animation progress.

Perfect for:
- Custom sheet presentations with background effects
- Onboarding flows with smooth transitions
- Interactive modals with progress-based animations
- Any UI requiring precise control over slide-up animations

## Features

- 🎯 **Focused API** - Simple, declarative SwiftUI modifier pattern
- ⚡ **Smooth Transitions** - Built-in geometry calculations with safe area handling
- 📊 **Progress Tracking** - Real-time transition progress (0.0 to 1.0) for custom effects
- 🎨 **Customizable Animations** - Use any SwiftUI Animation curve
- 🔄 **State Management** - Automatic sync between presentation state and progress
- 📱 **Native Feel** - Follows SwiftUI conventions like `.sheet()` and `.fullScreenCover()`

## Installation

Simply add `MiniLiftOff.swift` to your Xcode project.

## Usage

### Basic Implementation

```swift
import SwiftUI

struct ContentView: View {
    @State private var showSheet = false
    @State private var transitionProgress: Double = 0.0
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Main Content")
                    .font(.largeTitle)
                
                Button("Show Sheet") {
                    showSheet = true
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("MiniLiftOff Demo")
        }
        .miniLiftOff(
            isPresented: $showSheet,
            progress: $transitionProgress
        ) {
            SheetView(isPresented: $showSheet)
        }
    }
}

struct SheetView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Sheet Content")
                    .font(.title)
                
                Button("Dismiss") {
                    isPresented = false
                }
                .buttonStyle(.bordered)
            }
            .navigationTitle("Sheet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}
```

### Advanced Usage with Custom Effects

```swift
struct ContentView: View {
    @State private var showSheet = false
    @State private var transitionProgress: Double = 0.0
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Main Content")
                    .font(.largeTitle)
                
                Button("Show Sheet") {
                    showSheet = true
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Advanced Demo")
        }
        // Apply custom effects based on transition progress
        .scaleEffect(1.0 - transitionProgress * 0.1)
        .blur(radius: transitionProgress * 8)
        .brightness(-transitionProgress * 0.2)
        .miniLiftOff(
            isPresented: $showSheet,
            progress: $transitionProgress,
            animation: .spring(response: 0.6, dampingFraction: 0.8),
            onDismiss: {
                print("Sheet dismissed")
            }
        ) {
            SheetView(isPresented: $showSheet)
        }
    }
}
```

## API Reference

### View Modifier

```swift
func miniLiftOff<Content: View>(
    isPresented: Binding<Bool>,
    progress: Binding<Double>,
    animation: Animation = .easeInOut,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping () -> Content
) -> some View
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `isPresented` | `Binding<Bool>` | Controls sheet presentation state |
| `progress` | `Binding<Double>` | Exposes transition progress (0.0 to 1.0) |
| `animation` | `Animation` | Animation curve (default: `.easeInOut`) |
| `onDismiss` | `(() -> Void)?` | Optional dismissal callback |
| `content` | `@ViewBuilder` | Sheet content that slides in from bottom |

### Progress Value

The `progress` binding provides real-time transition state:
- `0.0` - Sheet fully hidden (main content visible)
- `0.5` - Sheet halfway through transition
- `1.0` - Sheet fully presented (content hidden behind sheet)

Use this value to create custom effects on your main content during the transition.

## Examples

### Background Scaling Effect
```swift
.scaleEffect(1.0 - transitionProgress * 0.15)
```

### Blur Effect
```swift
.blur(radius: transitionProgress * 10)
```

### Opacity Fade
```swift
.opacity(1.0 - transitionProgress * 0.7)
```

### Combined Effects
```swift
.scaleEffect(1.0 - transitionProgress * 0.1)
.blur(radius: transitionProgress * 8)
.brightness(-transitionProgress * 0.3)
```

## Technical Details

- **Geometry Handling**: Automatically calculates screen height including safe areas
- **Performance**: Minimal view rebuilds during transitions with efficient offset calculations
- **State Management**: Prevents infinite update loops while keeping bindings in sync
- **Compatibility**: Works with iOS 13+ and any SwiftUI views

## Requirements

- iOS 13.0+
- Swift 5.5+

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Author

Created by [Petros Bantolas](mailto:petros@bantolas.dev)
