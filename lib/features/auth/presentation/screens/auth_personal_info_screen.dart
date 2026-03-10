import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';

class AuthPersonalInfoScreen extends StatefulWidget {
  const AuthPersonalInfoScreen({super.key});

  @override
  State<AuthPersonalInfoScreen> createState() => _AuthPersonalInfoScreenState();
}

class _AuthPersonalInfoScreenState extends State<AuthPersonalInfoScreen> {
  String? _selectedNationality = 'Thailand';
  String? _selectedTitle;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  String? _selectedBirthDate;
  String? _selectedExpiryDate;
  final TextEditingController _addressController = TextEditingController();
  String? _selectedProvince;
  String? _selectedDistrict;
  String? _selectedSubdistrict;
  final TextEditingController _zipcodeController = TextEditingController();
  
  bool _isInputValid = false;

  @override
  void initState() {
    super.initState();
    _idController.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
       // Validate core fields, ensuring they are filled before moving to the next step.
      _isInputValid = _selectedTitle != null &&
          _nameController.text.isNotEmpty &&
          _selectedBirthDate != null &&
          _selectedExpiryDate != null &&
          _addressController.text.isNotEmpty &&
          _selectedProvince != null &&
          _selectedDistrict != null &&
          _selectedSubdistrict != null &&
          _zipcodeController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _addressController.dispose();
    _zipcodeController.dispose();
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
          'ขั้นตอนที่ 5 จาก 7',
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
              color: AppColors.divider,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width * (5 / 7),
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
                      'กรอกข้อมูลของคุณ',
                      style: AppTypography.heading3.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mass จำเป็นต้องตรวจสอบข้อมูลของคุณในฐานะเจ้าของ\nสำหรับการยืนยันตัวตนเพื่อดำเนินการลงทะเบียนและลงนาม\nในสัญญา',
                      style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMid),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'รายละเอียดโปรไฟล์ของคุณ',
                      style: AppTypography.heading5.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('สัญชาติ'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedNationality,
                          hint: Text('Thailand', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgLow)),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                          items: <String>['Thailand', 'Other'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedNationality = newValue;
                              _validateInput();
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add, color: AppColors.textPrimary),
                          const SizedBox(width: 12),
                          RichText(
                            text: TextSpan(
                              text: 'บัตรประชาชน',
                              style: AppTypography.label2.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                              children: const [
                                TextSpan(text: ' *', style: TextStyle(color: AppColors.error)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                     const SizedBox(height: 12),
                    Text(
                      'Mass ให้ความสำคัญกับความเป็นส่วนตัวของคุณ เราจะไม่ใช้หรือแชร์\nข้อมูลส่วนตัวที่ละเอียดอ่อน (เช่น ศาสนาหรือหมู่เลือด) โดยไม่ได้รับ\nอนุญาตหรือไม่มีเหตุผลทางกฎหมาย',
                      style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMid),
                    ),
                    const SizedBox(height: 24),
                    _buildTextFieldLabel('เลขประจำตัวประชาชนหรือเลขที่หนังสือเดินทาง'),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _idController,
                        keyboardType: TextInputType.number,
                        style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                        decoration: InputDecoration(
                          hintText: 'ตัวอย่าง: 1500000000000',
                          hintStyle: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgLow),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('คำนำหน้า'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedTitle,
                          hint: Text('เลือก', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgLow)),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                          items: <String>['นาย', 'นาง', 'นางสาว'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedTitle = newValue;
                              _validateInput();
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('ชื่อ-นามสกุลเจ้าของร้าน'),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _nameController,
                        style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                        decoration: InputDecoration(
                          hintText: 'ตัวอย่าง: สมหญิง ใจงาม',
                          hintStyle: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgLow),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        onChanged: (_) => _validateInput(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryLight, width: 0.5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info, color: AppColors.primary, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'โปรดกรอกชื่อ-นามสกุลของคุณ โดยไม่ต้องระบุคำนำหน้าชื่อ',
                              style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('วัน/เดือน/ปีเกิด (ปีค.ศ.)'),
                    Container(
                      decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(12),
                         border: Border.all(color: AppColors.border),
                       ),
                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                       child: InkWell(
                        onTap: () {
                          // TODO: Show Date Picker
                          setState(() {
                             _selectedBirthDate = '1990/01/01';
                             _validateInput();
                          });
                        },
                         child: Row(
                           children: [
                             const Icon(Icons.calendar_today, color: AppColors.textPrimary),
                             const SizedBox(width: 12),
                             Text(
                               _selectedBirthDate ?? 'เลือก',
                               style: AppTypography.body2.copyWith(
                                 color: _selectedBirthDate != null ? AppColors.semanticGrayNeutralFgHigh : AppColors.semanticGrayNeutralFgLow
                               ),
                             ),
                             const Spacer(),
                             const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                           ],
                         ),
                       ),
                    ),
                    const SizedBox(height: 16),
                     _buildTextFieldLabel('วันหมดอายุบัตรประชาชน'),
                    Container(
                      decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(12),
                         border: Border.all(color: AppColors.border),
                       ),
                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                       child: InkWell(
                        onTap: () {
                          // TODO: Show Date Picker
                          setState(() {
                             _selectedExpiryDate = '2030/12/31';
                             _validateInput();
                          });
                        },
                         child: Row(
                           children: [
                             const Icon(Icons.calendar_today, color: AppColors.textPrimary),
                             const SizedBox(width: 12),
                             Text(
                               _selectedExpiryDate ?? 'เลือก',
                               style: AppTypography.body2.copyWith(
                                 color: _selectedExpiryDate != null ? AppColors.semanticGrayNeutralFgHigh : AppColors.semanticGrayNeutralFgLow
                               ),
                             ),
                             const Spacer(),
                             const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                           ],
                         ),
                       ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('ที่อยู่'),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _addressController,
                        maxLines: 3,
                        style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                        decoration: InputDecoration(
                          hintText: 'กรอกรายละเอียดตามบัตรประชาชน โดยไม่ต้องระบุตำบล อำเภอ และ จังหวัด',
                          hintStyle: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgLow),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        onChanged: (_) => _validateInput(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('จังหวัด'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedProvince,
                          hint: Text('เลือก', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgLow)),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                          items: <String>['กรุงเทพมหานคร', 'เชียงใหม่', 'ภูเก็ต'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedProvince = newValue;
                              _validateInput();
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('อำเภอ / เขต'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedDistrict,
                          hint: Text('เลือก', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgLow)),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                          items: <String>['คลองสาน', 'บางรัก', 'ปทุมวัน'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedDistrict = newValue;
                              _validateInput();
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('ตำบล / แขวง'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSubdistrict,
                          hint: Text('เลือก', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgLow)),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                          items: <String>['คลองต้นไทร', 'บางลำภูล่าง', 'สมเด็จเจ้าพระยา'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedSubdistrict = newValue;
                              _validateInput();
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('รหัสไปรษณีย์'),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _zipcodeController,
                        keyboardType: TextInputType.number,
                        style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                        decoration: InputDecoration(
                          hintText: 'เช่น 10600',
                          hintStyle: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgLow),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        onChanged: (_) => _validateInput(),
                      ),
                    ),
                     Padding(
                       padding: const EdgeInsets.only(top: 8.0),
                       child: Text('กรอกรหัสไปรษณีย์ 5 หลัก', style: AppTypography.caption3.copyWith(color: Colors.black54)),
                     ),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.shield_outlined, color: AppColors.textPrimary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMid),
                              children: [
                                const TextSpan(text: 'ข้อมูลจะได้รับการจัดเก็บภายใต้ '),
                                TextSpan(
                                  text: 'นโยบายความเป็นส่วนตัว',
                                  style: AppTypography.caption5.copyWith(color: AppColors.info),
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
                    context.push('/register/bank_info');
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isInputValid ? AppColors.primary : AppColors.background,
                    foregroundColor: _isInputValid ? Colors.white : AppColors.textTertiary,
                    disabledBackgroundColor: AppColors.background,
                    disabledForegroundColor: AppColors.textTertiary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text('บันทึกและดำเนินการต่อ', style: AppTypography.label2.copyWith(color: _isInputValid ? AppColors.semanticGrayNeutralFgWhite : AppColors.semanticGrayNeutralFgLow)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
