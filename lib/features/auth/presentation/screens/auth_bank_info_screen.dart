import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';

class AuthBankInfoScreen extends StatefulWidget {
  const AuthBankInfoScreen({super.key});

  @override
  State<AuthBankInfoScreen> createState() => _AuthBankInfoScreenState();
}

class _AuthBankInfoScreenState extends State<AuthBankInfoScreen> {
  final TextEditingController _accountOwnerController = TextEditingController(text: 'นาย ธนนันต์ อนุรักษ์');
  String? _selectedBank;
  final TextEditingController _accountNumberController = TextEditingController();
  
  bool _isInputValid = false;

  @override
  void initState() {
    super.initState();
    _accountOwnerController.addListener(_validateInput);
    _accountNumberController.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
      _isInputValid = _accountOwnerController.text.isNotEmpty &&
          _selectedBank != null &&
          _accountNumberController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _accountOwnerController.dispose();
    _accountNumberController.dispose();
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
          'ขั้นตอนที่ 6 จาก 7',
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
                  width: MediaQuery.of(context).size.width * (6 / 7),
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
                      'ใกล้เรียบร้อยแล้ว! โปรดกรอก\nข้อมูลธนาคารและการเงิน',
                      style: AppTypography.heading3.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Mass จำเป็นต้องขอบัญชีธนาคาร เพื่อยืนยันข้อมูลธนาคาร\nและดำเนินการธุรกรรมการเงินกับคุณ ซึ่งรายได้จะถูกโอน\nผ่านทางบัญชีธนาคารที่คุณลงทะเบียน',
                      style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMid),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'ข้อมูลบัญชีธนาคาร',
                      style: AppTypography.heading5.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('เจ้าของบัญชี'),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _accountOwnerController,
                        style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                        decoration: InputDecoration(
                          hintText: 'ชื่อ-นามสกุล',
                          hintStyle: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgLow),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        onChanged: (_) => _validateInput(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('ชื่อธนาคาร'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedBank,
                          hint: Text('เลือก', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgLow)),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                          items: <String>['กสิกรไทย', 'ไทยพาณิชย์', 'กรุงไทย'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedBank = newValue;
                              _validateInput();
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFieldLabel('เลขบัญชี'),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _accountNumberController,
                        keyboardType: TextInputType.number,
                        style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                        decoration: InputDecoration(
                          hintText: '8888888888',
                          hintStyle: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgLow),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        onChanged: (_) => _validateInput(),
                      ),
                    ),
                    const SizedBox(height: 32),
                     Text(
                      'เอกสารที่ต้องใช้',
                      style: AppTypography.heading5.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mass จำเป็นต้องขอบัญชีธนาคาร เพื่อยืนยันข้อมูลธนาคาร\nและดำเนินการธุรกรรมการเงินกับคุณ',
                      style: AppTypography.caption3.copyWith(color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    // Image picker representation 1
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border, style: BorderStyle.solid), // Should be dashed in real app
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add, color: AppColors.textPrimary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'รูปถ่ายสมุดบัญชีธนาคาร',
                                    style: AppTypography.label2.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                                    children: const [
                                      TextSpan(text: ' *', style: TextStyle(color: AppColors.error)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text('ไฟล์ .pdf .jpg หรือ .png', style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMid)),
                              ],
                            ),
                          ),
                        ],
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
                              'ชื่อเจ้าของบัญชีธนาคารที่คุณอัปโหลด ต้องตรง\nตามชื่อที่ใช้ลงทะเบียนในการสมัครเท่านั้น',
                              style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                     Text(
                      'เอกสารเพิ่มเติม (ไม่บังคับ)',
                      style: AppTypography.heading5.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'โปรดอัปโหลดเอกสารเพิ่มเติม ในกรณีดังต่อไปนี้\n• หนังสือรับรองการเปลี่ยนชื่อ-สกุล หรือใบทะเบียนสมรส\n   หย่า หากชื่อเจ้าของบัญชีไม่ตรงตามชื่อที่ใช้ลงทะเบียน\n• บัตรประชาชนของทุกบุคคล หากใช้บัญชีร่วม',
                      style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMid),
                    ),
                    const SizedBox(height: 16),
                    // Image picker representation 2
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border, style: BorderStyle.solid), // Should be dashed
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.add, color: AppColors.textPrimary),
                            const SizedBox(height: 8),
                            Text('เพิ่มไฟล์', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'ผู้จัดการฝ่ายการเงิน',
                      style: AppTypography.heading5.copyWith(color: AppColors.semanticGrayNeutralFgHigh),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mass จะใช้ข้อมูลนี้สำหรับกรณีที่ต้องติดต่อเกี่ยวกับบัญชี\nธนาคาร ข้อมูลใบแจ้งหนี้ หรือใบกำกับภาษี',
                      style: AppTypography.caption5.copyWith(color: AppColors.semanticGrayNeutralFgMid),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTextFieldLabel('ชื่อผู้จัดการฝ่ายการเงิน'),
                            const Icon(Icons.edit, color: AppColors.info, size: 16),
                          ],
                        ),
                        Text('นาย ธนนันต์ อนุรักษ์', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTextFieldLabel('เบอร์เจ้าของร้าน/ผู้จัดการฝ่ายการเงิน'),
                            const Icon(Icons.edit, color: AppColors.info, size: 16),
                          ],
                        ),
                        Text('+66 892616445', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                        const SizedBox(height: 16),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTextFieldLabel('อีเมลเจ้าของร้าน/ผู้จัดการฝ่ายการเงิน'),
                            const Icon(Icons.edit, color: AppColors.info, size: 16),
                          ],
                        ),
                        Text('bankzapse@gmail.com', style: AppTypography.body2.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                      ],
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
                    context.push('/register/confirmation');
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
