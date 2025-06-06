# MiniLiftOff

A focused SwiftUI component that provides a smooth, customizable slide-up sheet transition with built-in progress tracking.

## Overview

MiniLiftOff creates a fullscreen cover that slides up from the bottom, similar to iOS sheets but with full control over the transition progress for custom effects. It handles the complex geometry calculations and provides a simple, declarative API.

## API Design

### Basic Usage

```swift
MainContentView()
    .miniLiftOff(
        isPresented: $showSheet,
        progress: $transitionProgress
    ) {
        SheetContentView()
    }
```

### Advanced Configuration

```swift
MainContentView()
    .scaleEffect(1.0 - transitionProgress * 0.1)
    .blur(radius: transitionProgress * 10)
    .miniLiftOff(
        isPresented: $showSheet,
        progress: $transitionProgress,
        animation: .spring(response: 0.6, dampingFraction: 0.8),
        onDismiss: dismissAction
    ) {
        SheetContentView()
    }
```

## Parameters

### View Modifier: `.miniLiftOff`
- `isPresented: Binding<Bool>` - Controls sheet presentation state
- `progress: Binding<Double>` - Exposes transition progress (0.0 to 1.0)
- `animation: Animation` - Animation curve (default: `.easeInOut`)
- `onDismiss: (() -> Void)?` - Optional dismissal callback
- `content: @ViewBuilder` - Sheet content that slides in from bottom

## Implementation Requirements

### Core Functionality
1. **Smooth Transitions**: Handle view offsetting based on screen geometry
2. **Progress Binding**: Expose 0-1 transition progress for custom effects
3. **State Management**: Sync `isPresented` with internal animation state
4. **Geometry Handling**: Calculate proper offsets including safe areas

### Animation System
1. **Configurable Curves**: Accept any SwiftUI Animation type
2. **Automatic Sync**: Update progress binding during animations
3. **State Consistency**: Ensure isPresented and progress stay in sync

### Developer Experience
1. **Native Modifier Pattern**: Follows SwiftUI conventions like `.sheet()` and `.fullScreenCover()`
2. **ViewBuilder Support**: Allow any SwiftUI views in content slot
3. **Progress Binding**: Enable custom effects via exposed progress value
4. **Clean API**: Minimal required parameters with sensible defaults
5. **Simple Configuration**: Direct parameter approach without environment pollution

## Future Enhancements
- Gesture dismissal support
- Background dimming options
- Accessibility improvements
- Interactive dismissal threshold

## Technical Notes

### Geometry Calculation
- Uses GeometryReader + PreferenceKey to measure full screen height
- Accounts for safe area insets in offset calculations
- Handles dynamic screen orientations

### State Management
- Internal state drives animation progress
- External bindings updated via onChange/onPreferenceChange
- Prevents infinite update loops

### Performance
- Minimal view rebuilds during transitions
- Efficient offset calculations
- Reusable preference key system