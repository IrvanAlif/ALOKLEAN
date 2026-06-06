import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/order_model.dart';
import '../chat/chat_page.dart';
import '../../widgets/info_row.dart';
import '../../widgets/timeline_step.dart';

class StatusPage extends StatefulWidget {
  final OrderModel order;

  const StatusPage({super.key, required this.order});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    // AMBIL SEMUA PESANAN USER YANG SEDANG LOGIN dari allOrders
    final userOrders =
        allOrders.where((o) => o.customerName == currentUser?.name).toList()
          ..sort((a, b) {
            // Urutkan dari yang terbaru (bisa pakai timestamp kalau ada)
            // Sekarang pakai status: yang belum selesai di atas
            if (a.status == 'Selesai' && b.status != 'Selesai') return 1;
            if (a.status != 'Selesai' && b.status == 'Selesai') return -1;
            return 0;
          });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Pesanan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: userOrders.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userOrders.length,
              itemBuilder: (context, index) {
                final order = userOrders[index];
                return _OrderCard(
                  order: order,
                  onTap: () => _showOrderDetail(order),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Belum ada pesanan',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Buat pesanan di menu Pesan',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  void _showOrderDetail(OrderModel order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _OrderDetailPage(order: order)),
    );
  }
}

// Card untuk setiap pesanan di list
class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const _OrderCard({required this.order, required this.onTap});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange;
      case 'Diterima':
        return Colors.green;
      case 'Diproses':
        return Colors.blue;
      case 'Dalam Perjalanan':
        return Colors.purple;
      case 'Selesai':
        return Colors.green.shade700;
      case 'Ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Menunggu':
        return Icons.schedule;
      case 'Diterima':
        return Icons.check_circle;
      case 'Diproses':
        return Icons.cleaning_services;
      case 'Dalam Perjalanan':
        return Icons.local_shipping;
      case 'Selesai':
        return Icons.done_all;
      case 'Ditolak':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Status & Tanggal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        order.status,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(order.status),
                          size: 14,
                          color: _getStatusColor(order.status),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order.status,
                          style: TextStyle(
                            color: _getStatusColor(order.status),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    order.date,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Layanan
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFDCEAFF),
                    child: Icon(
                      Icons.cleaning_services,
                      size: 20,
                      color: const Color(0xFF0B4FA8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.serviceName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${order.homeSize} • ${order.duration}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Harga
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD54F).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Harga Penawaran:',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF705D00),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      formatRupiah(order.totalPrice),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Color(0xFF0B4FA8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Alamat & Cleaner
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      order.address,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (order.cleanerName != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(
                      'Cleaner: ${order.cleanerName}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 8),

              // Lihat detail
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Lihat Detail',
                    style: TextStyle(
                      color: const Color(0xFF0B4FA8),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Color(0xFF0B4FA8),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman Detail Pesanan (ketika card diklik)
class _OrderDetailPage extends StatefulWidget {
  final OrderModel order;

  const _OrderDetailPage({required this.order});

  @override
  State<_OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<_OrderDetailPage> {
  late int tempRating;
  late String tempReview;

  @override
  void initState() {
    super.initState();
    tempRating = widget.order.userRating;
    tempReview = widget.order.userReview;
  }

  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(order: widget.order, isCleaner: false),
      ),
    ).then((_) => setState(() {}));
  }

  void _showReviewDialog() {
    int dialogRating = tempRating == 0 ? 5 : tempRating;
    final TextEditingController reviewController = TextEditingController(
      text: tempReview,
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Beri Rating & Ulasan'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Rating',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final star = index + 1;
                        return IconButton(
                          onPressed: () {
                            setDialogState(() {
                              dialogRating = star;
                            });
                          },
                          icon: Icon(
                            Icons.star,
                            color: star <= dialogRating
                                ? Colors.amber
                                : Colors.grey.shade300,
                            size: 32,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: reviewController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Tulis ulasan',
                        hintText:
                            'Contoh: Petugas datang tepat waktu dan hasilnya bersih.',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      tempRating = dialogRating;
                      tempReview = reviewController.text.trim();
                      widget.order.userRating = dialogRating;
                      widget.order.userReview = reviewController.text.trim();
                    });
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Rating dan ulasan berhasil disimpan.'),
                      ),
                    );
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange;
      case 'Diterima':
        return Colors.green;
      case 'Diproses':
        return Colors.blue;
      case 'Dalam Perjalanan':
        return Colors.purple;
      case 'Selesai':
        return Colors.green.shade700;
      case 'Ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Status Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _getStatusColor(order.status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _getStatusColor(order.status),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cleaning_services,
                  size: 40,
                  color: _getStatusColor(order.status),
                ),
                const SizedBox(height: 12),
                Text(
                  order.status,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: _getStatusColor(order.status),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${order.date} • ${order.time}',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Harga
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD54F).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFFFD54F), width: 2),
            ),
            child: Column(
              children: [
                const Text(
                  'Harga Penawaran Anda',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF705D00),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formatRupiah(order.totalPrice),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0B4FA8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Timeline
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status Layanan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                TimelineStep(
                  title: 'Pesanan Dibuat',
                  subtitle: 'Menunggu cleaner menerima',
                  done: true,
                  isLast: false,
                ),
                TimelineStep(
                  title: 'Diterima Cleaner',
                  subtitle: order.cleanerName != null
                      ? 'Diterima oleh ${order.cleanerName}'
                      : 'Cleaner menerima penawaran',
                  done:
                      order.status == 'Diterima' ||
                      order.status == 'Diproses' ||
                      order.status == 'Dalam Perjalanan' ||
                      order.status == 'Selesai',
                  current: order.status == 'Diterima',
                  isLast: false,
                ),
                TimelineStep(
                  title: 'Diproses',
                  subtitle: 'Petugas mulai disiapkan',
                  done:
                      order.status == 'Diproses' ||
                      order.status == 'Dalam Perjalanan' ||
                      order.status == 'Selesai',
                  current: order.status == 'Diproses',
                  isLast: false,
                ),
                TimelineStep(
                  title: 'Dalam Perjalanan',
                  subtitle: 'Petugas menuju lokasi',
                  done:
                      order.status == 'Dalam Perjalanan' ||
                      order.status == 'Selesai',
                  current: order.status == 'Dalam Perjalanan',
                  isLast: false,
                ),
                TimelineStep(
                  title: 'Selesai',
                  subtitle: 'Layanan selesai',
                  done: order.status == 'Selesai',
                  current: order.status == 'Selesai',
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Info Cleaner
          if (order.cleanerName != null) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cleaner',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFDCEAFF),
                      child: Icon(Icons.person, color: Color(0xFF0B4FA8)),
                    ),
                    title: Text(order.cleanerName!),
                    subtitle: Text('ID: ${order.cleanerId}'),
                    trailing: const Chip(
                      label: Text('Verified'),
                      avatar: Icon(
                        Icons.verified,
                        size: 18,
                        color: Color(0xFF0B4FA8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Detail
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detail Pemesanan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                InfoRow(label: 'Layanan', value: order.serviceName),
                const SizedBox(height: 10),
                InfoRow(label: 'Paket', value: order.packageType),
                const SizedBox(height: 10),
                InfoRow(label: 'Hunian', value: order.homeSize),
                const SizedBox(height: 10),
                InfoRow(label: 'Durasi', value: order.duration),
                const SizedBox(height: 10),
                InfoRow(label: 'Alamat', value: order.address),
                const SizedBox(height: 10),
                InfoRow(label: 'Pembayaran', value: order.paymentMethod),
                const SizedBox(height: 10),
                InfoRow(
                  label: 'Catatan',
                  value: order.notes.isEmpty ? '-' : order.notes,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (order.status == 'Negosiasi' || order.status == 'Diterima') ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _openChat,
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Chat Cleaner'),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Rating (kalau selesai)
          if (order.status == 'Selesai') ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rating & Ulasan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  if (tempRating > 0) ...[
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star,
                          size: 24,
                          color: index < tempRating
                              ? Colors.amber
                              : Colors.grey.shade300,
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    if (tempReview.isNotEmpty)
                      Text(tempReview, style: const TextStyle(height: 1.5)),
                  ] else ...[
                    const Text(
                      'Belum ada rating',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _showReviewDialog,
                      icon: const Icon(Icons.star_outline),
                      label: Text(
                        tempRating > 0 ? 'Edit Ulasan' : 'Beri Rating',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
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
