import 'package:app/widgets/ChallengeBannerCard.dart';
import 'package:app/widgets/build_card.dart';
import 'package:app/widgets/carbon_tracker_card.dart';
import 'package:app/widgets/certifications_card.dart';
import 'package:app/widgets/community_form_card.dart';
import 'package:app/widgets/dashboard.dart';
import 'package:app/widgets/eco_products-card.dart';
import 'package:app/widgets/eco_travel_card.dart';
import 'package:app/widgets/educational_content_card.dart';
import 'package:app/widgets/energy_tip_card.dart';
import 'package:app/widgets/home_header.dart';
import 'package:app/widgets/recipe_card.dart';
import 'package:app/widgets/waste_tracker_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F9F2),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image(image: AssetImage
              ('images/sustainable-living-guide-logo.png'),height: 60,
                width: 60,
                ),
            const Text('Sustainable Living Guide')
          ],
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF2D5A4A),
      ),
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(),
              const SizedBox(height: 30),
              CarbonTrackerCard(),
              const SizedBox(height: 20),
              EcoProductsCard(),
              const SizedBox(height: 20),
              ChallengeBannerCard(),
              const SizedBox(height: 20),
              CertificationsCard(),
              const SizedBox(height: 20),
              WasteTrackerCard(),
              const SizedBox(height: 20),
              RecipeCard(),
              const SizedBox(height: 20),
              EnergyTipCard(),
              const SizedBox(height: 20),
              EcoTravelCard(),
              const SizedBox(height: 20),
              CommunityFormCard(),
              const SizedBox(height: 20),
              Dashboard(),
              const SizedBox(height: 20),
              EducationalContentCard(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF008080),
        child: const Icon(Icons.eco),
      ),
    );
  }
}