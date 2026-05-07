import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/services/retailer_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/provider/auth_provider.dart';

final retailerStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(retailerServiceProvider);
  return service.getDashboardStats();
});

final retailerIncomeProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(retailerServiceProvider);
  return service.getRetailerIncome();
});

class RetailerHomePage extends ConsumerWidget {
  const RetailerHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(retailerStatsProvider);
    final incomeAsync = ref.watch(retailerIncomeProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Retailer Dashboard', 
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF1E293B)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF1E293B)),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(retailerStatsProvider);
          ref.invalidate(retailerIncomeProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeHeader(user?.fullName ?? 'Retailer'),
              const SizedBox(height: 24),
              statsAsync.when(
                data: (stats) => _buildStatsGrid(stats, incomeAsync.value ?? {}),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Recent Performance'),
              const SizedBox(height: 16),
              _buildPerformanceChart(),
              const SizedBox(height: 24),
              _buildSectionHeader('Today\'s Prep List'),
              const SizedBox(height: 16),
              _buildPrepList(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome back,', 
          style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
        Text(name, 
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
      ],
    ).animate().fadeIn().slideX();
  }

  Widget _buildStatsGrid(Map<String, dynamic> stats, Map<String, dynamic> income) {
    final totalSales = stats['totalSales'] ?? '0';
    final totalOrders = stats['totalOrders'] ?? '0';
    final activeProducts = stats['activeProducts'] ?? '0';
    final totalCustomers = stats['totalCustomers'] ?? '0';
    final deliveryIncome = income['totalIncome'] ?? '0';

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard('Total Sales', '₹$totalSales', Icons.payments_outlined, const Color(0xFF0EA5E9)),
        _buildStatCard('Total Orders', totalOrders.toString(), Icons.shopping_bag_outlined, const Color(0xFF8B5CF6)),
        _buildStatCard('Active Products', activeProducts.toString(), Icons.inventory_2_outlined, const Color(0xFFF59E0B)),
        _buildStatCard('Customers', totalCustomers.toString(), Icons.people_outline, const Color(0xFF10B981)),
        _buildStatCard('Income', '₹$deliveryIncome', Icons.account_balance_wallet_outlined, const Color(0xFFEC4899)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
        ],
      ),
    ).animate().scale(delay: 100.ms);
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        TextButton(onPressed: () {}, child: const Text('View All')),
      ],
    );
  }

  Widget _buildPerformanceChart() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart_rounded, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Text('Sales Performance Chart', style: TextStyle(color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }

  Widget _buildPrepList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _buildPrepItem('15 Litre Water Bottle', '12 units remaining'),
          const Divider(),
          _buildPrepItem('20 Litre Can', '5 units remaining'),
          const Divider(),
          _buildPrepItem('Drinking Water 5L', '20 units remaining'),
        ],
      ),
    );
  }

  Widget _buildPrepItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.water_drop, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
