import 'package:flutter/material.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';
import 'package:merchant_app/core/network/api_client.dart';

class StoreDetailsScreen extends StatefulWidget {
  const StoreDetailsScreen({super.key});

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'ร้านค้า แมส มาร์แชนท์');
  final _addressController = TextEditingController(text: '123 ถนนสุขุมวิท, กรุงเทพมหานคร');
  final _descController = TextEditingController(text: 'อาหารอร่อย รสชาติถูกปาก');
  bool _isLoading = false;

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final api = ApiClient();
      await api.dio.put('/api/food/restaurant/profile', data: {
        'restaurant_name': _nameController.text,
        'address': _addressController.text,
        'description': _descController.text,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกข้อมูลสำเร็จ', style: TextStyle(color: Colors.white)), backgroundColor: AppColors.success),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e'), backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดร้านค้า', style: AppTypography.heading5.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('รูปภาพร้านค้า', style: AppTypography.heading6.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildImagePicker(
                          label: 'โลโก้',
                          height: 100,
                          width: 100,
                          shape: BoxShape.circle,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildImagePicker(
                            label: 'ภาพหน้าปก',
                            height: 100,
                            shape: BoxShape.rectangle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text('ข้อมูลทั่วไป', style: AppTypography.heading6.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'ชื่อร้านค้า'),
                      validator: (val) => val == null || val.isEmpty ? 'กรุณากรอกชื่อร้านค้า' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descController,
                      decoration: const InputDecoration(labelText: 'คำอธิบาย (สั้นๆ)'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'ที่อยู่'),
                      maxLines: 3,
                      validator: (val) => val == null || val.isEmpty ? 'กรุณากรอกที่อยู่' : null,
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: const Text('บันทึกข้อมูล'),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker({required String label, required double height, double? width, required BoxShape shape}) {
    return Column(
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: AppColors.border.withOpacity(0.5),
            shape: shape,
            borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(12) : null,
          ),
          child: const Center(
            child: Icon(Icons.add_a_photo, color: AppColors.textTertiary),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTypography.body3.copyWith(color: AppColors.semanticGrayNeutralFgMid)),
      ],
    );
  }
}
