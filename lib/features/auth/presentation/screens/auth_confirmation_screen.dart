import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';

class AuthConfirmationScreen extends StatefulWidget {
  const AuthConfirmationScreen({super.key});

  @override
  State<AuthConfirmationScreen> createState() => _AuthConfirmationScreenState();
}

class _AuthConfirmationScreenState extends State<AuthConfirmationScreen> {
  bool _agreedToTerms = false;
  bool _agreedToCampaign = false;
  bool _agreedToMarketing = false;
  bool _hasReferralCode = false;

  bool _isInputValid = false;

  void _validateInput() {
    setState(() {
      _isInputValid = _agreedToTerms && _agreedToCampaign && _agreedToMarketing;
    });
  }

  Widget _buildCheckboxRow(bool value, String text, Function(bool?) onChanged, {List<TextSpan>? richText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              side: const BorderSide(color: AppColors.semanticGrayNeutralBorderLightGray, width: 2),
            ),
          ),
          const SizedBox(width: 16),
           Expanded(
              child: richText != null 
              ? RichText(
                  text: TextSpan(
                    style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite, height: 1.5),
                    children: richText,
                  ),
                )
              : Text(
               text,
               style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite, height: 1.5),
             ),
           ),
        ],
      ),
    );
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
          'ขั้นตอนที่ 7 จาก 7',
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
        child: Column(
          children: [
            Container(
              height: 4,
              width: double.infinity,
              color: AppColors.semanticGrayNeutralBgLightGray,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: double.infinity,
                  color: AppColors.primary,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'คำยืนยัน',
                      style: AppTypography.heading3.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'เมื่อทำเครื่องหมายในช่องด้านล่าง จะถือว่าคุณยืนยันในนาม\nของคุณ บริษัท และบุคคลที่ได้รับการเสนอชื่อ (รวมเรียกว่า\n"คุณ") ว่าคุณได้อ่าน ทำความเข้าใจ และยอมรับ:',
                      style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite, height: 1.5),
                    ),
                    const SizedBox(height: 32),
                    _buildCheckboxRow(
                      _agreedToTerms,
                      '',
                      (value) {
                         setState(() {
                          _agreedToTerms = value ?? false;
                          _validateInput();
                        });
                      },
                      richText: [
                        TextSpan(text: 'ข้อตกลงการใช้งาน Mass', style: AppTypography.caption5.copyWith(color: AppColors.semanticSecondaryFgHigh)),
                        const TextSpan(text: ', '),
                        TextSpan(text: 'ข้อกำหนดและ\nเงื่อนไขร้านค้า (ข้อกำหนดและเงื่อนไข\nMassFood)', style: AppTypography.caption5.copyWith(color: AppColors.semanticSecondaryFgHigh)),
                        const TextSpan(text: ', '),
                         TextSpan(text: 'ความยินยอมรับข้อตกลง', style: AppTypography.caption5.copyWith(color: AppColors.semanticSecondaryFgHigh)),
                        const TextSpan(text: ',\n'),
                        TextSpan(text: 'นโยบายสินค้า', style: AppTypography.caption5.copyWith(color: AppColors.semanticSecondaryFgHigh)),
                         const TextSpan(text: ', '),
                        TextSpan(text: 'ประกาศความเป็นส่วนตัวของ\nMass', style: AppTypography.caption5.copyWith(color: AppColors.semanticSecondaryFgHigh)),
                      ]
                    ),
                    _buildCheckboxRow(
                      _agreedToCampaign,
                      '',
                      (value) {
                        setState(() {
                          _agreedToCampaign = value ?? false;
                          _validateInput();
                        });
                      },
                       richText: [
                        const TextSpan(text: 'ตกลงเข้าร่วมทดลองใช้ฟรีแคมเปญร้านเล็ก\nลดทั้งร้าน (ตกลงยอมรับ'),
                        TextSpan(text: 'เงื่อนไขระยะเวลา\nยกเว้นค่าธรรมเนียมแคมเปญ "ร้านเล็กลดทั้ง\nร้าน"', style: AppTypography.caption5.copyWith(color: AppColors.semanticSecondaryFgHigh)),
                        const TextSpan(text: ' และ '),
                        TextSpan(text: 'ข้อกำหนดของการให้บริการ Mass\nMarketing Services', style: AppTypography.caption5.copyWith(color: AppColors.semanticSecondaryFgHigh)),
                        const TextSpan(text: ')'),
                      ]
                    ),
                    _buildCheckboxRow(
                      _agreedToMarketing,
                       '',
                      (value) {
                         setState(() {
                          _agreedToMarketing = value ?? false;
                          _validateInput();
                        });
                      },
                      richText: [
                        const TextSpan(text: 'การส่ง'),
                        TextSpan(text: 'ข้อมูลการตลาด', style: AppTypography.caption5.copyWith(color: AppColors.semanticSecondaryFgHigh)),
                        const TextSpan(text: ' เช่น แนวทางปฏิบัติที่\nดีที่สุด ข้อมูลเชิงลึก และโปรโมชันเพื่อช่วย\nเพิ่มยอดขาย'),
                      ]
                    ),
                    const SizedBox(height: 16),
                    Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(
                            'ฉันมีรหัสผู้แนะนำ',
                            style: AppTypography.caption5.copyWith(fontWeight: FontWeight.bold, color: AppColors.semanticGrayNeutralFgHigh),
                          ),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _hasReferralCode,
                              onChanged: (value) {
                                 setState(() {
                                    _hasReferralCode = value ?? false;
                                 });
                              },
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              side: const BorderSide(color: AppColors.semanticGrayNeutralBorderLightGray, width: 2),
                            ),
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
                    context.go('/');
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isInputValid ? AppColors.semanticSuccessBgHigh : AppColors.semanticGrayNeutralBgLightGray,
                    foregroundColor: _isInputValid ? Colors.white : AppColors.semanticGrayNeutralFgMidOnWhite,
                    disabledBackgroundColor: AppColors.semanticGrayNeutralBgLightGray,
                    disabledForegroundColor: AppColors.semanticGrayNeutralFgMidOnWhite,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text('ส่ง', style: AppTypography.label2.copyWith(color: _isInputValid ? Colors.white : AppColors.semanticGrayNeutralFgMidOnWhite)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
