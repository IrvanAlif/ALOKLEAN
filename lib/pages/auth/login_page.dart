import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/cleaner_model.dart';
import '../../models/user_model.dart';
import '../cleaner/cleaner_dashboard_page.dart';
import '../user/main_navigation_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      // Cek login sebagai User (Pelanggan)
      final user = dummyUsers.firstWhere(
        (u) =>
            u.email == _emailController.text &&
            u.password == _passwordController.text,
        orElse: () => UserModel(
          id: '',
          name: '',
          email: '',
          phone: '',
          password: '',
          role: '',
        ),
      );

      // Cek login sebagai Cleaner
      final cleaner = cleaners.firstWhere(
        (c) =>
            c.email == _emailController.text &&
            c.password == _passwordController.text,
        orElse: () => CleanerModel(
          name: '',
          id: '',
          phone: '',
          experience: '',
          rating: 0,
          verified: false,
          imagePath: '',
          email: '',
          password: '',
          role: '',
        ),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (!mounted) return;

      // Redirect berdasarkan role
      if (user.id.isNotEmpty && user.role == 'user') {
        // Login sebagai Pelanggan
        currentUser = user;
        currentCleaner = null;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationPage()),
        );
      } else if (cleaner.id.isNotEmpty && cleaner.role == 'cleaner') {
        // Login sebagai Cleaner
        currentCleaner = cleaner;
        currentUser = null;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CleanerDashboardPage()),
        );
      } else {
        // Login gagal
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email atau password salah'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B4FA8),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.cleaning_services,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'ALOKLEAN',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0B4FA8),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Cleaning Service Digital',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 48),

                // Form Login
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email wajib diisi';
                          }
                          if (!value.contains('@')) {
                            return 'Email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password wajib diisi';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD54F),
                            foregroundColor: const Color(0xFF705D00),
                          ),
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF705D00),
                                  ),
                                )
                              : const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum punya akun?'),
                    TextButton(
                      onPressed: _goToRegister,
                      child: const Text('Daftar Sekarang'),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Info Akun Demo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Akun Demo',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0B4FA8),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Pelanggan (User):',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Email: ${dummyUsers.first.email}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Password: ${dummyUsers.first.password}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Cleaner:',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      ...cleaners.map(
                        (c) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${c.name}: ${c.email}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Password: ${c.password}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
