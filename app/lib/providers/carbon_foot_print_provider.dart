import 'package:app/services/carbon_calculator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/carbon_foot_print.dart';
import '../services/firestore_service.dart';

// FirestoreService Provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Stream provider for fetching all user's carbon footprint records
final carbonFootprintProvider = StreamProvider.family<List<CarbonFootprint>, String>((ref, userId) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUserFootprints(userId);
});

// Total all-time carbon footprint
final totalCarbonFootprintProvider = FutureProvider.family<double, String>((ref, userId) async {
  final service = ref.watch(firestoreServiceProvider);
  return service.getTotalUserCarbonFootprint(userId);
});

// Total carbon footprint for today
final dailyCarbonFootprintProvider = FutureProvider.family<double, String>((ref, userId) async {
  final service = ref.watch(firestoreServiceProvider);
  return service.getTotalUserCarbonFootprint(userId, frequency: 'daily');
});


// Total carbon footprint for this week
final weeklyCarbonFootprintProvider = FutureProvider.family<double, String>((ref, userId) async {
  final service = ref.watch(firestoreServiceProvider);
  return service.getTotalUserCarbonFootprint(userId, frequency: 'weekly');
});

// Total carbon footprint for this month
final monthlyCarbonFootprintProvider = FutureProvider.family<double, String>((ref, userId) async {
  final service = ref.watch(firestoreServiceProvider);
  return service.getTotalUserCarbonFootprint(userId, frequency: 'monthly');
});

// Add these to your existing provider file

// Provider for calculation methods
final carbonCalculatorProvider = Provider<CarbonCalculator>((ref) {
  return CarbonCalculator();
});

// Provider for transportation calculation
final transportEmissionProvider = Provider.family<double, TransportParams>((ref, params) {
  final calculator = ref.read(carbonCalculatorProvider);
  return calculator.calculateTransportEmission(params.mode, params.distanceKm);
});

// Provider for energy calculation
final energyEmissionProvider = Provider.family<double, EnergyParams>((ref, params) {
  final calculator = ref.read(carbonCalculatorProvider);
  return calculator.calculateEnergyEmission(params.electricityKwh, params.gasTherms);
});

// Provider for food calculation
final foodEmissionProvider = Provider.family<double, FoodParams>((ref, params) {
  final calculator = ref.read(carbonCalculatorProvider);
  return calculator.calculateFoodEmission(params.meat, params.dairy, params.vegetables);
});

// Parameter classes
class TransportParams {
  final String mode;
  final double distanceKm;

  TransportParams(this.mode, this.distanceKm);
}

class EnergyParams {
  final double electricityKwh;
  final double gasTherms;

  EnergyParams(this.electricityKwh, this.gasTherms);
}

class FoodParams {
  final double meat;
  final double dairy;
  final double vegetables;

  FoodParams(this.meat, this.dairy, this.vegetables);
}