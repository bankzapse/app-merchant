import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';
import 'package:merchant_app/features/menu/providers/menu_provider.dart';

class AddMenuItemDialog extends ConsumerStatefulWidget {
  const AddMenuItemDialog({super.key});

  @override
  ConsumerState<AddMenuItemDialog> createState() => _AddMenuItemDialogState();
}

class _AddMenuItemDialogState extends ConsumerState<AddMenuItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  
  String? _selectedCategoryId;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเลือกหมวดหมู่'), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final price = double.tryParse(_priceController.text) ?? 0.0;
      await ref.read(menuProvider.notifier).addItem(
        categoryId: _selectedCategoryId!,
        name: _nameController.text,
        description: _descController.text,
        price: price,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เพิ่มเมนูสำเร็จ'), backgroundColor: AppColors.success),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e'), backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('เพิ่มรายการเมนูใหม่', style: AppTypography.heading6),
              const SizedBox(height: 24),

              // Category Dropdown
              menuState.maybeWhen(
                data: (categories) {
                  if (categories.isEmpty) {
                    return const Text('ไม่มีหมวดหมู่ กรุณาเพิ่มหมวดหมู่ก่อน', style: TextStyle(color: AppColors.error));
                  }
                  // Auto-select first category if none selected
                  _selectedCategoryId ??= categories.first.id;
                  
                  return DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    decoration: const InputDecoration(labelText: 'หมวดหมู่'),
                    items: categories.map((cat) {
                      return DropdownMenuItem(value: cat.id, child: Text(cat.name));
                    }).toList(),
                    onChanged: (val) {
                      setState(() => _selectedCategoryId = val);
                    },
                  );
                },
                orElse: () => const Center(child: CircularProgressIndicator()),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'ชื่อเมนู'),
                validator: (val) => val == null || val.isEmpty ? 'กรุณากรอกชื่อเมนู' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'ราคา (บาท)'),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'กรุณากรอกราคา';
                  if (double.tryParse(val) == null) return 'ราคาต้องเป็นตัวเลข';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'คำอธิบาย (เผื่อเลือก)'),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context, false),
                    child: const Text('ยกเลิก', style: TextStyle(color: AppColors.textTertiary)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('เพิ่มเมนู'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
