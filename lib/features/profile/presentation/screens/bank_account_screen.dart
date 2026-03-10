import 'package:flutter/material.dart';
import 'package:merchant_app/core/theme/app_colors.dart';
import 'package:merchant_app/core/theme/app_typography.dart';
import 'package:merchant_app/core/network/api_client.dart';

class BankAccountScreen extends StatefulWidget {
  const BankAccountScreen({super.key});

  @override
  State<BankAccountScreen> createState() => _BankAccountScreenState();
}

class _BankAccountScreenState extends State<BankAccountScreen> {
  final double _currentBalance = 15420.50;
  bool _isLoading = false;

  void _showWithdrawDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ระบุจำนวนเงินที่ต้องการถอน', style: AppTypography.heading6),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'จำนวนเงิน (บาท)',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก', style: TextStyle(color: AppColors.semanticGrayNeutralFgLowOnWhite)),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(controller.text);
                if (amount != null && amount > 0 && amount <= _currentBalance) {
                  Navigator.pop(context);
                  _processWithdrawal(amount);
                } else if (amount != null && amount > _currentBalance) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ยอดเงินไม่เพียงพอ'), backgroundColor: AppColors.error),
                  );
                }
              },
              child: const Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _processWithdrawal(double amount) async {
    setState(() => _isLoading = true);

    try {
      final api = ApiClient();
      await api.dio.post('/api/food/restaurant/withdraw', data: {
        'amount': amount,
      });

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Icon(Icons.check_circle, color: AppColors.success, size: 64),
          content: Text(
            'ส่งคำขอถอนเงินจำนวน ฿${amount.toStringAsFixed(2)} สำเร็จ\n\nระบบจะโอนเข้าบัญชีของคุณภายใน 1-2 วันทำการ',
            textAlign: TextAlign.center,
            style: AppTypography.body2,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to profile
                },
                child: const Text('ตกลง', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
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
        title: Text('บัญชีธนาคาร', style: AppTypography.heading5.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ยอดเงินที่ถอนได้', style: TextStyle(color: Colors.white70, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(
                          '฿${_currentBalance.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text('บัญชีรับเงินของคุณ', style: AppTypography.heading6.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                  const SizedBox(height: 16),
                  Card(
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.semanticGrayNeutralBorderLightGray)),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(8)),
                        child: Icon(Icons.account_balance, color: Colors.purple.shade400),
                      ),
                      title: Text('ธนาคารไทยพาณิชย์ (SCB)', style: AppTypography.body1.copyWith(color: AppColors.semanticGrayNeutralFgHigh)),
                      subtitle: Text('***-***-1234\nนาย สมชาย เข็มกลัด', style: AppTypography.body3.copyWith(color: AppColors.semanticGrayNeutralFgMidOnWhite)),
                      isThreeLine: true,
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _showWithdrawDialog,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('ถอนเงินเลย', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
