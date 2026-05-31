import 'dart:async';

import 'package:flutter/material.dart';
import 'package:morphix/morphix.dart';

/// Morphix Example App
/// Demonstrates all button styles, animations, and usage patterns.
/// Key patterns:
/// - onTap returns normally → auto success
/// - onTap throws → auto error + shake
/// - controller mode → drive progress manually

void main() => runApp(const MorphixExampleApp());

class MorphixExampleApp extends StatelessWidget {
  const MorphixExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Morphix',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFFFAFAF9),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF18181B),
          surface: Color(0xFFFAFAF9),
        ),
      ),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  /// Controller for manual progress driving (upload/download flows).
  /// Always dispose in State.dispose().
  final _progressController = MorphixController();
  Timer? _progressTimer;

  @override
  void dispose() {
    /// Always clean up: controller holds AnimationControllers internally
    _progressController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  /// Success case: Just return. Morphix handles the state transition.
  Future<void> _success() async => Future.delayed(const Duration(seconds: 2));

  /// Error case: Throw an exception. Morphix catches it automatically,
  /// transitions to error state, plays shake animation, and calls onError.
  Future<void> _error() async {
    await Future.delayed(const Duration(seconds: 2));
    throw Exception('Something went wrong');
  }

  /// Progress mode: Drive 0.0 → 1.0 via controller.setProgress().
  /// Useful for file uploads, downloads, AI generation, etc.
  /// In production: replace Timer with your actual upload stream.
  Future<void> _driveProgress() async {
    double p = 0.0;
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 80), (t) {
      p += 0.02;
      if (p >= 1.0) {
        t.cancel();
        _progressController.success();
      } else {
        _progressController.setProgress(p);
      }
    });
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF18181B),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 36),
              _header(),
              const SizedBox(height: 52),

              /// FILLED STYLE
              /// Solid color, best for primary CTAs (sign in, checkout, etc.).
              /// Press down: scales to 96%, springs back on release.
              /// Success: checkmark draws in two segments, 12 particles burst.
              /// Error: shake animation + auto-reset to idle.
              _section('FILLED'),
              const SizedBox(height: 12),
              Morphix(
                label: 'Pay \$49.00',
                onTap: _success,
                style: MorphixStyle.filled,
                color: const Color(0xFF2563EB),
                successColor: const Color(0xFF0D9488),
              ),
              const SizedBox(height: 10),
              Morphix(
                label: 'Delete Account',
                onTap: _error,
                style: MorphixStyle.filled,
                color: const Color(0xFFDC2626),
                successColor: const Color(0xFF16A34A),
                errorColor: const Color(0xFFD97706),
                onError: (e) => _toast('$e'),
              ),
              const SizedBox(height: 44),

              /// OUTLINED STYLE
              /// Border only, ideal for secondary actions (cancel, skip, etc.).
              /// Same lifecycle as Filled but without background fill.
              _section('OUTLINED'),
              const SizedBox(height: 12),
              Morphix(
                label: 'Save Draft',
                onTap: _success,
                style: MorphixStyle.outlined,
                color: const Color(0xFF2563EB),
                successColor: const Color(0xFF16A34A),
              ),
              const SizedBox(height: 44),

              /// NEON STYLE
              /// Glowing border with subtle breathing pulse on idle.
              /// Eye-catching for hero CTAs (start free trial, hero sections).
              /// Shadow bloom animates during loading.
              _section('NEON'),
              const SizedBox(height: 12),
              Morphix(
                label: 'Start Free Trial',
                onTap: _success,
                style: MorphixStyle.neon,
                color: const Color(0xFF2563EB),
                successColor: const Color(0xFF16A34A),
              ),
              const SizedBox(height: 10),
              Morphix(
                label: 'End Session',
                onTap: _error,
                style: MorphixStyle.neon,
                color: const Color(0xFFDC2626),
                errorColor: const Color(0xFFD97706),
                onError: (e) => _toast('$e'),
              ),
              const SizedBox(height: 44),

              /// GRADIENT STYLE
              /// Two-color gradient that rotates during loading.
              /// Creates premium, animated appearance.
              /// Tip: Keep both colors in the same temperature family (blues + teals).
              _section('GRADIENT'),
              const SizedBox(height: 12),
              Morphix(
                label: 'Upgrade to Pro',
                onTap: _success,
                style: MorphixStyle.gradient,
                color: const Color(0xFF2563EB),
                gradientColors: const [Color(0xFF2563EB), Color(0xFF0D9488)],
                successColor: const Color(0xFF15803D),
              ),
              const SizedBox(height: 44),

              /// ICON VARIANT
              /// Pass any IconData from Material Icons.
              /// Icon hides automatically during loading/success states.
              /// iconPosition: left (default) or right.
              _section('WITH ICON'),
              const SizedBox(height: 12),
              Morphix(
                label: 'Send Message',
                icon: Icons.send_rounded,
                iconPosition: IconPosition.right,
                onTap: _success,
                style: MorphixStyle.filled,
                color: const Color(0xFF18181B),
                successColor: const Color(0xFF16A34A),
              ),
              const SizedBox(height: 44),

              /// CUSTOM CHILD
              /// Override label and icon entirely with any widget.
              /// Use for social sign-in, custom branding, complex layouts.
              /// All animations (scale, collapse, particles) still apply.
              _section('CUSTOM CHILD'),
              const SizedBox(height: 12),
              Morphix(
                onTap: _success,
                style: MorphixStyle.filled,
                color: const Color(0xFF18181B),
                successColor: const Color(0xFF16A34A),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.apple, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Sign in with Apple',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 44),

              /// PROGRESS MODE
              /// Manual progress control via MorphixController.
              /// Use for uploads, downloads, AI ops, anything with progress.
              /// Pattern: ctrl.setProgress(0.0–1.0) → ctrl.success()/error().
              _section('PROGRESS MODE'),
              const SizedBox(height: 12),
              Morphix(
                label: 'Upload Video',
                onTap: _driveProgress,
                controller: _progressController,
                style: MorphixStyle.gradient,
                color: const Color(0xFF2563EB),
                gradientColors: const [Color(0xFF2563EB), Color(0xFF0D9488)],
                successColor: const Color(0xFF16A34A),
              ),
              const SizedBox(height: 44),

              /// SPRING PRESETS
              /// Control the "feel" of the collapse animation.
              /// - snappy: fast, tight (productivity apps)
              /// - bouncy: playful overshoot (consumer apps)
              /// - cinematic: slow, weighted (premium apps)
              /// widthSpring drives collapse, radiusSpring chases it.
              _section('SPRING PRESETS'),
              const SizedBox(height: 12),
              Morphix(
                label: 'Snappy',
                onTap: _success,
                style: MorphixStyle.filled,
                color: const Color(0xFF18181B),
                successColor: const Color(0xFF16A34A),
                widthSpring: MorphixSprings.snappy,
                radiusSpring: MorphixSprings.snappy,
              ),
              const SizedBox(height: 10),
              Morphix(
                label: 'Bouncy',
                onTap: _success,
                style: MorphixStyle.neon,
                color: const Color(0xFF2563EB),
                successColor: const Color(0xFF16A34A),
                widthSpring: MorphixSprings.bouncy,
                radiusSpring: MorphixSprings.follow,
              ),
              const SizedBox(height: 10),
              Morphix(
                label: 'Cinematic',
                onTap: _success,
                style: MorphixStyle.gradient,
                color: const Color(0xFF16A34A),
                gradientColors: const [Color(0xFF16A34A), Color(0xFF0D9488)],
                successColor: const Color(0xFF15803D),
                widthSpring: MorphixSprings.cinematic,
                radiusSpring: MorphixSprings.cinematic,
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'morphix',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: Color(0xFF18181B),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Animated async button for Flutter',
          style: TextStyle(fontSize: 13, color: Color(0xFF71717A)),
        ),
      ],
    );
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 2),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: Color(0xFFA1A1AA),
        letterSpacing: 1.4,
      ),
    ),
  );
}
