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
      appBar: AppBar(title: const Text('Register Shop')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Start your SaaS POS',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Register your shop to manage inventory, orders & staff',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 24),
                if (errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                shopNameField,
                const SizedBox(height: 16),
                phoneField,
                const SizedBox(height: 16),
                emailField,
                const SizedBox(height: 16),
                passwordField,
                const SizedBox(height: 16),
                confirmPasswordField,
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading ? null : onSubmit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Register Shop'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have a shop?'),
                    TextButton(
                      onPressed: onGoToLogin,
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ],
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Register Shop',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Register your shop to manage inventory, orders & staff',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 24),
                  if (errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  shopNameField,
                  const SizedBox(height: 16),
                  phoneField,
                  const SizedBox(height: 16),
                  emailField,
                  const SizedBox(height: 16),
                  passwordField,
                  const SizedBox(height: 16),
                  confirmPasswordField,
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: isLoading ? null : onSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Register Shop'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have a shop?'),
                      TextButton(
                        onPressed: onGoToLogin,
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
