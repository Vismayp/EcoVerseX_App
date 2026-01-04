import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../providers/shop_provider.dart';
import '../../widgets/neo/neo_card.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(userOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Order History',
          style: AppTheme.headlineSmall.copyWith(
            color: AppColors.onDark,
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined,
                      size: 64, color: AppColors.onDarkMuted.withOpacity(0.2)),
                  const SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: AppTheme.bodyLarge
                        .copyWith(color: AppColors.onDarkMuted),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final order = orders[index];
              return _OrderCard(order: order);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const _OrderCard({required this.order});

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'SHIPPED':
        return Colors.blue;
      case 'DELIVERED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = order['item'] ?? {};
    final date = DateTime.parse(order['createdAt']);
    final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(date);

    return NeoCard(
      borderRadius: BorderRadius.circular(18),
      padding: const EdgeInsets.all(16),
      color: AppColors.cardDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(order['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getStatusColor(order['status']).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  order['status'].toString().toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(order['status']),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                formattedDate,
                style: AppTheme.caption.copyWith(color: AppColors.faintOnDark),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: item['imageURL'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item['imageURL'],
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.shopping_bag,
                        color: AppColors.onDarkMuted),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] ?? 'Unknown Item',
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppColors.onDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quantity: ${order['quantity']}',
                      style: AppTheme.caption
                          .copyWith(color: AppColors.onDarkMuted),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.eco, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        '${order['totalCost']}',
                        style: AppTheme.bodyLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          if (order['mobileNumber'] != null) ...[
            const SizedBox(height: 12),
            const Divider(color: Colors.white10),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 14, color: AppColors.onDarkMuted),
                const SizedBox(width: 8),
                Text(
                  'Contact: ${order['mobileNumber']}',
                  style:
                      AppTheme.caption.copyWith(color: AppColors.onDarkMuted),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
