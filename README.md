<div align="center">

# morphix

### A premium animated async button for Flutter
**One widget. One job. The full button lifecycle — beautifully.**

![morphix demo](https://raw.githubusercontent.com/originehsan/morphix/main/assets/morphix-ezgif.com-video-to-gif-converter.gif)

[![pub.dev](https://img.shields.io/pub/v/morphix.svg)](https://pub.dev/packages/morphix)
[![pub points](https://img.shields.io/pub/points/morphix)](https://pub.dev/packages/morphix/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A53.10-02569B?logo=flutter)](https://flutter.dev)

</div>

---

## Table of Contents

- [The Problem](#-the-problem)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Styles](#-styles)
- [Animations](#-animations)
- [Features](#-features)
- [API Reference](#-api-reference)
- [Accessibility](#-accessibility)
- [Production Safety](#-production-safety)
- [Architecture](#-architecture)
- [Roadmap](#-roadmap)

---

## The Problem

Every async button in every Flutter app has the same bug waiting to happen:

```dart
bool isLoading = false;
bool isSuccess = false;
bool isError = false;
// manage all three manually
// forget to reset one
// ship a bug
```

**morphix eliminates this pattern entirely.**

```dart
Morphix(
  label: 'Pay $49.00',
  onTap: () async => await pay(),
)
```

That's it. **morphix owns the entire lifecycle.**

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  morphix: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## Quick Start

```dart
import 'package:morphix/morphix.dart';

Morphix(
  label: 'Pay $49.00',
  onTap: () async => await pay(),
  style: MorphixStyle.filled,
  color: Color(0xFF2563EB),
  successColor: Color(0xFF16A34A),
  onSuccess: () => Navigator.pushNamed(context, '/receipt'),
  onError: (e) => showSnackBar('$e'),
)
```

---

## Styles

Choose the perfect style for your use case:

### Filled
Solid color, universal call-to-action button.

```dart
Morphix(
  label: 'Continue',
  onTap: onTap,
  style: MorphixStyle.filled,
  color: Color(0xFF18181B),
  successColor: Color(0xFF16A34A),
)
```

### Outlined
Border only, ideal for secondary actions.

```dart
Morphix(
  label: 'Save Draft',
  onTap: onTap,
  style: MorphixStyle.outlined,
  color: Color(0xFF2563EB),
  successColor: Color(0xFF16A34A),
)
```

### Neon
Glowing border with breathing pulse animation on idle state.

```dart
Morphix(
  label: 'Start Free Trial',
  onTap: onTap,
  style: MorphixStyle.neon,
  color: Color(0xFF2563EB),
  successColor: Color(0xFF16A34A),
)
```

### Gradient
Two-color gradient that rotates dynamically during loading.

```dart
Morphix(
  label: 'Upgrade to Pro',
  onTap: onTap,
  style: MorphixStyle.gradient,
  color: Color(0xFF2563EB),
  gradientColors: [
    Color(0xFF2563EB),
    Color(0xFF0D9488),
  ],
  successColor: Color(0xFF16A34A),
)
```

---

## Animations

Seven world-class animations crafted with physics-based spring simulations:

| Animation | Description |
|---|---|
| **Liquid collapse** | Width spring leads, radius spring follows. Center-bulge before snapping to circle. Real `SpringSimulation` — not easing curves. |
| **Rotating gradient arc** | Gradient spins inside the circle during loading. *(Gradient style only)* |
| **Stroke checkmark** | Draws in two segments via `CustomPainter`. Not an icon. Not a fade-in. **It draws.** |
| **Particle burst** | 12 brand-color dots explode when checkmark finishes. Fade to zero as they fly. |
| **iOS shake** | Three decaying oscillations on error. Auto-resets to idle. |
| **Press scale** | 96% on finger down, springs back on release. 80ms response. |
| **Shadow bloom** | Glow pulse on neon idle and during loading. |

---

## Features

### Progress Mode

Perfect for uploads, downloads, and AI generation flows:

```dart
final ctrl = MorphixController();

void upload() {
  double progress = 0.0;
  Timer.periodic(Duration(milliseconds: 80), (t) {
    progress += 0.02;
    if (progress >= 1.0) {
      t.cancel();
      ctrl.success();
    } else {
      ctrl.setProgress(progress);
    }
  });
}

Morphix(
  label: 'Upload Video',
  onTap: null,
  controller: ctrl,
  style: MorphixStyle.gradient,
  color: Color(0xFF2563EB),
  gradientColors: [Color(0xFF2563EB), Color(0xFF0D9488)],
  successColor: Color(0xFF16A34A),
)
```

### External Controller

Seamlessly integrate with **Riverpod**, **Bloc**, **GetX**, **MVVM**, or any state manager:

```dart
final ctrl = MorphixController();

// Riverpod
ref.listen(paymentProvider, (_, next) {
  if (next.isLoading) ctrl.loading();
  if (next.hasValue)  ctrl.success();
  if (next.hasError)  ctrl.error();
});

// Bloc
BlocListener<PaymentBloc, PaymentState>(
  listener: (context, state) {
    if (state is PaymentLoading) ctrl.loading();
    if (state is PaymentSuccess) ctrl.success();
    if (state is PaymentFailure) ctrl.error();
  },
  child: Morphix(
    label: 'Pay',
    onTap: null,
    controller: ctrl,
    color: Color(0xFF2563EB),
  ),
)

// Always dispose
@override
void dispose() {
  ctrl.dispose();
  super.dispose();
}
```

---

## API Reference

### Controller API

```dart
ctrl.loading()          // → loading state
ctrl.success()          // → success state
ctrl.error()            // → error state
ctrl.reset()            // → idle state
ctrl.disable()          // → disabled state
ctrl.enable()           // → idle state
ctrl.setProgress(0.65)  // → determinate progress arc

ctrl.state              // current MorphixState
ctrl.isDisposed         // safety check
ctrl.dispose()          // always call in dispose()
```

### Full Widget API

```dart
Morphix(
  // Content
  label: 'Pay $49.00',
  child: Widget,
  icon: Icons.payment_rounded,
  iconPosition: IconPosition.left,

  // Async
  onTap: () async => await pay(),
  controller: ctrl,

  // Style
  style: MorphixStyle.gradient,
  color: Color(0xFF2563EB),
  gradientColors: [Color(0xFF2563EB), Color(0xFF0D9488)],
  gradientAngle: 135.0,

  // State colors
  successColor: Color(0xFF16A34A),
  errorColor: Color(0xFFDC2626),

  // Sizing
  height: 54.0,
  minWidth: 120.0,
  maxWidth: double.infinity,
  borderRadius: 32.0,
  borderWidth: 2.0,

  // Text
  textStyle: TextStyle(...),

  // Timing
  successDuration: Duration(seconds: 2),

  // Spring presets
  widthSpring: MorphixSprings.snappy,
  radiusSpring: MorphixSprings.follow,

  // Feel
  haptic: true,
  particles: true,

  // Accessibility
  focusNode: FocusNode(),
  loadingLabel: 'Loading',
  successLabel: 'Success',
  errorLabel: 'Error',

  // Speed
  animationSpeed: 1.0,

  // Callbacks
  onSuccess: () {},
  onError: (e) {},
)
```

### Spring Presets

Five physics-based spring presets for perfect feel:

| Preset | Character | Best For |
|---|---|---|
| **standard** | Balanced — good default | General purpose |
| **snappy** | Fast and tight | Productivity apps |
| **cinematic** | Slow and weighted | Luxury apps |
| **bouncy** | Playful overshoot | Consumer apps |
| **follow** | Soft chase | Radius spring animations |

```dart
// Snappy feel — productivity
Morphix(
  label: 'Continue',
  onTap: onTap,
  color: Color(0xFF18181B),
  widthSpring: MorphixSprings.snappy,
  radiusSpring: MorphixSprings.snappy,
)

// Cinematic feel — premium
Morphix(
  label: 'Upgrade to Pro',
  onTap: onTap,
  style: MorphixStyle.gradient,
  color: Color(0xFF2563EB),
  gradientColors: [Color(0xFF2563EB), Color(0xFF0D9488)],
  widthSpring: MorphixSprings.cinematic,
  radiusSpring: MorphixSprings.cinematic,
)
```

---

## Accessibility

**morphix is fully accessible out of the box.**

- Keyboard navigation — `Tab` to focus, `Enter` or `Space` to activate
- Screen reader announcements on every state change
- Semantics labels updated per state — idle, loading, success, error, disabled
- Reduced motion — respects `MediaQuery.disableAnimations`
- Localization ready — custom labels for any language

```dart
Morphix(
  label: 'Pay $49.00',
  onTap: onTap,
  color: Color(0xFF2563EB),
  loadingLabel: 'Processing payment',
  successLabel: 'Payment successful',
  errorLabel: 'Payment failed',
)
```

---

## Architecture

Clean, modular architecture with **zero external dependencies** — just Flutter SDK.

```text
lib/
├── morphix.dart                       ← public API, 5 export lines
└── src/
    ├── core/
    │   ├── morphix_state.dart         ← state enum
    │   ├── morphix_constants.dart     ← all magic numbers
    │   └── morphix_controller.dart    ← external driver
    ├── model/
    │   ├── morphix_style.dart         ← style enum
    │   ├── morphix_icon_position.dart ← icon position enum
    │   └── particle.dart              ← particle data model
    ├── theme/
    │   └── morphix_theme.dart         ← pure static color resolution
    ├── animation/
    │   ├── morphix_animations.dart    ← owns all AnimationControllers
    │   └── morphix_spring.dart        ← spring presets
    ├── painter/
    │   ├── checkmark_painter.dart
    │   ├── spinner_painter.dart
    │   ├── gradient_painter.dart
    │   └── particle_painter.dart
    └── widgets/
        ├── morphix_button.dart        ← state machine + lifecycle
        ├── morphix_button_tap.dart    ← tap + press + haptic
        ├── morphix_button_content.dart
        ├── morphix_button_decoration.dart
        └── morphix_widget.dart        ← public Morphix widget
```

---

## Production Safety

**12 critical vulnerabilities fixed** before v1.0.0 release:

| # | Vulnerability | Solution |
|---|---|---|
| 1 | Rapid multi-tap launches parallel ops | `_isBusy` guard set before first `await` |
| 2 | `setState` after dispose | `_isDisposed` flag + `mounted` check |
| 3 | `onTap` throws synchronously | `Future.microtask()` wraps `onTap` |
| 4 | `AnimationController` after dispose | `MorphixAnimations` disposes all atomically |
| 5 | `onTap: null` without controller | Silent no-op — no crash |
| 6 | Controller used after dispose | `_set()` guards `_disposed` flag |
| 7 | `successDuration` zero or negative | Clamped to 500ms minimum |
| 8 | Controller swapped on rebuild | `didUpdateWidget` re-wires listener |
| 9 | Screen rotation stale width | `LayoutBuilder` captures every build |
| 10 | Success timer fires post-dispose | `_successTimer?.cancel()` in dispose |
| 11 | RTL languages | `Transform.translate` is directionality-agnostic |
| 12 | Long label overflow | `maxLines: 1` + `TextOverflow.ellipsis` |

---

## State Machine

```text
idle ──tap──────────────→ loading
loading ──success──────→ success ──timer──→ idle
loading ──throw────────→ error ──shake──→ idle
loading ──setProgress──→ progress ──success──→ idle
any ──controller──────→ any state
disabled ──tap─────────→ nothing
```

---

## Roadmap

| Version | Features |
|---|---|
| **v1.0** | Core async lifecycle, 4 styles, spring physics, particles, neon, gradient, progress mode, accessibility |
| **v1.1** | `MorphixTheme` InheritedWidget, `MorphixStyle.glass`, `ctrl.setProgress()` improvements |
| **v1.2** | Custom particle shapes, custom haptic patterns, `ctrl.successWithMessage()` |
| **v2.0** | `interactix` kit — `MorphixLoader`, `MorphixCard`, `MorphixInput` |

---

## Contributing

We welcome PRs and issues! Please [open an issue](../../issues) before submitting large changes.

---

## License

MIT © 2025 — see [LICENSE](LICENSE)

---

## Why "morphix"?

A button that **morph**s through its lifecycle. Simple. Memorable. Available on pub.dev.

---

<div align="center">

**Made with care for Flutter developers**

[Report Bug](../../issues) • [Request Feature](../../issues) • [View Docs](https://pub.dev/packages/morphix)

</div>
