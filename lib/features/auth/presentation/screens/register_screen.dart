import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/device_type.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../../../../core/router/app_router.dart';
import '../providers/auth_provider.dart';
import '../views/register_views.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/password_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _shopNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _errorMessage = null);

    final success = await ref.read(authControllerProvider.notifier).registerShop(
          shopName: _shopNameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (mounted) {
      if (success) {
        context.go(AppRoutes.products);
      } else {
        final authState = ref.read(authControllerProvider);
        setState(() {
          _errorMessage = authState.error?.toString() ?? 'Registration failed.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final deviceType = context.deviceType;

    final shopNameField = AuthFormField(
      controller: _shopNameController,
      label: 'Shop Name',
      hintText: 'e.g. Modern Fashion Store',
      prefixIcon: Icons.store_outlined,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Shop Name is required';
        }
        return null;
      },
    );

    final phoneField = AuthFormField(
      controller: _phoneController,
      label: 'Phone Number',
      hintText: 'e.g. 09123456789',
      prefixIcon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Phone number is required';
        }
        if (!RegExp(r'^09\d{7,9}$').hasMatch(value.trim())) {
          return 'Enter a valid Myanmar phone number (09xxxxxxxxx)';
        }
        return null;
      },
    );

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
      hintText: 'At least 8 characters',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        return null;
      },
    );

    final confirmPasswordField = PasswordField(
      controller: _confirmPasswordController,
      label: 'Confirm Password',
      hintText: 'Re-enter password',
      validator: (value) {
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );

    if (deviceType == DeviceType.mobile) {
      return RegisterMobileView(
        formKey: _formKey,
        shopNameField: shopNameField,
        phoneField: phoneField,
        emailField: emailField,
        passwordField: passwordField,
        confirmPasswordField: confirmPasswordField,
        onSubmit: _submit,
        onGoToLogin: () => context.go('/login'),
        isLoading: isLoading,
        errorMessage: _errorMessage,
      );
    }

    return RegisterTabletDesktopView(
      formKey: _formKey,
      shopNameField: shopNameField,
      phoneField: phoneField,
      emailField: emailField,
      passwordField: passwordField,
      confirmPasswordField: confirmPasswordField,
      onSubmit: _submit,
      onGoToLogin: () => context.go('/login'),
      isLoading: isLoading,
      errorMessage: _errorMessage,
    );
  }
}
