import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 30,
          right: 30,
          top: MediaQuery.of(context).size.height * 0.05,
          bottom: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Forgot Password',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 30),
              Text(
                'Please enter your email, we’ll send an email with instructions to reset your password.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 30),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Send Reset Link'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
