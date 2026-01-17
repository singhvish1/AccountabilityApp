import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  bool _showSignIn = false;
  bool _showSignUp = false;

  @override
  Widget build(BuildContext context) {
    if (_showSignIn) {
      return SignInScreen(
        onBack: () => setState(() => _showSignIn = false),
        onSwitchToSignUp: () {
          setState(() {
            _showSignIn = false;
            _showSignUp = true;
          });
        },
      );
    }

    if (_showSignUp) {
      return SignUpScreen(
        onBack: () => setState(() => _showSignUp = false),
        onSwitchToSignIn: () {
          setState(() {
            _showSignUp = false;
            _showSignIn = true;
          });
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: const [
                  _OnboardingPage(
                    icon: Icons.lock_outline,
                    title: 'Stay Accountable',
                    description:
                        'Let someone you trust help you stay focused and build better habits',
                  ),
                  _OnboardingPage(
                    icon: Icons.notifications_active,
                    title: 'Request Access',
                    description:
                        'Need to use a blocked app? Send a quick request to your accountability partner',
                  ),
                  _OnboardingPage(
                    icon: Icons.check_circle_outline,
                    title: 'Get Temporary Access',
                    description:
                        'Your partner can approve requests and grant you 5-minute passes when needed',
                  ),
                ],
              ),
            ),
            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? AppColors.primary
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => _showSignUp = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () => setState(() => _showSignIn = true),
                    child: const Text(
                      'I already have an account',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: AppColors.primary),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Sign In Screen
class SignInScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSwitchToSignUp;

  const SignInScreen({
    super.key,
    required this.onBack,
    required this.onSwitchToSignUp,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: widget.onBack,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Icon(Icons.person_outline, size: 80, color: AppColors.primary),
                const SizedBox(height: 20),
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => Validators.getEmailError(value ?? ''),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Password is required' : null,
                ),
                const SizedBox(height: 10),
                if (auth.errorMessage != null)
                  Text(
                    auth.errorMessage!,
                    style: const TextStyle(color: AppColors.error),
                  ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);
                            await auth.signIn(
                              _emailController.text,
                              _passwordController.text,
                            );
                            if (mounted) setState(() => _isLoading = false);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign In'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: widget.onSwitchToSignUp,
                      child: const Text('Sign Up'),
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

// Sign Up Screen
class SignUpScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSwitchToSignIn;

  const SignUpScreen({
    super.key,
    required this.onBack,
    required this.onSwitchToSignIn,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  AuthType _authType = AuthType.password;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: widget.onBack,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.person_add, size: 80, color: AppColors.primary),
                const SizedBox(height: 20),
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Name is required' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => Validators.getEmailError(value ?? ''),
                ),
                const SizedBox(height: 20),
                // Auth type selector
                SegmentedButton<AuthType>(
                  segments: const [
                    ButtonSegment(value: AuthType.password, label: Text('Password')),
                    ButtonSegment(value: AuthType.pin, label: Text('6-Digit PIN')),
                  ],
                  selected: {_authType},
                  onSelectionChanged: (Set<AuthType> newSelection) {
                    setState(() => _authType = newSelection.first);
                  },
                ),
                const SizedBox(height: 20),
                // Conditional fields based on auth type
                if (_authType == AuthType.password) ...[
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => Validators.getPasswordError(value ?? ''),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value != _passwordController.text ? 'Passwords do not match' : null,
                  ),
                ] else ...[
                  TextFormField(
                    controller: _pinController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: '6-Digit PIN',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => Validators.getPINError(value ?? ''),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _confirmPinController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: 'Confirm PIN',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value != _pinController.text ? 'PINs do not match' : null,
                  ),
                ],
                const SizedBox(height: 10),
                if (auth.errorMessage != null)
                  Text(
                    auth.errorMessage!,
                    style: const TextStyle(color: AppColors.error),
                  ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);
                            final credential = _authType == AuthType.password
                                ? _passwordController.text
                                : _pinController.text;
                            await auth.signUp(
                              _emailController.text,
                              credential,
                              _nameController.text,
                              _authType,
                            );
                            if (mounted) setState(() => _isLoading = false);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign Up'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    TextButton(
                      onPressed: widget.onSwitchToSignIn,
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
