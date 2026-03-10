import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';

class AuthEmailPasswordScreen extends StatefulWidget {
  const AuthEmailPasswordScreen({super.key});

  @override
  State<AuthEmailPasswordScreen> createState() => _AuthEmailPasswordScreenState();
}

class _AuthEmailPasswordScreenState extends State<AuthEmailPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _saveData = true;
  bool _isInputValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateInput);
    _passwordController.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
      _isInputValid = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
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
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'ขั้นตอนที่ 2 จาก 7',
          style: AppTypography.heading6.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'ตั้งค่าอีเมลและรหัสผ่าน',
                      style: AppTypography.heading4.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'อีเมลนี้สำหรับการลงทะเบียนในนามของร้าน และการเข้าสู่ระบบ\nบนแอป Mass Merchant',
                      style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite),
                    ),
                    const SizedBox(height: 32),
                    RichText(
                      text: TextSpan(
                        text: 'อีเมล ',
                        style: AppTypography.label2.copyWith(color: AppColors.semanticGrayNeutralFgHigh, fontWeight: FontWeight.normal),
                        children: [
                          const TextSpan(text: '*', style: TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.semanticGrayNeutralBorderLightGray),
                      ),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                        decoration: InputDecoration(
                          hintText: 'เช่น name@email.com',
                          hintStyle: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgLowOnWhite),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      text: TextSpan(
                        text: 'รหัสผ่าน ',
                        style: AppTypography.label2.copyWith(color: AppColors.semanticGrayNeutralFgHigh, fontWeight: FontWeight.normal),
                        children: [
                          const TextSpan(text: '*', style: TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.semanticGrayNeutralBorderLightGray),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                        decoration: InputDecoration(
                          hintText: 'กรอกรหัสผ่านที่ปลอดภัย',
                          hintStyle: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgLowOnWhite),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.textPrimary,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('บันทึกข้อมูลไว้ใช้เข้าสู่ระบบ', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                        Switch(
                          value: _saveData,
                          onChanged: (value) {
                            setState(() {
                              _saveData = value;
                            });
                          },
                          activeColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isInputValid ? () {
                    context.push('/register/business_info');
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isInputValid ? AppColors.primary : AppColors.background,
                    foregroundColor: _isInputValid ? Colors.white : AppColors.semanticGrayNeutralFgLowOnWhite,
                    disabledBackgroundColor: AppColors.background,
                    disabledForegroundColor: AppColors.semanticGrayNeutralFgLowOnWhite,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text('ต่อไป', style: AppTypography.label2.copyWith(color: _isInputValid ? AppColors.semanticGrayNeutralFgWhite : AppColors.semanticGrayNeutralFgLowOnWhite)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
