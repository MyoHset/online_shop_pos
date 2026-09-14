import 'package:flutter/material.dart';

class RegisterMobileView extends StatelessWidget {
  const RegisterMobileView({
    super.key,
    required this.formKey,
    required this.shopNameField,
    required this.phoneField,
    required this.emailField,
    required this.passwordField,
    required this.confirmPasswordField,
    required this.onSubmit,
    required this.onGoToLogin,
    required this.isLoading,
    this.errorMessage,
  });

  final GlobalKey<FormState> formKey;
  final Widget shopNameField;
  final Widget phoneField;
  final Widget emailField;
  final Widget passwordField;
  final Widget confirmPasswordField;
  final VoidCallback onSubmit;
  final VoidCallback onGoToLogin;
  final bool isLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: const Color(0xFF09090B),
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(color: const Color(0xFF27272A)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x80000000),
                    blurRadius: 40,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF18181B),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.storefront, size: 18, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'POS.OS',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Create an account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Enter your details to register your shop instance',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFA1A1AA),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFCA5A5)),
                        ),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    shopNameField,
                    const SizedBox(height: 14),
                    phoneField,
                    const SizedBox(height: 14),
                    emailField,
                    const SizedBox(height: 14),
                    passwordField,
                    const SizedBox(height: 14),
                    confirmPasswordField,
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading ? null : onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF09090B),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF09090B),
                              ),
                            )
                          : const Text('Create shop account', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(fontSize: 13, color: Color(0xFFA1A1AA)),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: onGoToLogin,
                          child: const Text(
                            'Sign in',
                            style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}

class RegisterTabletDesktopView extends StatelessWidget {
  const RegisterTabletDesktopView({
    super.key,
    required this.formKey,
    required this.shopNameField,
    required this.phoneField,
    required this.emailField,
    required this.passwordField,
    required this.confirmPasswordField,
    required this.onSubmit,
    required this.onGoToLogin,
    required this.isLoading,
    this.errorMessage,
  });

  final GlobalKey<FormState> formKey;
  final Widget shopNameField;
  final Widget phoneField;
  final Widget emailField;
  final Widget passwordField;
  final Widget confirmPasswordField;
  final VoidCallback onSubmit;
  final VoidCallback onGoToLogin;
  final bool isLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1020, maxHeight: 690),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(color: const Color(0xFFE4E4E7)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 32,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              children: [
                // Left Column - Form
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 52.0, vertical: 36.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF09090B),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.storefront, size: 20, color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'POS.OS',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF09090B),
                                  letterSpacing: -0.6,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Create an account',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF09090B),
                              letterSpacing: -0.8,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Register your shop to manage products, stock & staff.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF71717A),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFFCA5A5)),
                              ),
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          shopNameField,
                          const SizedBox(height: 12),
                          phoneField,
                          const SizedBox(height: 12),
                          emailField,
                          const SizedBox(height: 12),
                          passwordField,
                          const SizedBox(height: 12),
                          confirmPasswordField,
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: isLoading ? null : onSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF09090B),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Create shop account', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account?',
                                style: TextStyle(fontSize: 13, color: Color(0xFF71717A)),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: onGoToLogin,
                                child: const Text(
                                  'Sign in',
                                  style: TextStyle(fontSize: 13, color: Color(0xFF09090B), fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Right Column - Solid Card Showcase
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: const Color(0xFF09090B),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF27272A)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF18181B).withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFF27272A)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF22C55E),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Multi-tenant Cloud Ready',
                                        style: TextStyle(color: Color(0xFFA1A1AA), fontSize: 11, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                const Text(
                                  'Instant Setup',
                                  style: TextStyle(color: Color(0xFF71717A), fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Empower Your\nShop Operations.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    height: 1.15,
                                    letterSpacing: -1.2,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Isolated shop databases, automatic role management, and instant stock reservation for fast-paced retail.',
                                  style: TextStyle(
                                    color: Color(0xFFA1A1AA),
                                    fontSize: 14,
                                    height: 1.6,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF18181B).withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: const Color(0xFF27272A)),
                                  ),
                                  child: Column(
                                    children: [
                                      _buildFeatureRow(Icons.check_circle_outline, 'Automatic Owner & Shop Provisioning'),
                                      const SizedBox(height: 10),
                                      _buildFeatureRow(Icons.shield_outlined, 'Edge Function Secure Staff Invites'),
                                      const SizedBox(height: 10),
                                      _buildFeatureRow(Icons.swap_horiz, 'Multi-platform Responsive POS Chrome'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              '© 2026 POS.OS Inc. All rights reserved.',
                              style: TextStyle(color: Color(0xFF52525B), fontSize: 12),
                            ),
                          ],
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF22C55E)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Color(0xFFE4E4E7), fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
