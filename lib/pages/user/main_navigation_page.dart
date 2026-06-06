import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import 'booking_page.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'service_detail_page.dart';
import 'status_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int currentIndex = 0;
  final OrderModel order = OrderModel.initial();

  void _openService([String? serviceName]) {
    setState(() {
      if (serviceName != null) {
        order.serviceName = serviceName;
      }
      currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        onOpenService: () => _openService(),
        onSelectService: (serviceName) => _openService(serviceName),
        onOpenBooking: () => setState(() => currentIndex = 2),
      ),
      ServiceDetailPage(
        order: order,
        onContinue: () => setState(() => currentIndex = 2),
      ),
      BookingPage(
        order: order,
        onConfirmed: () => setState(() => currentIndex = 3),
      ),
      StatusPage(order: order),
      const ProfilePage(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[currentIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => setState(() => currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.cleaning_services_outlined),
            selectedIcon: Icon(Icons.cleaning_services),
            label: 'Layanan',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Pesan',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping),
            label: 'Status',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
