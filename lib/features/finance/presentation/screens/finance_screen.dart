import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_app/core/theme/app_typography.dart';
import 'package:merchant_app/features/finance/providers/finance_provider.dart';

class FinanceScreen extends ConsumerStatefulWidget {
  const FinanceScreen({super.key});

  @override
  ConsumerState<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends ConsumerState<FinanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedEarningsFilter = 0;
  final _earningsFilters = ['วันนี้', 'เมื่อวาน', 'สัปดาห์นี้', 'เดือนนี้'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          // ─── Header ──────────────────────────────────────
          _buildHeader(),
          // ─── Tabs ────────────────────────────────────────
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF00B14F),
              unselectedLabelColor: const Color(0xFF888888),
              indicatorColor: const Color(0xFF00B14F),
              indicatorWeight: 2,
              labelStyle: AppTypography.label3.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: AppTypography.label3,
              tabs: const [
                Tab(text: 'สรุป'),
                Tab(text: 'รายการชำระเงิน'),
                Tab(text: 'ยอดเงินที่ได้รับ'),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSummarytab(),
                _buildTransactionsTab(),
                _buildEarningsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'การเงิน',
            style: AppTypography.heading4.copyWith(
              color: const Color(0xFF111111),
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              _headerIconBtn(Icons.receipt_outlined),
              const SizedBox(width: 4),
              _headerIconBtn(Icons.qr_code_scanner_outlined),
              const SizedBox(width: 4),
              _headerIconBtn(Icons.help_outline),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerIconBtn(IconData icon) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFDDDDDD)),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF555555)),
      ),
    );
  }

  // ─── SUMMARY TAB ──────────────────────────────────────────────────────────

  Widget _buildSummarytab() {
    final summaryAsync = ref.watch(financeSummaryProvider);
    return summaryAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF00B14F))),
      error: (e, _) => Center(child: Text('เกิดข้อผิดพลาด: $e')),
      data: (summary) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryCard(summary),
            const SizedBox(height: 16),
            _buildEmptyFinanceIllustration(
              title: 'ยังไม่มีข้อมูลสรุปในตอนนี้',
              subtitle: 'ข้อมูลสรุปรายได้จะแสดงเมื่อเริ่มรับออเดอร์',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(FinanceSummary s) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00B14F), Color(0xFF00842B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('รายได้รวม',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            '฿${s.totalRevenue.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _summaryMetric('คำสั่งซื้อ', '${s.totalOrders}')),
              Expanded(child: _summaryMetric('เฉลี่ย/ออเดอร์', '฿${s.avgOrderValue.toStringAsFixed(0)}')),
              Expanded(child: _summaryMetric('รอจ่าย', '฿${s.pendingPayout.toStringAsFixed(0)}')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  // ─── TRANSACTIONS TAB ─────────────────────────────────────────────────────

  Widget _buildTransactionsTab() {
    final filters = ['วันนี้', 'บริการ', 'วิธีการชำระเงิน', 'ประเภท'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter chips
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((f) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFCCCCCC)),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Text(f, style: AppTypography.body3.copyWith(color: const Color(0xFF333333))),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, size: 14, color: Color(0xFF666666)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
        Expanded(
          child: _buildEmptyFinanceIllustration(
            title: 'ไม่มีรายการชำระเงิน',
            subtitle: 'รายการจะปรากฏเมื่อเริ่มรับออเดอร์วันนี้',
            icon: '🖥️',
          ),
        ),
      ],
    );
  }

  // ─── EARNINGS TAB ─────────────────────────────────────────────────────────

  Widget _buildEarningsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              children: [
                // Top row: calendar + filter chips
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF555555)),
                    const SizedBox(width: 8),
                    ..._earningsFilters.asMap().entries.map((entry) {
                      final i = entry.key;
                      final label = entry.value;
                      final selected = i == _selectedEarningsFilter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedEarningsFilter = i),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: selected ? const Color(0xFF00B14F) : Colors.white,
                              border: Border.all(
                                color: selected ? const Color(0xFF00B14F) : const Color(0xFFCCCCCC),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: selected ? Colors.white : const Color(0xFF444444),
                                fontSize: 12,
                                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                // Amounts
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ยอดเงินสุทธิ',
                              style: AppTypography.body3.copyWith(color: const Color(0xFF888888))),
                          const SizedBox(height: 4),
                          Text('฿0.00',
                              style: AppTypography.heading3.copyWith(
                                color: const Color(0xFF111111),
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ค้างชำระ',
                              style: AppTypography.body3.copyWith(color: const Color(0xFF888888))),
                          const SizedBox(height: 4),
                          Text('฿0.00',
                              style: AppTypography.heading3.copyWith(
                                color: const Color(0xFF111111),
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          SizedBox(
            height: 360,
            child: _buildEmptyFinanceIllustration(
              title: 'ไม่มีข้อมูลการจ่ายรายได้',
              subtitle: 'รายได้จะแสดงหลังจากคุณเริ่มรับและดำเนินการคำสั่งซื้อ',
              icon: '💰',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFinanceIllustration({
    required String title,
    required String subtitle,
    String icon = '🖥️',
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTypography.heading6.copyWith(
                color: const Color(0xFF333333),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTypography.body3
                  .copyWith(color: const Color(0xFF888888)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
