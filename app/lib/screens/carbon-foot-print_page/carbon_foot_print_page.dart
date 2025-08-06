import 'package:app/models/carbon_foot_print.dart';
import 'package:app/providers/carbon_foot_print_provider.dart';
import 'package:app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CarbonFootprintPage extends ConsumerWidget {
  const CarbonFootprintPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(uidProvider);
    final dailyFootprintAsync = ref.watch(dailyCarbonFootprintProvider(userId ?? ''));
    final weeklyFootprintAsync = ref.watch(weeklyCarbonFootprintProvider(userId ?? ''));
    final monthlyFootprintAsync = ref.watch(monthlyCarbonFootprintProvider(userId ?? ''));
    final footprintsAsync = ref.watch(carbonFootprintProvider(userId ?? ''));

    // Calculate progress value (assuming 10kg is max for demo)
    final progressValue = dailyFootprintAsync.maybeWhen(
      data: (value) => value / 10.0, // Adjust max value as needed
      orElse: () => 0.0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9F2),
      appBar: AppBar(
        title: const Text(
          'Carbon Footprint Tracker',
          style: TextStyle(color: Color(0xFF333333)),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF333333)),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildProgressCard(dailyFootprintAsync, progressValue),
            const SizedBox(height: 16),
            _buildSectionTitle('Input Today\'s Activity'),
            const SizedBox(height: 8),
            _buildInputButtons(context, ref),
            const SizedBox(height: 16),
            _buildSectionTitle('Weekly & Monthly Summary'),
            const SizedBox(height: 8),
            _buildSummaryCards(weeklyFootprintAsync, monthlyFootprintAsync),
            const SizedBox(height: 16),
            _buildSectionTitle('Recent Activities'),
            const SizedBox(height: 8),
            _buildRecentActivities(footprintsAsync),
            const SizedBox(height: 16),
            _buildSectionTitle('Insights & Recommendations'),
            const SizedBox(height: 8),
            _buildTipsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(AsyncValue<double> dailyFootprint, double progressValue) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Carbon Usage',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progressValue.clamp(0.0, 1.0),
              color: const Color(0xFF5DB075),
              backgroundColor: const Color(0xFFE0E0E0),
              minHeight: 10,
            ),
            const SizedBox(height: 12),
            dailyFootprint.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
              data: (value) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${value.toStringAsFixed(1)} kg CO₂',
                    style: const TextStyle(color: Color(0xFF757575)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement activity tracking
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Track Activity'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF333333),
      ),
    );
  }

  Widget _buildInputButtons(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _activityButton('Transportation', Icons.directions_car, () {
          _showTransportationDialog(context, ref);
        }),
        _activityButton('Energy Usage', Icons.flash_on, () {
          _showEnergyDialog(context, ref);
        }),
        _activityButton('Food Consumption', Icons.restaurant, () {
          _showFoodDialog(context, ref);
        }),
      ],
    );
  }

  Widget _activityButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: const Color(0xFF2E7D32)),
      label: Text(
        label,
        style: const TextStyle(color: Color(0xFF2E7D32)),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFF5DB075)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildSummaryCards(AsyncValue<double> weeklyFootprint, AsyncValue<double> monthlyFootprint) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Weekly',
            weeklyFootprint.maybeWhen(
              data: (value) => value,
              orElse: () => 0.0,
            ),
            const Color(0xFF5DB075),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Monthly',
            monthlyFootprint.maybeWhen(
              data: (value) => value,
              orElse: () => 0.0,
            ),
            const Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String period, double value, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color.withValues(alpha: 0.1),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              period,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${value.toStringAsFixed(1)} kg',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities(AsyncValue<List<CarbonFootprint>> footprints) {
    return footprints.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error: $error'),
      data: (footprints) {
        if (footprints.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No activities recorded yet'),
            ),
          );
        }

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.white,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: footprints.take(3).map((footprint) {
                return ListTile(
                  leading: const Icon(Icons.eco, color: Color(0xFF5DB075)),
                  title: Text('${footprint.total.toStringAsFixed(1)} kg CO₂'),
                  subtitle: Text(DateFormat('MMM d, y').format(footprint.date)),
                  trailing: Text(
                    footprint.period,
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTipsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.lightbulb, color: Color(0xFFFDD835)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Tip: Use public transport or carpool to reduce emissions.',
                    style: TextStyle(color: Color(0xFF333333)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showTransportationDialog(BuildContext context, WidgetRef ref) {
    final userId = ref.read(uidProvider);
    if (userId == null) return;

    final TextEditingController distanceController = TextEditingController();
    String selectedMode = 'car';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Transportation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: distanceController,
                decoration: const InputDecoration(
                  labelText: 'Distance (km)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedMode,
                items: const [
                  DropdownMenuItem(value: 'car', child: Text('Car')),
                  DropdownMenuItem(value: 'bus', child: Text('Bus')),
                  DropdownMenuItem(value: 'bike', child: Text('Bike')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    selectedMode = value;
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Transport Mode',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final distance = double.tryParse(distanceController.text) ?? 0.0;
                final emission = ref.read(transportEmissionProvider(
                    TransportParams(selectedMode, distance)
                ));


                final footprint = CarbonFootprint(
                  userId: userId,
                  transport: emission,
                  energy: 0,
                  food: 0,
                  date: DateTime.now(),
                  period: 'daily',
                );

                try {
                  await ref.read(firestoreServiceProvider).saveCarbonFootprint(footprint);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEnergyDialog(BuildContext context, WidgetRef ref) {
    final userId = ref.read(uidProvider);
    if (userId == null) return;

    final TextEditingController electricityController = TextEditingController();
    final TextEditingController gasController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Energy Usage'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: electricityController,
                decoration: const InputDecoration(
                  labelText: 'Electricity (kWh)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: gasController,
                decoration: const InputDecoration(
                  labelText: 'Gas (therms)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final electricity = double.tryParse(electricityController.text) ?? 0.0;
                final gas = double.tryParse(gasController.text) ?? 0.0;
                final emission = ref.read(energyEmissionProvider(EnergyParams(
                  electricity,
                  gas,)));

                final footprint = CarbonFootprint(
                  userId: userId,
                  transport: 0,
                  energy: emission,
                  food: 0,
                  date: DateTime.now(),
                  period: 'daily',
                );

                try {
                  await ref.read(firestoreServiceProvider).saveCarbonFootprint(footprint);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showFoodDialog(BuildContext context, WidgetRef ref) {
    final userId = ref.read(uidProvider);
    if (userId == null) return;

    final TextEditingController meatController = TextEditingController();
    final TextEditingController dairyController = TextEditingController();
    final TextEditingController vegetablesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Food Consumption'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: meatController,
                decoration: const InputDecoration(
                  labelText: 'Meat (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dairyController,
                decoration: const InputDecoration(
                  labelText: 'Dairy (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: vegetablesController,
                decoration: const InputDecoration(
                  labelText: 'Vegetables (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final meat = double.tryParse(meatController.text) ?? 0.0;
                final dairy = double.tryParse(dairyController.text) ?? 0.0;
                final vegetables = double.tryParse(vegetablesController.text) ?? 0.0;
                final emission = ref.read(foodEmissionProvider(FoodParams(meat, dairy, vegetables))
                );

                final footprint = CarbonFootprint(
                  userId: userId,
                  transport: 0,
                  energy: 0,
                  food: emission,
                  date: DateTime.now(),
                  period: 'daily',
                );

                try {
                  await ref.read(firestoreServiceProvider).saveCarbonFootprint(footprint);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}