import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/device_type.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../../../../core/router/app_router.dart';
import '../providers/auth_provider.dart';
import '../views/login_views.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/password_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _errorMessage = null);

    final success = await ref.read(authControllerProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful! Redirecting...'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        context.go(AppRoutes.products);
      } else {
        final authState = ref.read(authControllerProvider);
        setState(() {
          _errorMessage = authState.error?.toString() ?? 'Login failed.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage ?? 'Login failed.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final deviceType = context.deviceType;

    final emailField = AuthFormField(
      controller: _emailController,
      label: 'Email Address',
      hintText: 'owner@example.com',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email is required';
        }
        if (!value.contains('@')) {
          return 'Enter a valid email';
        }
        return null;
      },
    );

    final passwordField = PasswordField(
      controller: _passwordController,
      label: 'Password',
      hintText: 'Enter your password',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        return null;
      },
    );

    if (deviceType == DeviceType.mobile) {
      return LoginMobileView(
        formKey: _formKey,
        emailController: _emailController,
        passwordController: _passwordController,
        onSubmit: _submit,
        onGoToRegister: () => context.go('/register'),
        onForgotPassword: () => context.push('/forgot-password'),
        isLoading: isLoading,
        errorMessage: _errorMessage,
        emailField: emailField,
        passwordField: passwordField,
      );
    }

    return LoginTabletDesktopView(
      formKey: _formKey,
      emailController: _emailController,
      passwordController: _passwordController,
      onSubmit: _submit,
      onGoToRegister: () => context.go('/register'),
      onForgotPassword: () => context.push('/forgot-password'),
      isLoading: isLoading,
      errorMessage: _errorMessage,
      emailField: emailField,
      passwordField: passwordField,
    );
  }
}
