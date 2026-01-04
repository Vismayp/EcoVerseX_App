import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../widgets/neo/neo_scaffold.dart';
import '../../widgets/neo/neo_card.dart';
import '../../widgets/neo/neo_primary_button.dart';
import '../../providers/user_provider.dart';

class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  final _projectNameController = TextEditingController();
  final _treesController = TextEditingController();
  final _typeController = TextEditingController();
  double? _totalKg;
  double? _credits;
  double? _revenueMin;
  double? _revenueMax;
  bool _isSubmitting = false;

  void _calculate() {
    final trees = int.tryParse(_treesController.text) ?? 0;
    if (trees <= 0) return;

    const co2PerTree = 22.0;
    const priceMin = 500.0;
    const priceMax = 2500.0;

    setState(() {
      _totalKg = trees * co2PerTree;
      _credits = _totalKg! / 1000;
      _revenueMin = _credits! * priceMin;
      _revenueMax = _credits! * priceMax;
    });
  }

  Future<void> _submitForVerification() async {
    if (_totalKg == null) return;

    setState(() => _isSubmitting = true);
    try {
      final apiService = ref.read(apiServiceProvider);
      await apiService.saveCarbonCalculation(
        projectName: _projectNameController.text.isEmpty
            ? 'My Carbon Project'
            : _projectNameController.text,
        treeSpecies:
            _typeController.text.isEmpty ? 'Mixed' : _typeController.text,
        treeCount: int.parse(_treesController.text),
        annualSeq: _totalKg! / 1000, // in tonnes
        totalSeq: (_totalKg! / 1000) * 20, // 20 year estimate
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Calculation submitted for verification!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NeoScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Carbon Calculator',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _GuideSection(),
            const SizedBox(height: 24),
            NeoCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _projectNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Project Name (e.g. My Backyard)',
                        labelStyle: TextStyle(color: AppColors.onDarkMuted),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _typeController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Tree Type',
                        labelStyle: TextStyle(color: AppColors.onDarkMuted),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _treesController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Number of Trees',
                        labelStyle: TextStyle(color: AppColors.onDarkMuted),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    NeoPrimaryButton(
                      label: 'Calculate',
                      onPressed: _calculate,
                    ),
                  ],
                ),
              ),
            ),
            if (_totalKg != null) ...[
              const SizedBox(height: 24),
              const Text('Results',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              NeoCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ResultRow(
                          label: 'Annual Sequestration',
                          value: '${_totalKg!.toStringAsFixed(0)} kg CO₂'),
                      _ResultRow(
                          label: 'Potential Credits',
                          value: '${_credits!.toStringAsFixed(2)} credits'),
                      const Divider(color: Colors.white24, height: 32),
                      Text('Estimated Revenue',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        '₹${_revenueMin!.toStringAsFixed(0)} - ₹${_revenueMax!.toStringAsFixed(0)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      NeoPrimaryButton(
                        label: _isSubmitting
                            ? 'Submitting...'
                            : 'Submit for Verification',
                        onPressed:
                            _isSubmitting ? null : _submitForVerification,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;

  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _GuideSection extends StatelessWidget {
  const _GuideSection();

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  'How to use the Calculator',
                  style: AppTheme.headlineSmall.copyWith(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _GuideStep(
              number: '1',
              text:
                  'Enter a name for your project (e.g., "My Backyard Garden").',
            ),
            _GuideStep(
              number: '2',
              text: 'Specify the type of trees you have planted.',
            ),
            _GuideStep(
              number: '3',
              text: 'Enter the total number of trees in your project.',
            ),
            _GuideStep(
              number: '4',
              text:
                  'Click "Calculate" to see your estimated CO₂ sequestration.',
            ),
            _GuideStep(
              number: '5',
              text: 'Submit for verification to start earning Carbon Credits!',
            ),
            const Divider(color: Colors.white10, height: 24),
            const Text(
              'Note: Calculations are based on average sequestration rates (approx. 22kg CO₂/year per mature tree) and projected over 20 years.',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideStep extends StatelessWidget {
  final String number;
  final String text;

  const _GuideStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
