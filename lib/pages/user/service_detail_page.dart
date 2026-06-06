import 'package:flutter/material.dart';
import '../../models/order_model.dart';

class ServiceDetailPage extends StatefulWidget {
  final OrderModel order;
  final VoidCallback onContinue;

  const ServiceDetailPage({
    super.key,
    required this.order,
    required this.onContinue,
  });

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  late String selectedServiceName;
  late String selectedPackage;
  late String selectedHomeSize;
  late String selectedDuration;
  late int totalPrice;

  @override
  void initState() {
    super.initState();
    selectedServiceName = widget.order.serviceName.isNotEmpty
        ? widget.order.serviceName
        : 'Deep Cleaning';
    selectedPackage = widget.order.packageType;
    selectedHomeSize = widget.order.homeSize;
    selectedDuration = widget.order.duration;
    totalPrice = calculatePrice();
  }

  int calculatePrice() {
    int base;
    switch (selectedHomeSize) {
      case 'Rumah Sedang':
        base = 100000;
        break;
      case 'Rumah Besar':
        base = 120000;
        break;
      default:
        base = 80000;
    }

    if (selectedDuration == '4 Jam') {
      return base + 20000;
    }
    if (selectedDuration == '6 Jam') {
      return base + 40000;
    }
    return base;
  }

  void updateOrder() {
    widget.order.serviceName = selectedServiceName;
    widget.order.packageType = selectedPackage;
    widget.order.homeSize = selectedHomeSize;
    widget.order.duration = selectedDuration;
    widget.order.totalPrice = totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    totalPrice = calculatePrice();

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Layanan')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: SizedBox(
            height: 56,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFFD54F),
                foregroundColor: const Color(0xFF705D00),
              ),
              onPressed: () {
                updateOrder();
                widget.onContinue();
              },
              child: const Text('Lanjut ke Pemesanan'),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [Color(0xFF0B4FA8), Color(0xFF083A78)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedServiceName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Layanan kebersihan hunian untuk membantu pengguna yang sibuk menjaga kebersihan rumah atau kamar.',
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Jenis Pemesanan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: [
              ChoiceChip(
                label: const Text('Sekali Panggil'),
                selected: selectedPackage == 'Sekali Panggil',
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      selectedPackage = 'Sekali Panggil';
                    });
                  }
                },
              ),
              ChoiceChip(
                label: const Text('Langganan'),
                selected: selectedPackage == 'Langganan',
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      selectedPackage = 'Langganan';
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Ukuran Hunian',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          _optionTile('Kos / Kamar', 'Cocok untuk kos atau apartemen kecil'),
          const SizedBox(height: 10),
          _optionTile('Rumah Sedang', 'Untuk 2–3 ruangan utama'),
          const SizedBox(height: 10),
          _optionTile(
            'Rumah Besar',
            'Untuk rumah keluarga dan area lebih luas',
          ),
          const SizedBox(height: 24),
          const Text(
            'Durasi Layanan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: ['2 Jam', '4 Jam', '6 Jam']
                .map(
                  (item) => ChoiceChip(
                    label: Text(item),
                    selected: selectedDuration == item,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedDuration = item;
                        });
                      }
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ringkasan',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0B4FA8),
                  ),
                ),
                const SizedBox(height: 8),
                Text('Paket: $selectedPackage'),
                Text('Hunian: $selectedHomeSize'),
                Text('Durasi: $selectedDuration'),
                const SizedBox(height: 12),
                Text(
                  'Estimasi total: ${formatRupiah(totalPrice)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionTile(String title, String subtitle) {
    final selected = selectedHomeSize == title;

    return InkWell(
      onTap: () {
        setState(() {
          selectedHomeSize = title;
        });
      },
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF1FF) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? const Color(0xFF0B4FA8) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFDCEAFF),
              child: Icon(Icons.home_work_outlined, color: Color(0xFF0B4FA8)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected ? const Color(0xFF0B4FA8) : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

String formatRupiah(int number) {
  final text = number.toString();
  final buffer = StringBuffer();
  int count = 0;

  for (int i = text.length - 1; i >= 0; i--) {
    buffer.write(text[i]);
    count++;
    if (count == 3 && i != 0) {
      buffer.write('.');
      count = 0;
    }
  }

  return 'Rp ${buffer.toString().split('').reversed.join()}';
}
