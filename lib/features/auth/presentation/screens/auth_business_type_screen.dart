import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';

class AuthBusinessTypeScreen extends StatefulWidget {
  const AuthBusinessTypeScreen({super.key});

  @override
  State<AuthBusinessTypeScreen> createState() => _AuthBusinessTypeScreenState();
}

class _AuthBusinessTypeScreenState extends State<AuthBusinessTypeScreen> {
  String? _selectedBusinessType;
  
  bool _isInputValid = false;

  void _validateInput() {
    setState(() {
      _isInputValid = _selectedBusinessType != null;
    });
  }

  Widget _buildTextFieldLabel(String label, {bool isRequired = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          text: label,
          style: AppTypography.label2.copyWith(color: AppColors.semanticGrayNeutralFgHigh, fontWeight: FontWeight.normal),
          children: isRequired
              ? [const TextSpan(text: ' *', style: TextStyle(color: AppColors.error))]
              : [],
        ),
      ),
    );
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
          'ขั้นตอนที่ 4 จาก 7',
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
            Container(
              height: 4,
              width: double.infinity,
              color: AppColors.semanticGrayNeutralBorderLightGray,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width * (4 / 7),
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
                      'ข้อมูลร้าน',
                      style: AppTypography.heading3.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'โปรดกรอกข้อมูลร้าน ช่องทางการติดต่อ และเอกสารสำหรับ\nตรวจสอบยืนยัน',
                      style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'ข้อมูลธุรกิจ',
                      style: AppTypography.heading5.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('ประเภทธุรกิจ'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.semanticGrayNeutralBorderLightGray),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedBusinessType,
                          hint: Text('เลือกประเภทธุรกิจ', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgLowOnWhite)),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                          items: <String>['ธุรกิจส่วนตัว', 'ห้างหุ้นส่วนจำกัด', 'บริษัทจำกัด'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedBusinessType = newValue;
                              _validateInput();
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'ช่องทางการติดต่อเจ้าของธุรกิจ',
                      style: AppTypography.heading5.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ธุรกิจส่วนตัวหรือกิจการที่มีเจ้าของคนเดียว สามารถใช้เบอร์\nและอีเมลของเจ้าของ เพื่อเป็นช่องทางในการติดต่อ',
                      style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTextFieldLabel('เบอร์เจ้าของธุรกิจ'),
                            const Icon(Icons.edit, color: AppColors.semanticSecondaryFgHigh, size: 16),
                          ],
                        ),
                        Text('+66 892616445', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTextFieldLabel('อีเมลเจ้าของธุรกิจ'),
                            const Icon(Icons.edit, color: AppColors.semanticSecondaryFgHigh, size: 16),
                          ],
                        ),
                        Text('test@example.com', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.shield_outlined, color: AppColors.textPrimary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite),
                              children: [
                                const TextSpan(text: 'ข้อมูลจะได้รับการจัดเก็บภายใต้ '),
                                TextSpan(
                                  text: 'นโยบายความเป็นส่วนตัว',
                                  style: AppTypography.caption5.copyWith(color: AppColors.semanticSecondaryFgHigh),
                                ),
                                const TextSpan(text: ' ของเรา'),
                              ],
                            ),
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
                     context.push('/register/personal_info');
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
                  child: Text('บันทึกและดำเนินการต่อ', style: AppTypography.label2.copyWith(color: _isInputValid ? AppColors.semanticGrayNeutralFgWhite : AppColors.semanticGrayNeutralFgLowOnWhite)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
