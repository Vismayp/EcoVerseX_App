import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/theme.dart';
import '../../data/models.dart';
import '../../providers/user_provider.dart';
import '../../providers/missions_provider.dart';
import '../../widgets/neo/neo_primary_button.dart';

class MissionLogSheet extends ConsumerStatefulWidget {
  final Mission mission;

  const MissionLogSheet({super.key, required this.mission});

  @override
  ConsumerState<MissionLogSheet> createState() => _MissionLogSheetState();
}

class _MissionLogSheetState extends ConsumerState<MissionLogSheet> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isSubmitting = false;

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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Image Source',
              style: AppTheme.headlineSmall.copyWith(color: AppColors.onDark),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SourceOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                _SourceOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_detailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide mission details')),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a photo proof')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ref.read(apiServiceProvider).logMissionProgress(
            widget.mission.id,
            {
              'description': _detailsController.text,
              'message': _messageController.text,
            },
            imagePath: _selectedImage?.path,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mission log submitted for approval!'),
            backgroundColor: AppColors.primary,
          ),
        );
        ref.invalidate(missionsProvider);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit log: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Log Mission Progress',
              style: AppTheme.displayLarge.copyWith(
                color: AppColors.onDark,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.mission.title,
              style: AppTheme.bodyLarge.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'Mission Details',
              style: AppTheme.headlineSmall.copyWith(color: AppColors.onDark),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _detailsController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'What did you do for this mission?',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Message to Admin',
              style: AppTheme.headlineSmall.copyWith(color: AppColors.onDark),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Any additional notes...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Proof (Image)',
              style: AppTheme.headlineSmall.copyWith(color: AppColors.onDark),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    style: BorderStyle.solid,
                  ),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined,
                              size: 40, color: Colors.white.withOpacity(0.3)),
                          const SizedBox(height: 12),
                          Text(
                            'Add Photo Proof',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 32),
            NeoPrimaryButton(
              label: _isSubmitting ? 'Submitting...' : 'Submit for Approval',
              onPressed: _isSubmitting ? null : () => _submit(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.onDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
