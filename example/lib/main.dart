import 'dart:async';

import 'package:flutter/material.dart';
import 'package:morphix/morphix.dart';

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
  final _uploadController = MorphixController();
  final _progressController = MorphixController();
  Timer? _progressTimer;

  @override
  void dispose() {
    _uploadController.dispose();
    _progressController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  Future<void> _success() async => Future.delayed(const Duration(seconds: 2));

  Future<void> _error() async {
    await Future.delayed(const Duration(seconds: 2));
    throw Exception('Failed');
  }

  void _driveUpload() {
    _uploadController.loading();
    Future.delayed(const Duration(seconds: 2), _uploadController.success);
  }

  void _driveProgress() {
    double p = 0.0;
    _progressController.setProgress(0.0);
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

              // ── Filled ─────────────────────────────────────────────
              // Black = strongest CTA. Used by Apple, Notion, Linear.
              _section('FILLED'),
              const SizedBox(height: 12),

              Morphix(
                label: 'Continue',
                onTap: _success,
                style: MorphixStyle.filled,
                color: const Color(0xFF18181B),
                successColor: const Color(0xFF16A34A),
                errorColor: const Color(0xFFDC2626),
              ),
              const SizedBox(height: 10),

              // Blue = payments. Most trusted payment color globally.
              Morphix(
                label: 'Pay \$49.00',
                onTap: _success,
                style: MorphixStyle.filled,
                color: const Color(0xFF2563EB),
                // Teal on success — feels like money arrived
                successColor: const Color(0xFF0D9488),
                errorColor: const Color(0xFFDC2626),
              ),
              const SizedBox(height: 10),

              // Green = confirm, approve. No ambiguity.
              Morphix(
                label: 'Confirm Order',
                onTap: _success,
                style: MorphixStyle.filled,
                color: const Color(0xFF16A34A),
                // Darker green on success — depth, completion
                successColor: const Color(0xFF15803D),
              ),
              const SizedBox(height: 10),

              // Red = destructive. Always red, never softened.
              Morphix(
                label: 'Delete Account',
                onTap: _error,
                style: MorphixStyle.filled,
                color: const Color(0xFFDC2626),
                successColor: const Color(0xFF16A34A),
                // Amber on error — softer, "try again" energy
                errorColor: const Color(0xFFD97706),
                onError: (e) => _toast('Deletion failed'),
              ),
              const SizedBox(height: 44),

              // ── Outlined ───────────────────────────────────────────
              // Outlined = secondary action. Never competes with filled.
              _section('OUTLINED'),
              const SizedBox(height: 12),

              // Black outlined = polite cancel
              Morphix(
                label: 'Cancel',
                onTap: _success,
                style: MorphixStyle.outlined,
                color: const Color(0xFF52525B),
                successColor: const Color(0xFF16A34A),
              ),
              const SizedBox(height: 10),

              // Blue outlined = save without committing
              Morphix(
                label: 'Save Draft',
                onTap: _success,
                style: MorphixStyle.outlined,
                color: const Color(0xFF2563EB),
                successColor: const Color(0xFF16A34A),
              ),
              const SizedBox(height: 10),

              // Red outlined = warn before destroy
              Morphix(
                label: 'Remove Item',
                onTap: _error,
                style: MorphixStyle.outlined,
                color: const Color(0xFFDC2626),
                successColor: const Color(0xFF16A34A),
                errorColor: const Color(0xFFDC2626),
                onError: (e) => _toast('Remove failed'),
              ),
              const SizedBox(height: 44),

              // ── Neon ───────────────────────────────────────────────
              // Neon = attention-demanding. Use for hero CTAs only.
              _section('NEON'),
              const SizedBox(height: 12),

              // Blue neon = sign up, trial — trust + attention
              Morphix(
                label: 'Start Free Trial',
                onTap: _success,
                style: MorphixStyle.neon,
                color: const Color(0xFF2563EB),
                successColor: const Color(0xFF16A34A),
              ),
              const SizedBox(height: 10),

              // Green neon = go, launch, live — action
              Morphix(
                label: 'Go Live',
                onTap: _success,
                style: MorphixStyle.neon,
                color: const Color(0xFF16A34A),
                successColor: const Color(0xFF0D9488),
              ),
              const SizedBox(height: 10),

              // Red neon = urgent, danger zone
              Morphix(
                label: 'End Session',
                onTap: _error,
                style: MorphixStyle.neon,
                color: const Color(0xFFDC2626),
                errorColor: const Color(0xFFD97706),
                onError: (e) => _toast('Session error'),
              ),
              const SizedBox(height: 44),

              // ── Gradient ───────────────────────────────────────────
              // Gradient = premium tier, upgrade, paid features.
              // Colors must share warmth or coolness — never mix warm+cool.
              _section('GRADIENT'),
              const SizedBox(height: 12),

              // Cool blue → teal — upgrade, SaaS, premium
              Morphix(
                label: 'Upgrade to Pro',
                onTap: _success,
                style: MorphixStyle.gradient,
                color: const Color(0xFF2563EB),
                gradientColors: const [
                  Color(0xFF2563EB), // blue
                  Color(0xFF0D9488), // teal
                ],
                successColor: const Color(0xFF15803D),
              ),
              const SizedBox(height: 10),

              // Warm amber → orange — bookings, reservations, hospitality
              Morphix(
                label: 'Book Now',
                onTap: _success,
                style: MorphixStyle.gradient,
                color: const Color(0xFFD97706),
                gradientColors: const [
                  Color(0xFFD97706), // amber
                  Color(0xFFEA580C), // orange
                ],
                successColor: const Color(0xFF16A34A),
              ),
              const SizedBox(height: 10),

              // Cool green → teal — earn, save, grow
              Morphix(
                label: 'Start Earning',
                onTap: _success,
                style: MorphixStyle.gradient,
                color: const Color(0xFF16A34A),
                gradientColors: const [
                  Color(0xFF16A34A), // green
                  Color(0xFF0D9488), // teal
                ],
                successColor: const Color(0xFF15803D),
              ),
              const SizedBox(height: 10),

              // Warm red → rose — social, creative, passion
              Morphix(
                label: 'Share Story',
                onTap: _error,
                style: MorphixStyle.gradient,
                color: const Color(0xFFDC2626),
                gradientColors: const [
                  Color(0xFFDC2626), // red
                  Color(0xFFE11D48), // rose
                ],
                errorColor: const Color(0xFFD97706),
                onError: (e) => _toast('Share failed'),
              ),
              const SizedBox(height: 44),

              // ── With icon ──────────────────────────────────────────
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
              const SizedBox(height: 10),

              Morphix(
                label: 'Download Report',
                icon: Icons.download_rounded,
                iconPosition: IconPosition.left,
                onTap: _success,
                style: MorphixStyle.outlined,
                color: const Color(0xFF2563EB),
                successColor: const Color(0xFF16A34A),
              ),
              const SizedBox(height: 10),

              Morphix(
                label: 'Add to Cart',
                icon: Icons.shopping_bag_outlined,
                iconPosition: IconPosition.left,
                onTap: _success,
                style: MorphixStyle.filled,
                color: const Color(0xFF16A34A),
                successColor: const Color(0xFF15803D),
              ),
              const SizedBox(height: 44),

              // ── Custom child ───────────────────────────────────────
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
              const SizedBox(height: 10),

              Morphix(
                onTap: _success,
                style: MorphixStyle.outlined,
                color: const Color(0xFF52525B),
                successColor: const Color(0xFF16A34A),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'G',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Continue with Google',
                      style: TextStyle(
                        color: Color(0xFF18181B),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 44),

              // ── Progress mode ──────────────────────────────────────
              _section('PROGRESS MODE'),
              const SizedBox(height: 12),

              Morphix(
                label: 'Upload Video',
                onTap: null,
                controller: _progressController,
                style: MorphixStyle.gradient,
                color: const Color(0xFF2563EB),
                gradientColors: const [Color(0xFF2563EB), Color(0xFF0D9488)],
                successColor: const Color(0xFF16A34A),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: _driveProgress,
                child: const Text('Simulate upload progress'),
              ),
              const SizedBox(height: 44),

              // ── External controller ────────────────────────────────
              _section('EXTERNAL CONTROLLER'),
              const SizedBox(height: 12),

              Morphix(
                label: 'Sync Data',
                onTap: null,
                controller: _uploadController,
                style: MorphixStyle.filled,
                color: const Color(0xFF2563EB),
                successColor: const Color(0xFF16A34A),
                errorColor: const Color(0xFFDC2626),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: _driveUpload,
                child: const Text('Trigger via controller'),
              ),
              const SizedBox(height: 44),

              // ── Spring presets ─────────────────────────────────────
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
              const SizedBox(height: 44),

              // ── No particles ───────────────────────────────────────
              _section('NO PARTICLES'),
              const SizedBox(height: 12),

              Morphix(
                label: 'Lightweight Mode',
                onTap: _success,
                style: MorphixStyle.outlined,
                color: const Color(0xFF52525B),
                successColor: const Color(0xFF16A34A),
                particles: false,
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
}
