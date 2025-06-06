# MiniLiftOff

A focused SwiftUI component that provides smooth, customizable slide-up sheet transitions with built-in progress tracking.

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Swift 5.5+](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-iOS%2013+-green.svg)](https://developer.apple.com/xcode/swiftui/)

<div align="center">
    <img src="asests/miniliftoff.gif" alt="Demo" width="720" />
</div>

## The Story Behind This

So I've been using [Waterllama](https://apps.apple.com/us/app/waterllama/id1454778585) to track my daily water intake (highly recommend it, by the way), and they have this absolutely gorgeous sheet transition that caught my eye. You know how most apps just use the standard iOS sheet that slides up? Well, Waterllama does it way more cleanly, it smoothly shifts the entire main content up. It's such a small detail, but it makes the whole interaction feel so much more polished and engaging.

I found myself opening the app just to see that transition again (okay, maybe I also needed to log my water 💧). As a developer, you know how it is when you see something nicely crafted - you start thinking "I wonder how they did that" and "I bet I could build something like this."

I spent a few hours reverse-engineering the effect and realized this kind of transition could be useful in other contexts. The main issue with SwiftUI's built-in `.sheet()` and `.fullScreenCover()` is that you can't interact with or modify the view you're presenting from during the transition - it's completely hands-off. But what if you could control that background content and also tap into the transition progress for custom effects?

So MiniLiftOff was born. It gives you full control over the background view during the slide-up transition, plus exposes the animation progress as a binding for whatever effects you want to create.

## What It Does

MiniLiftOff creates a fullscreen cover that slides up from the bottom, similar to iOS sheets but gives you full control over the background view during the transition. You can apply any effects you want to the content behind the sheet - scaling, blurring, rotation, or any transformation based on the real-time progress of the animation.

Perfect for:

-   Recreating those polished app transitions you admire
-   Custom sheet presentations with background effects
-   Onboarding flows with smooth transitions
-   Interactive modals with progress-based animations
-   Any UI where you want that extra bit of visual flair

## What Makes It Special

-   🎯 **Dead Simple API** - Just add `.miniLiftOff()` like you would `.sheet()`
-   ⚡ **Buttery Smooth** - Built-in geometry calculations with safe area handling
-   📊 **Progress Tracking** - Real-time transition progress (0.0 to 1.0) for your custom effects
-   🎨 **Your Creativity** - Use any SwiftUI Animation curve and combine any effects
-   🔄 **Just Works** - Automatic state sync, no weird binding issues
-   📱 **Feels Native** - Follows SwiftUI conventions you already know and love

## Getting Started

Just drag `MiniLiftOff.swift` into your Xcode project and you're ready to go. No SPM, no CocoaPods, no fuss.

## How to Use It

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

### The Fun Part - Custom Effects

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
        // Here's where the magic happens - create any effect you want!
        .scaleEffect(1.0 - transitionProgress * 0.1)  // Gentle scale down
        .blur(radius: transitionProgress * 8)         // Blur effect
        .brightness(-transitionProgress * 0.2)        // Subtle darkening
        .miniLiftOff(
            isPresented: $showSheet,
            progress: $transitionProgress,
            animation: .spring(response: 0.6, dampingFraction: 0.8),
            onDismiss: {
                print("Back to the main view!")
            }
        ) {
            SheetView(isPresented: $showSheet)
        }
    }
}
```

## The Technical Stuff

### The View Modifier

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

| Parameter     | Type              | Description                              |
| ------------- | ----------------- | ---------------------------------------- |
| `isPresented` | `Binding<Bool>`   | Controls sheet presentation state        |
| `progress`    | `Binding<Double>` | Exposes transition progress (0.0 to 1.0) |
| `animation`   | `Animation`       | Animation curve (default: `.easeInOut`)  |
| `onDismiss`   | `(() -> Void)?`   | Optional dismissal callback              |
| `content`     | `@ViewBuilder`    | Sheet content that slides in from bottom |

### The Progress Value

This is the secret sauce! The `progress` binding gives you real-time transition state:

-   `0.0` - Sheet fully hidden (your main content is chillin')
-   `0.5` - Sheet halfway through transition (things are getting interesting)
-   `1.0` - Sheet fully presented (main content is completely hidden behind the sheet)

Use this value to drive whatever custom effects you can dream up on your main content.

## Effect Ideas to Get You Started

### That Waterllama-Style Scale Down

```swift
.scaleEffect(1.0 - transitionProgress * 0.15)
```

### iOS-Style Blur

```swift
.blur(radius: transitionProgress * 10)
```

### Gentle Fade Out

```swift
.opacity(1.0 - transitionProgress * 0.7)
```

### The Full Waterllama Experience

```swift
.scaleEffect(1.0 - transitionProgress * 0.1)
.blur(radius: transitionProgress * 8)
.brightness(-transitionProgress * 0.3)
```

Go wild! Try rotation, translation, color shifts, or whatever comes to mind.

## The Nerdy Details

-   **Geometry Handling**: Automatically figures out screen height including safe areas (no math required on your end)
-   **Performance**: Minimal view rebuilds during transitions with efficient offset calculations
-   **State Management**: Prevents those annoying infinite update loops while keeping bindings in sync
-   **Compatibility**: Works with iOS 13+ and plays nice with any SwiftUI views

## Requirements

-   iOS 13.0+
-   Swift 5.5+

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Hey There

Built this with ☕ and curiosity by [Petros Bantolas](mailto:petros@bantolas.dev). If you create something cool with it, I'd love to see it!
