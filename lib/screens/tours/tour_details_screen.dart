import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/theme.dart';
import '../../data/models.dart';
import '../../providers/user_provider.dart';
import '../../widgets/eco_coin_icon.dart';
import '../../widgets/neo/neo_primary_button.dart';
import '../../widgets/neo/neo_scaffold.dart';

class TourDetailsScreen extends ConsumerWidget {
  final Tour tour;

  const TourDetailsScreen({super.key, required this.tour});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);

    return NeoScaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: tour.imageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  color: AppColors.cardDark,
                  child: const Icon(Icons.image_not_supported, size: 50),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          tour.title,
                          style: AppTheme.headlineMedium.copyWith(
                            color: AppColors.onDark,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                size: 18, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              tour.rating.toStringAsFixed(1),
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppColors.onDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 18, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        tour.location,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppColors.onDarkMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.timer,
                          size: 18, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        tour.duration ?? '1 Day',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppColors.onDarkMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'About this Tour',
                    style: AppTheme.headlineSmall.copyWith(
                      color: AppColors.onDark,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (tour.details != null && tour.details!.isNotEmpty)
                    HtmlWidget(
                      tour.details!,
                      textStyle: AppTheme.bodyMedium.copyWith(
                        color: AppColors.onDarkMuted,
                        height: 1.5,
                      ),
                    )
                  else
                    Text(
                      tour.description,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppColors.onDarkMuted,
                        height: 1.5,
                      ),
                    ),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.backgroundDark,
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.05)),
          ),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style:
                      AppTheme.caption.copyWith(color: AppColors.onDarkMuted),
                ),
                Row(
                  children: [
                    const EcoCoinIcon(size: 20),
                    const SizedBox(width: 6),
                    Text(
                      tour.price.toString(),
                      style: AppTheme.headlineSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: NeoPrimaryButton(
                label: 'Book Now',
                onPressed: () {
                  // Implement booking logic or show confirmation
                  _showBookingConfirmation(context, ref, tour);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingConfirmation(
      BuildContext context, WidgetRef ref, Tour tour) {
    final TextEditingController mobileController = TextEditingController();
    int tickets = 1;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Confirm Booking',
                style: AppTheme.headlineSmall.copyWith(color: AppColors.onDark),
              ),
              const SizedBox(height: 16),
              Text(
                'Book your spot for ${tour.title}. Price is per person.',
                textAlign: TextAlign.center,
                style:
                    AppTheme.bodyMedium.copyWith(color: AppColors.onDarkMuted),
              ),
              const SizedBox(height: 24),
              // Ticket Counter
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Number of People',
                      style: AppTheme.bodyLarge.copyWith(color: Colors.white),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: tickets > 1
                              ? () => setModalState(() => tickets--)
                              : null,
                          icon: const Icon(Icons.remove_circle_outline,
                              color: AppColors.primary),
                        ),
                        Text(
                          tickets.toString(),
                          style: AppTheme.headlineSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => setModalState(() => tickets++),
                          icon: const Icon(Icons.add_circle_outline,
                              color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Total Cost
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Cost',
                    style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
                  ),
                  Row(
                    children: [
                      const EcoCoinIcon(size: 18),
                      const SizedBox(width: 6),
                      Text(
                        (tour.price * tickets).toString(),
                        style: AppTheme.headlineSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Mobile Number',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  prefixIcon: const Icon(Icons.phone, color: AppColors.primary),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: NeoPrimaryButton(
                      label: 'Confirm',
                      onPressed: () async {
                        final mobile = mobileController.text.trim();
                        if (mobile.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please enter your mobile number')),
                          );
                          return;
                        }

                        Navigator.pop(context);
                        try {
                          final apiService = ref.read(apiServiceProvider);
                          await apiService.bookTour(
                              tour.id, tickets, DateTime.now(), mobile);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Booking successful!'),
                                  backgroundColor: Colors.green),
                            );
                            ref.invalidate(userProfileProvider);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            String errorMessage = 'Booking failed';
                            if (e is DioException) {
                              errorMessage =
                                  e.response?.data['error'] ?? e.message;
                            }

                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
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
