import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';

class AuthBusinessInfoScreen extends StatefulWidget {
  const AuthBusinessInfoScreen({super.key});

  @override
  State<AuthBusinessInfoScreen> createState() => _AuthBusinessInfoScreenState();
}

class _AuthBusinessInfoScreenState extends State<AuthBusinessInfoScreen> {
  final _storeNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _detailsController = TextEditingController();
  final _contactNameController = TextEditingController();
  
  bool _isInputValid = false;

  @override
  void initState() {
    super.initState();
    _storeNameController.addListener(_validateInput);
    _addressController.addListener(_validateInput);
    _contactNameController.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
      _isInputValid = _storeNameController.text.isNotEmpty &&
          _addressController.text.isNotEmpty &&
          _contactNameController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _addressController.dispose();
    _detailsController.dispose();
    _contactNameController.dispose();
    super.dispose();
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

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.semanticGrayNeutralBorderLightGray),
      ),
      child: TextField(
        controller: controller,
        style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgLowOnWhite),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          'ขั้นตอนที่ 3 จาก 7',
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
                  width: MediaQuery.of(context).size.width * (3 / 7),
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
                      'ลงทะเบียน',
                      style: AppTypography.heading3.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'โปรดกรอกข้อมูลเพื่อแสดงให้ลูกค้าดู',
                      style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'ข้อมูลธุรกิจ',
                      style: AppTypography.heading5.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('ชื่อร้านค้า'),
                    _buildTextField(_storeNameController, 'ตัวอย่าง: กล้วยทอดมหาชัย'),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('ชื่ออาคาร/ถนน'),
                    _buildTextField(_addressController, 'เช่น ไอคอนสยาม หรือ ซอยสุขุมวิท'),
                    const SizedBox(height: 8),
                    Text(
                      'ชื่อร้านของคุณจะปรากฏบนแอป Mass ในรูปแบบต่อไปนี้: (ชื่อแบรนด์) - (ชื่ออาคาร/ชื่อถนน)',
                      style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('ที่ตั้งร้านค้า'),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.semanticGrayNeutralBorderLightGray),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: AppColors.textPrimary),
                          const SizedBox(width: 12),
                          Text(
                            'เลือกหมุดร้านค้าของคุณ',
                            style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                          ),
                          const Spacer(),
                          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('รายละเอียดร้านค้าเพิ่มเติม', isRequired: false),
                    _buildTextField(_detailsController, 'เช่น หลังคาสีแดงติดกับประตูโรงเรียน'),
                    const SizedBox(height: 8),
                    Text(
                      'ช่วยให้คนขับและลูกค้าพบร้านของคุณ',
                      style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'ข้อมูลติดต่อ (เจ้าของร้าน/ผู้จัดการร้าน)',
                      style: AppTypography.heading5.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ข้อมูลนี้จะใช้สำหรับกรณีต้องติดต่อกับร้านค้าเพื่อดำเนินการ\nต่างๆ เช่น การส่งสัญญา การแจ้งเตือนข้อมูลข่าวสาร',
                      style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('ชื่อผู้ติดต่อ'),
                    _buildTextField(_contactNameController, 'ตัวอย่าง: น.ส. สมหญิง ใจงาม'),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTextFieldLabel('เบอร์เจ้าของร้าน/ผู้จัดการร้าน'),
                            const Icon(Icons.edit, color: AppColors.semanticSecondaryFgHigh, size: 16),
                          ],
                        ),
                        Text('+66 892616445', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTextFieldLabel('อีเมลเจ้าของร้าน/ผู้จัดการร้าน'),
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
                    context.push('/register/business_type');
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
