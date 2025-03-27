import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hopehive/core/routes.dart';
import 'package:hopehive/features/auth/domain/auth_service.dart';
import 'package:hopehive/features/auth/domain/login_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AuthPage extends ConsumerWidget {
  AuthPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);
    final errorMessage = ref.watch(errorMessageProvider);
    final authService = AuthService();

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 30,
          right: 30,
          top: MediaQuery.of(context).size.height * 0.21,
          bottom: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: Image.asset('assets/logo/text_logo.png'),
              ),
              const SizedBox(height: 150),
              if (errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF94449).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Color(0xFFF94449)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Color(0xFFF94449)),
                        ),
                      ),
                    ],
                  ),
                ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                controller: _emailController,
                validator: (value) {
                  const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                  final regex = RegExp(pattern);

                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!regex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.forgotPassword),
                  child: Text(
                    'Forgot your Password?',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            authService.login(
                              ref,
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Login'),
                ),
              ),
              const SizedBox(height: 45),
              Text(
                'Or continue with',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () => authService.loginWithGoogle(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF00A8AA).withOpacity(0.1),
                        foregroundColor: Theme.of(context).primaryColor,
                        shadowColor: Colors.transparent,
                      ),
                      child: Icon(MdiIcons.google, size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => authService.loginWithFacebook(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A8AA).withOpacity(0.1),
                      foregroundColor: Theme.of(context).primaryColor,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Icon(Icons.facebook_rounded, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.register),
                    child: Text(
                      'Create new account',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
