import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Container(
                         height: 200,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           color: AppColors.primaryLight,
                           borderRadius: BorderRadius.circular(16),
                         ),
                         child: const Center(
                           child: Icon(Icons.storefront_rounded, size: 80, color: AppColors.primary),
                         ),
                       ),
                       const SizedBox(height: 32),
                       Text(
                         'เข้าถึงลูกค้ามากมายนับล้าน',
                         style: AppTypography.heading4.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                         textAlign: TextAlign.center,
                       ),
                       const SizedBox(height: 12),
                       Text(
                         'ขยายรูปแบบการให้บริการ ไม่ว่าจะเป็นเดลิเวอรี ให้ลูกค้ามารับที่ร้านได้ รับชำระแบบไม่ใช้เงินสด และอื่นๆ อีกมากมาย',
                         style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite),
                         textAlign: TextAlign.center,
                       ),
                       const SizedBox(height: 24),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.semanticGrayNeutralBorderLightGray, shape: BoxShape.circle)),
                           const SizedBox(width: 8),
                           Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.semanticGrayNeutralBorderLightGray, shape: BoxShape.circle)),
                           const SizedBox(width: 8),
                           Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.semanticGrayNeutralBorderLightGray, shape: BoxShape.circle)),
                         ],
                       ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.push('/register/phone'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            foregroundColor: AppColors.primaryDark,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Text('ลงทะเบียน', style: AppTypography.label2.copyWith(color: AppColors.primaryDark)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.push('/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Text('เข้าสู่ระบบ', style: AppTypography.label2.copyWith(color: AppColors.semanticGrayNeutralFgWhite)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite),
                      children: [
                        const TextSpan(text: 'ข้าพเจ้าได้อ่าน เข้าใจ และยอมรับ '),
                        TextSpan(text: 'ข้อตกลงการใช้บริการ', style: AppTypography.caption5.copyWith(color: AppColors.semanticSecondaryFgHigh)),
                        const TextSpan(text: ' และ\n'),
                        TextSpan(text: 'นโยบายความเป็นส่วนตัว', style: AppTypography.caption5.copyWith(color: AppColors.semanticSecondaryFgHigh)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
