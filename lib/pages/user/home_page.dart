import 'package:flutter/material.dart';
import '../../widgets/benefit_card.dart';
import '../../widgets/service_card.dart';
import '../../widgets/tag_chip.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onOpenService;
  final ValueChanged<String> onSelectService;
  final VoidCallback onOpenBooking;

  const HomePage({
    super.key,
    required this.onOpenService,
    required this.onSelectService,
    required this.onOpenBooking,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 80,
          title: const Text(
            'ALOKLEAN',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundColor: Color(0xFFDCEAFF),
                child: Icon(Icons.cleaning_services, color: Color(0xFF0B4FA8)),
              ),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0B4FA8), Color(0xFF083A78)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF0B4FA8,
                            ).withValues(alpha: 0.18),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: isWide
                          ? Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFD54F),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                        child: const Text(
                                          'Praktis • Aman • Terpercaya',
                                          style: TextStyle(
                                            color: Color(0xFF705D00),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Pesan cleaning service\nlebih cepat dan mudah.',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w900,
                                          height: 1.15,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Cocok untuk mahasiswa kos, pekerja sibuk, dan keluarga yang butuh hunian tetap bersih tanpa repot.',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          height: 1.6,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          FilledButton(
                                            style: FilledButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFFFD54F,
                                              ),
                                              foregroundColor: const Color(
                                                0xFF705D00,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 22,
                                                    vertical: 16,
                                                  ),
                                            ),
                                            onPressed: onOpenBooking,
                                            child: const Text('Pesan Sekarang'),
                                          ),
                                          const SizedBox(width: 12),
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              side: const BorderSide(
                                                color: Colors.white54,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 22,
                                                    vertical: 16,
                                                  ),
                                            ),
                                            onPressed: onOpenService,
                                            child: const Text('Lihat Layanan'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 220,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.10,
                                      ),
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.15,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 82,
                                          height: 82,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.18,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.cleaning_services,
                                            size: 42,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'Booking Mudah',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          child: Text(
                                            'Pilih layanan, isi data, dan pantau status pesanan langsung dari aplikasi.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white70,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD54F),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Text(
                                    'Praktis • Aman • Terpercaya',
                                    style: TextStyle(
                                      color: Color(0xFF705D00),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Pesan cleaning service\nlebih cepat dan mudah.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    height: 1.15,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Cocok untuk mahasiswa kos, pekerja sibuk, dan keluarga yang butuh hunian tetap bersih.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFD54F),
                                    foregroundColor: const Color(0xFF705D00),
                                  ),
                                  onPressed: onOpenBooking,
                                  child: const Text('Pesan Sekarang'),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Kenapa pilih ALOKLEAN?',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    isWide
                        ? const Row(
                            children: [
                              Expanded(
                                child: BenefitCard(
                                  icon: Icons.schedule,
                                  title: 'Hemat Waktu',
                                  subtitle:
                                      'Cocok untuk pengguna dengan aktivitas padat.',
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: BenefitCard(
                                  icon: Icons.verified_user,
                                  title: 'Petugas Verified',
                                  subtitle:
                                      'Identitas petugas jelas dan lebih aman.',
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: BenefitCard(
                                  icon: Icons.payments,
                                  title: 'Harga Transparan',
                                  subtitle:
                                      'Harga layanan jelas sesuai kebutuhan.',
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: BenefitCard(
                                  icon: Icons.repeat,
                                  title: 'Fleksibel',
                                  subtitle:
                                      'Bisa sekali panggil atau sesuai jadwal.',
                                ),
                              ),
                            ],
                          )
                        : const Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: BenefitCard(
                                      icon: Icons.schedule,
                                      title: 'Hemat Waktu',
                                      subtitle:
                                          'Cocok untuk pengguna dengan aktivitas padat.',
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: BenefitCard(
                                      icon: Icons.verified_user,
                                      title: 'Petugas Verified',
                                      subtitle:
                                          'Identitas petugas jelas dan lebih aman.',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: BenefitCard(
                                      icon: Icons.payments,
                                      title: 'Harga Transparan',
                                      subtitle:
                                          'Harga layanan jelas sesuai kebutuhan.',
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: BenefitCard(
                                      icon: Icons.repeat,
                                      title: 'Fleksibel',
                                      subtitle:
                                          'Bisa sekali panggil atau sesuai jadwal.',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kategori Layanan',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextButton(
                          onPressed: onOpenService,
                          child: const Text('Lihat detail'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: isWide ? 2 : 1,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isWide ? 3.2 : 2.6,
                      children: [
                        ServiceCard(
                          icon: Icons.bed_outlined,
                          title: 'Kos / Kamar',
                          subtitle: 'Untuk kamar pribadi dan studio',
                          onTap: () => onSelectService('Kos / Kamar'),
                        ),
                        ServiceCard(
                          icon: Icons.home_outlined,
                          title: 'Rumah Sedang',
                          subtitle: '2–3 area utama',
                          onTap: () => onSelectService('Rumah Sedang'),
                        ),
                        ServiceCard(
                          icon: Icons.apartment_outlined,
                          title: 'Rumah Besar',
                          subtitle: 'Pembersihan menyeluruh',
                          onTap: () => onSelectService('Rumah Besar'),
                        ),
                        ServiceCard(
                          icon: Icons.sanitizer_outlined,
                          title: 'Disinfeksi',
                          subtitle: 'Hunian lebih higienis',
                          onTap: () => onSelectService('Disinfeksi'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Layanan Unggulan',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: isWide
                          ? Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 28,
                                            backgroundColor: Color(0xFFDCEAFF),
                                            child: Icon(
                                              Icons.cleaning_services,
                                              color: Color(0xFF0B4FA8),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Deep Cleaning ALOKLEAN',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  'Pembersihan hunian yang praktis dan terpercaya',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      const Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          TagChip(label: 'Harga Transparan'),
                                          TagChip(label: 'Cleaner Verified'),
                                          TagChip(label: 'Fast Booking'),
                                          TagChip(label: 'Pengerjaan Rapi'),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Layanan unggulan kami dirancang untuk membantu pengguna menjaga kebersihan kamar, rumah, maupun area hunian lain dengan proses pemesanan yang cepat dan aman.',
                                        style: TextStyle(height: 1.6),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAF1FF),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Mulai dari',
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        const Text(
                                          'Rp 80.000',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF0B4FA8),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'Pilihan ideal untuk mahasiswa kos, pekerja, dan keluarga.',
                                          style: TextStyle(height: 1.5),
                                        ),
                                        const SizedBox(height: 16),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: FilledButton(
                                            style: FilledButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFFFD54F,
                                              ),
                                              foregroundColor: const Color(
                                                0xFF705D00,
                                              ),
                                            ),
                                            onPressed: onOpenBooking,
                                            child: const Text(
                                              'Booking Sekarang',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Color(0xFFDCEAFF),
                                      child: Icon(
                                        Icons.cleaning_services,
                                        color: Color(0xFF0B4FA8),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Deep Cleaning ALOKLEAN',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Pembersihan hunian yang praktis dan terpercaya',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                const Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    TagChip(label: 'Harga Transparan'),
                                    TagChip(label: 'Cleaner Verified'),
                                    TagChip(label: 'Fast Booking'),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  'Layanan unggulan kami dirancang untuk membantu pengguna menjaga kebersihan hunian dengan proses pemesanan yang cepat dan aman.',
                                  style: TextStyle(height: 1.6),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    const Text(
                                      'Mulai dari ',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    Text(
                                      'Rp 80.000',
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            color: const Color(0xFF0B4FA8),
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: const Color(0xFFFFD54F),
                                      foregroundColor: const Color(0xFF705D00),
                                    ),
                                    onPressed: onOpenBooking,
                                    child: const Text('Booking Sekarang'),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
