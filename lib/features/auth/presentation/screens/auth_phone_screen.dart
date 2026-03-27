import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';

class AuthPhoneScreen extends StatefulWidget {
  const AuthPhoneScreen({super.key});

  @override
  State<AuthPhoneScreen> createState() => _AuthPhoneScreenState();
}

class _AuthPhoneScreenState extends State<AuthPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isInputValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      setState(() {
        _isInputValid = _phoneController.text.length == 10;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.semanticGrayNeutralBgWhite,
      appBar: AppBar(
        backgroundColor: AppColors.semanticGrayNeutralBgWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.semanticGrayNeutralFgHigh),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'ขั้นตอนที่ 2 จาก 7',
          style: AppTypography.heading6.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.semanticGrayNeutralFgHigh),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'โปรดระบุเบอร์โทรศัพท์ของคุณ',
                style: AppTypography.heading4.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
              ),
              const SizedBox(height: 8),
              Text(
                'ลงทะเบียนด้วยเบอร์โทรศัพท์เพื่อเริ่มต้นใช้งาน\nMass Merchant',
                style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.semanticGrayNeutralBgLightGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text('+66', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite)),
                        const SizedBox(width: 8),
                        const Icon(Icons.keyboard_arrow_down, color: AppColors.semanticGrayNeutralFgMidOnWhite, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _phoneController.text.isNotEmpty ? AppColors.primary : AppColors.semanticGrayNeutralBorderLightGray,
                        ),
                      ),
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        maxLength: 10,
                        style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                        decoration: InputDecoration(
                          hintText: '81 123 4567',
                          hintStyle: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          counterText: '',
                          suffixIcon: _phoneController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.cancel, color: AppColors.semanticGrayNeutralFgMidOnWhite, size: 20),
                                  onPressed: () {
                                    _phoneController.clear();
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isInputValid ? () {
                  context.push('/register/otp');
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isInputValid ? AppColors.primary : AppColors.semanticGrayNeutralBgLightGray,
                  foregroundColor: _isInputValid ? Colors.white : AppColors.semanticGrayNeutralFgMidOnWhite,
                  disabledBackgroundColor: AppColors.semanticGrayNeutralBgLightGray,
                  disabledForegroundColor: AppColors.semanticGrayNeutralFgMidOnWhite,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text('ต่อไป', style: AppTypography.label2.copyWith(color: _isInputValid ? Colors.white : AppColors.semanticGrayNeutralFgMidOnWhite)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
