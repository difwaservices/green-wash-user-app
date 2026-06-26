import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../routes/app_routes.dart';
import '../../../data/services/db_service.dart';
import '../../../data/models/product_model.dart';
import 'home_page.dart';

class ExclusivePackagesPage extends StatelessWidget {
  const ExclusivePackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF0A4429)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Exclusive Packages',
            style: TextStyle(
              color: Color(0xFF0A4429),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Premium Care,\nPackaged for You.',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0A4429),
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Save money and get the best care for your garments with our curated bundles.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 16,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: const [
                  ProductCard(
                    imagePath: 'assets/images/pkg_monthly_wash.png',
                    title: 'Monthly Wash Plan',
                    price: 'â‚¹1499',
                    oldPrice: 'â‚¹1999',
                    discount: 'SAVE 25%',
                  ),
                  ProductCard(
                    imagePath: 'assets/images/pkg_dry_clean.png',
                    title: 'Premium Dry Clean',
                    price: 'â‚¹499',
                    oldPrice: 'â‚¹699',
                    discount: 'SAVE 15%',
                  ),
                  ProductCard(
                    imagePath: 'assets/images/pkg_family_bundle.png',
                    title: 'Family Bundle Plus',
                    price: 'â‚¹2999',
                    oldPrice: 'â‚¹3999',
                    discount: 'SAVE 30%',
                  ),
                  ProductCard(
                    imagePath: 'assets/images/pkg_shoe_care.png',
                    title: 'Shoe Care Bundle',
                    price: 'â‚¹899',
                    oldPrice: 'â‚¹1299',
                    discount: 'SAVE 35%',
                  ),
                  ProductCard(
                    imagePath: 'assets/images/pkg_weekly_refresh.png',
                    title: 'Weekly Refresh',
                    price: 'â‚¹599',
                    oldPrice: 'â‚¹799',
                    discount: 'SAVE 25%',
                  ),
                  ProductCard(
                    imagePath: 'assets/images/pkg_ironing.png',
                    title: 'Ironing Special',
                    price: 'â‚¹299',
                    oldPrice: 'â‚¹499',
                    discount: 'SAVE 40%',
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
