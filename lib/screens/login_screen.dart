import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import 'register_screen.dart';
import 'admin_dashboard_screen.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildLoginForm(),
              const SizedBox(height: 20),
              _buildRememberMe(),
              const SizedBox(height: 30),
              _buildLoginButton(),
              const SizedBox(height: 20),
              _buildForgotPassword(),
              const SizedBox(height: 40),
              _buildDivider(),
              const SizedBox(height: 20),
              _buildSocialLogin(),
              const SizedBox(height: 30),
              _buildSignUpPrompt(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF00ACC1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00ACC1).withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.person,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Karibu Tena!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00695C),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Ingia kwenye akaunti yako",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF455A64),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: _inputDecorationContainer(),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: _inputDecoration(
          label: "Barua pepe",
          hint: "Ingiza barua pepe yako",
          icon: Icons.email_outlined,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Tafadhali ingiza barua pepe';
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Ingiza barua pepe sahihi';
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: _inputDecorationContainer(),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: _inputDecoration(
          label: "Nywila",
          hint: "Ingiza nywila yako",
          icon: Icons.lock_outline,
          isPassword: true,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Tafadhali ingiza nywila';
          if (value.length < 6) return 'Nywila lazima iwe angalau herufi 6';
          return null;
        },
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF00ACC1)),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: const Color(0xFF00ACC1),
              ),
              onPressed: () {
                setState(() => _isPasswordVisible = !_isPasswordVisible);
              },
            )
          : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  BoxDecoration _inputDecorationContainer() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildRememberMe() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) => setState(() => _rememberMe = value ?? false),
          activeColor: const Color(0xFF00ACC1),
        ),
        const Text(
          "Nikumbuke",
          style: TextStyle(color: Color(0xFF455A64), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Consumer<UserService>(
      builder: (context, userService, child) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: userService.isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00ACC1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
            child: userService.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                  )
                : const Text("Ingia", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Widget _buildForgotPassword() {
    return TextButton(
      onPressed: _showForgotPasswordDialog,
      child: const Text(
        "Umesahau nywila?",
        style: TextStyle(color: Color(0xFF00ACC1), fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.grey)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 9),
          child: Text("AU", style: TextStyle(color: Colors.grey, fontSize: 14)),
        ),
        Expanded(child: Divider(color: Colors.grey)),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialButton(Icons.g_mobiledata, Colors.red, "Google"),
        _buildSocialButton(Icons.facebook, Colors.blue, "Facebook"),
        _buildSocialButton(Icons.alternate_email, Colors.lightBlue, "Twitter"),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, Color color, String provider) {
    return GestureDetector(
      onTap: () => _handleSocialLogin(provider),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }

  Widget _buildSignUpPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Huna akaunti? ", style: TextStyle(color: Color(0xFF455A64), fontSize: 14)),
        TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
          },
          child: const Text("Jisajili", style: TextStyle(color: Color(0xFF00ACC1), fontSize: 14, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userService = Provider.of<UserService>(context, listen: false);

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // ✅ Admin login check
      if (email == "admin@fishing.com" && password == "admin123") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
        );
        return;
      }

      try {
        final success = await userService.login(email, password);

        if (success && userService.currentUser != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Barua pepe au nywila si sahihi"), backgroundColor: Colors.red),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hitilafu ya mfumo: ${e.toString()}"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _handleSocialLogin(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Kuingia kwa $provider kunafunguliwa..."), backgroundColor: const Color(0xFF00ACC1)),
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Umesahau Nywila?"),
        content: const Text("Utapokea ujumbe wa barua pepe kurudisha nywila yako."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Ghairi")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Ujumbe wa kurudisha nywila umetumwa!"), backgroundColor: Color(0xFF00ACC1)),
              );
            },
            child: const Text("Tuma"),
          ),
        ],
      ),
    );
  }
}
