import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/theme.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/eco_coin_icon.dart';
import '../../widgets/neo/neo_card.dart';
import '../../widgets/neo/neo_chip.dart';
import '../../widgets/neo/neo_primary_button.dart';
import '../../widgets/neo/neo_search_field.dart';

class ActivityLogSheet extends StatefulWidget {
  const ActivityLogSheet({super.key});

  @override
  State<ActivityLogSheet> createState() => _ActivityLogSheetState();
}

class _ActivityLogSheetState extends State<ActivityLogSheet> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  int _stepIndex = 0;
  String _query = '';
  String _selectedChip = 'Transport';
  _ActionSuggestion? _selectedAction;

  Future<Position?> _tryGetLivePosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 6),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          border: Border.all(color: Colors.white.withOpacity(0.10)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.camera_alt, color: AppColors.primary),
                  title: Text('Take Photo',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppColors.onDark)),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.photo_library, color: AppColors.primary),
                  title: Text('Choose from Gallery',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppColors.onDark)),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;
    final suggestions = _suggestions
        .where((s) => s.category == _selectedChip)
        .where((s) => _query.isEmpty || s.title.toLowerCase().contains(_query))
        .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.55,
      maxChildSize: 0.98,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundDark,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_stepIndex == 0) {
                          Navigator.pop(context);
                          return;
                        }
                        setState(() => _stepIndex -= 1);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.onDark,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Log Activity',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: AppColors.onDark),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.20),
                        ),
                      ),
                      child: Row(
                        children: [
                          const EcoCoinIcon(size: 18),
                          const SizedBox(width: 6),
                          Text(
                            '${user.walletBalance}',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _stepIndex == 0
                    ? ListView(
                        controller: controller,
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                        children: [
                          NeoSearchField(
                            hintText: 'Search actions (e.g., vegan, bike)',
                            trailingIcon: Icons.add,
                            onTrailingTap: () {},
                            onChanged: (v) =>
                                setState(() => _query = v.trim().toLowerCase()),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 46,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                const SizedBox(width: 2),
                                NeoChip(
                                  label: 'Transport',
                                  icon: Icons.directions_bike,
                                  selected: _selectedChip == 'Transport',
                                  onTap: () => setState(
                                      () => _selectedChip = 'Transport'),
                                ),
                                const SizedBox(width: 10),
                                NeoChip(
                                  label: 'Food',
                                  icon: Icons.restaurant,
                                  selected: _selectedChip == 'Food',
                                  onTap: () =>
                                      setState(() => _selectedChip = 'Food'),
                                ),
                                const SizedBox(width: 10),
                                NeoChip(
                                  label: 'Energy',
                                  icon: Icons.bolt,
                                  selected: _selectedChip == 'Energy',
                                  onTap: () =>
                                      setState(() => _selectedChip = 'Energy'),
                                ),
                                const SizedBox(width: 10),
                                NeoChip(
                                  label: 'Waste',
                                  icon: Icons.recycling,
                                  selected: _selectedChip == 'Waste',
                                  onTap: () =>
                                      setState(() => _selectedChip = 'Waste'),
                                ),
                                const SizedBox(width: 10),
                                NeoChip(
                                  label: 'Shopping',
                                  icon: Icons.shopping_bag,
                                  selected: _selectedChip == 'Shopping',
                                  onTap: () => setState(
                                      () => _selectedChip = 'Shopping'),
                                ),
                                const SizedBox(width: 2),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Suggestions',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(color: AppColors.onDark),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'View all',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...suggestions.map((s) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(22),
                                  onTap: () {
                                    setState(() {
                                      _selectedAction = s;
                                      _stepIndex = 1;
                                    });
                                  },
                                  child: NeoCard(
                                    borderRadius: BorderRadius.circular(22),
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary
                                                .withOpacity(0.10),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Icon(
                                            s.icon,
                                            color: AppColors.primary,
                                            size: 30,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                s.title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      color: AppColors.onDark,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                              ),
                                              const SizedBox(height: 6),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.06),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  s.subtitle,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall
                                                      ?.copyWith(
                                                        color: AppColors
                                                            .mutedOnDark,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: s.isPrimaryReward
                                                ? AppColors.primary
                                                : Colors.white
                                                    .withOpacity(0.10),
                                            borderRadius:
                                                BorderRadius.circular(999),
                                          ),
                                          child: Text(
                                            '+ ${s.reward}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge
                                                ?.copyWith(
                                                  color: s.isPrimaryReward
                                                      ? AppColors.backgroundDark
                                                      : AppColors.onDark,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      )
                    : _buildPhotoStep(controller),
              ),
              PositionedBottomCta(
                child: NeoPrimaryButton(
                  label: _stepIndex == 0 ? 'Continue' : 'Submit for Review',
                  icon: _stepIndex == 0 ? Icons.arrow_forward : Icons.check,
                  onPressed: () async {
                    if (_stepIndex == 0) {
                      if (_selectedAction == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Select an action to continue.'),
                          ),
                        );
                        return;
                      }
                      setState(() => _stepIndex = 1);
                      return;
                    }

                    final action = _selectedAction;
                    final position = await _tryGetLivePosition();
                    if (action != null) {
                      MockData.recentActivities.insert(
                        0,
                        Activity(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: action.title,
                          category: action.category,
                          coinReward: action.reward,
                          date: DateTime.now(),
                          status: 'Pending',
                          latitude: position?.latitude,
                          longitude: position?.longitude,
                        ),
                      );
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Submitted for review.'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhotoStep(ScrollController controller) {
    final action = _selectedAction;

    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      children: [
        Row(
          children: [
            Text(
              'Step 2/2',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: AppColors.mutedOnDark),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (action != null)
          NeoCard(
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(22),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(action.icon, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.onDark,
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        action.subtitle,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: AppColors.mutedOnDark),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '+ ${action.reward}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.backgroundDark,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 14),
        Text(
          'Upload Photo Evidence',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: AppColors.onDark),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: _showImageSourceDialog,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.18),
                width: 2,
              ),
            ),
            child: _selectedImage == null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_a_photo,
                            size: 40, color: AppColors.mutedOnDark),
                        const SizedBox(height: 10),
                        Text(
                          'Tap to upload a photo',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: AppColors.mutedOnDark),
                        ),
                      ],
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      children: [
                        Image.file(
                          File(_selectedImage!.path),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: InkWell(
                            onTap: () => setState(() => _selectedImage = null),
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.55),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.16)),
                              ),
                              child: const Icon(Icons.close,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 14),
        NeoCard(
          borderRadius: BorderRadius.circular(18),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.hourglass_bottom,
                    color: Colors.orange, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Pending Verification: your reward will be credited after review.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.mutedOnDark, height: 1.3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PositionedBottomCta extends StatelessWidget {
  const PositionedBottomCta({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.backgroundDark.withOpacity(0.85),
            AppColors.backgroundDark,
          ],
        ),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}

class _ActionSuggestion {
  const _ActionSuggestion({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.reward,
    required this.icon,
    this.isPrimaryReward = false,
  });

  final String category;
  final String title;
  final String subtitle;
  final int reward;
  final IconData icon;
  final bool isPrimaryReward;
}

const List<_ActionSuggestion> _suggestions = [
  _ActionSuggestion(
    category: 'Transport',
    title: 'Cycle Commute',
    subtitle: '1.2kg CO₂ saved',
    reward: 20,
    icon: Icons.pedal_bike,
    isPrimaryReward: true,
  ),
  _ActionSuggestion(
    category: 'Transport',
    title: 'Public Bus',
    subtitle: '0.8kg CO₂ saved',
    reward: 10,
    icon: Icons.directions_bus,
  ),
  _ActionSuggestion(
    category: 'Transport',
    title: 'EV Carpool',
    subtitle: '1.0kg CO₂ saved',
    reward: 15,
    icon: Icons.electric_car,
  ),
  _ActionSuggestion(
    category: 'Transport',
    title: 'Walked',
    subtitle: '0.5kg CO₂ saved',
    reward: 25,
    icon: Icons.directions_walk,
  ),
  _ActionSuggestion(
    category: 'Food',
    title: 'Vegan Meal',
    subtitle: '1.3kg CO₂ saved',
    reward: 18,
    icon: Icons.eco,
    isPrimaryReward: true,
  ),
  _ActionSuggestion(
    category: 'Energy',
    title: 'Switched to LED',
    subtitle: '0.6kg CO₂ saved',
    reward: 12,
    icon: Icons.lightbulb,
  ),
  _ActionSuggestion(
    category: 'Waste',
    title: 'Recycled Plastic',
    subtitle: '0.4kg CO₂ saved',
    reward: 8,
    icon: Icons.recycling,
  ),
  _ActionSuggestion(
    category: 'Shopping',
    title: 'Bought Refill Pack',
    subtitle: '0.7kg CO₂ saved',
    reward: 14,
    icon: Icons.shopping_bag,
  ),
];
