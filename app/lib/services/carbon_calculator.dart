class CarbonCalculator {
   double calculateTransportEmission(String mode, double distanceKm) {
    switch (mode) {
      case 'car':
        return distanceKm * 0.21; // kg CO2/km
      case 'bus':
        return distanceKm * 0.105;
      case 'bike':
        return 0.0;
      default:
        return 0.0;
    }
  }

   double calculateEnergyEmission(double electricityKwh, double gasTherms) {
    return (electricityKwh * 0.475) + (gasTherms * 5.3);
  }

  double calculateFoodEmission(double meat, double dairy, double vegetables) {
    return (meat * 27.0) + (dairy * 13.6) + (vegetables * 2.0); // per kg
  }
}
