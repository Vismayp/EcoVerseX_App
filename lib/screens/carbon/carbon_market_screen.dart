import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class CarbonMarketScreen extends StatefulWidget {
  const CarbonMarketScreen({super.key});

  @override
  State<CarbonMarketScreen> createState() => _CarbonMarketScreenState();
}

class _CarbonMarketScreenState extends State<CarbonMarketScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _treeCountController = TextEditingController();
  double _calculatedCarbon = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _treeCountController.dispose();
    super.dispose();
  }

  void _calculateCarbon() {
    final int count = int.tryParse(_treeCountController.text) ?? 0;
    setState(() {
      _calculatedCarbon = count * 22.0; // 22kg per tree
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Market'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Calculator'),
            Tab(text: 'Marketplace'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCalculatorTab(),
          _buildMarketplaceTab(),
        ],
      ),
    );
  }

  Widget _buildCalculatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calculate Your Impact',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          const Text('Estimate carbon sequestration based on trees planted.'),
          const SizedBox(height: 32),
          CustomTextField(
            label: 'Number of Mango Trees',
            hint: 'e.g., 10',
            keyboardType: TextInputType.number,
            controller: _treeCountController,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Calculate',
              onPressed: _calculateCarbon,
            ),
          ),
          const SizedBox(height: 32),
          if (_calculatedCarbon > 0)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Estimated Sequestration',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_calculatedCarbon.toStringAsFixed(1)} kg CO2/year',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'This is equivalent to driving a car for:',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    '${(_calculatedCarbon / 0.2).toStringAsFixed(0)} km', // Approx 0.2kg/km
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMarketplaceTab() {
    final projects = MockData.carbonProjects;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(project.location,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(project.description),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${project.pricePerTon}/ton',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Buy Offset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
