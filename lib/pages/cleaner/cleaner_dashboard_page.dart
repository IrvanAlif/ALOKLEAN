import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';
import '../../models/cleaner_model.dart';
import '../../models/order_model.dart';
import '../auth/login_page.dart';
import '../chat/chat_page.dart';

class CleanerDashboardPage extends StatefulWidget {
  const CleanerDashboardPage({super.key});

  @override
  State<CleanerDashboardPage> createState() => _CleanerDashboardPageState();
}

class _CleanerDashboardPageState extends State<CleanerDashboardPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Refresh setiap kali halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  void _logout(BuildContext context) {
    currentCleaner = null;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _acceptOrder(OrderModel order) {
    setState(() {
      order.status = 'Diterima';
      order.cleanerId = currentCleaner!.id;
      order.cleanerName = currentCleaner!.name;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pesanan diterima!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _rejectOrder(OrderModel order) {
    setState(() {
      order.status = 'Ditolak';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pesanan ditolak'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _updateOrderStatus(OrderModel order, String newStatus) {
    setState(() {
      order.status = newStatus;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Status diperbarui: $newStatus')));
  }

  void _openChat(OrderModel order) {
    if (order.status == 'Menunggu') {
      setState(() {
        order.status = 'Negosiasi';
        order.cleanerId = currentCleaner!.id;
        order.cleanerName = currentCleaner!.name;
      });
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(order: order, isCleaner: true),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final cleaner = currentCleaner!;

    // FORCE REFRESH - ambil data terbaru dari allOrders
    final waitingOrders = allOrders
        .where((o) => o.status == 'Menunggu')
        .toList();
    final myOrders = allOrders
        .where(
          (o) =>
              o.cleanerId == currentCleaner!.id &&
              (o.status == 'Negosiasi' ||
                  o.status == 'Diterima' ||
                  o.status == 'Diproses' ||
                  o.status == 'Dalam Perjalanan'),
        )
        .toList();

    final pages = [
      // Halaman Pesanan Menunggu
      _buildWaitingOrdersPage(waitingOrders),
      // Halaman Pesanan Saya
      _buildMyOrdersPage(myOrders),
      // Halaman Profil
      _buildProfilePage(cleaner),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Cleaner'),
        actions: [
          // Tombol refresh manual
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Data diperbarui')));
            },
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Badge(child: Icon(Icons.notifications_outlined)),
            selectedIcon: Icon(Icons.notifications),
            label: 'Baru',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Pesanan Saya',
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

  Widget _buildWaitingOrdersPage(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Tidak ada pesanan baru',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pull down untuk refresh',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => setState(() {}),
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _OrderCard(
            order: order,
            isWaiting: true,
            onAccept: () => _acceptOrder(order),
            onReject: () => _rejectOrder(order),
            onChat: () => _openChat(order),
            onUpdateStatus: (status) => _updateOrderStatus(order, status),
          );
        },
      ),
    );
  }

  Widget _buildMyOrdersPage(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada pesanan diterima',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Terima pesanan dari tab "Baru"',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _OrderCard(
          order: order,
          isWaiting: false,
          onAccept: () {},
          onReject: () {},
          onChat: () => _openChat(order),
          onUpdateStatus: (status) => _updateOrderStatus(order, status),
        );
      },
    );
  }

  Widget _buildProfilePage(CleanerModel cleaner) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0B4FA8), Color(0xFF083A78)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: const Icon(
                  Icons.cleaning_services,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                cleaner.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ID: ${cleaner.id}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatChip(Icons.star, '${cleaner.rating}', 'Rating'),
                  const SizedBox(width: 12),
                  _buildStatChip(Icons.work, cleaner.experience, 'Pengalaman'),
                  const SizedBox(width: 12),
                  _buildStatChip(
                    Icons.verified,
                    cleaner.verified ? 'Verified' : 'Unverified',
                    'Status',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Tombol Logout di Profil Cleaner
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFFFEBEE),
              child: Icon(Icons.logout, color: Colors.red),
            ),
            title: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.red),
            ),
            subtitle: const Text('Keluar dari aplikasi'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _logout(context),
          ),
        ),

        const SizedBox(height: 24),
        _buildInfoTile(Icons.phone, 'Telepon', cleaner.phone),
        _buildInfoTile(Icons.email, 'Email', cleaner.email),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFDCEAFF),
        child: Icon(icon, color: const Color(0xFF0B4FA8)),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF111827),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isWaiting;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onChat;
  final Function(String) onUpdateStatus;

  const _OrderCard({
    required this.order,
    required this.isWaiting,
    required this.onAccept,
    required this.onReject,
    required this.onChat,
    required this.onUpdateStatus,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange;
      case 'Negosiasi':
        return Colors.orange.shade700;
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.date} • ${order.time}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: _getStatusColor(order.status),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
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
                  ),
                ),
                Text(
                  'Rp ${order.totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Color(0xFF0B4FA8),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 24),

          Row(
            children: [
              const Icon(Icons.home_work, size: 16, color: Color(0xFF0B4FA8)),
              const SizedBox(width: 8),
              Text(
                '${order.homeSize} • ${order.duration}',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Color(0xFF0B4FA8)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order.address,
                  style: const TextStyle(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.payment, size: 16, color: Color(0xFF0B4FA8)),
              const SizedBox(width: 8),
              Text(order.paymentMethod, style: const TextStyle(fontSize: 13)),
            ],
          ),

          const SizedBox(height: 16),
          if (isWaiting && order.status == 'Menunggu')
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                          foregroundColor: Colors.red,
                        ),
                        onPressed: onReject,
                        child: const Text('Tolak'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0B4FA8),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: onAccept,
                        child: const Text('Terima'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.chat_outlined),
                    label: const Text('Chat & Nego'),
                    onPressed: onChat,
                  ),
                ),
              ],
            )
          else if (!isWaiting &&
              order.status != 'Selesai' &&
              order.status != 'Ditolak')
            order.status == 'Negosiasi'
                ? SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.chat_outlined),
                      label: const Text('Lanjut Chat Nego'),
                      onPressed: onChat,
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0B4FA8),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        String nextStatus;
                        switch (order.status) {
                          case 'Diterima':
                            nextStatus = 'Diproses';
                            break;
                          case 'Diproses':
                            nextStatus = 'Dalam Perjalanan';
                            break;
                          case 'Dalam Perjalanan':
                            nextStatus = 'Selesai';
                            break;
                          default:
                            nextStatus = 'Diproses';
                        }
                        onUpdateStatus(nextStatus);
                      },
                      child: Text(
                        order.status == 'Diterima'
                            ? 'Mulai Proses'
                            : order.status == 'Diproses'
                            ? 'Mulai Perjalanan'
                            : 'Tandai Selesai',
                      ),
                    ),
                  ),
        ],
      ),
    );
  }
}
