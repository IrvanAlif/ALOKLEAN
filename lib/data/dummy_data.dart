import '../models/chat_message_model.dart';
import '../models/cleaner_model.dart';
import '../models/order_model.dart';
import '../models/service_model.dart';
import '../models/user_model.dart';

final List<ServiceModel> services = [
  ServiceModel(
    name: 'Kos / Kamar',
    description: 'Cocok untuk mahasiswa kos atau apartemen kecil',
    price: 80000,
    iconName: 'bed',
  ),
  ServiceModel(
    name: 'Rumah Sedang',
    description: 'Untuk 2–3 ruangan utama',
    price: 100000,
    iconName: 'home',
  ),
  ServiceModel(
    name: 'Rumah Besar',
    description: 'Untuk rumah keluarga dan pembersihan menyeluruh',
    price: 120000,
    iconName: 'apartment',
  ),
];

final CleanerModel sampleCleaner = CleanerModel(
  name: 'Irvan Mandala Putra',
  id: 'CL-25001',
  phone: '0813-9876-5432',
  experience: '3 tahun',
  rating: 4.8,
  verified: true,
  imagePath: 'assets/images/irvan.jpg',
  email: 'irvan@aloklean.com',
  password: 'cleaner123',
  role: 'cleaner',
);

// List cleaner untuk login
final List<CleanerModel> cleaners = [
  sampleCleaner,
  CleanerModel(
    name: 'Siti Aminah',
    id: 'CL-25002',
    phone: '0812-3456-7890',
    experience: '2 tahun',
    rating: 4.6,
    verified: true,
    imagePath: 'assets/images/siti.jpg',
    email: 'siti@aloklean.com',
    password: 'cleaner456',
    role: 'cleaner',
  ),
];

// Data user dummy untuk demo
final List<UserModel> dummyUsers = [
  UserModel(
    id: '1',
    name: 'Nadia Putri',
    email: 'nadia@example.com',
    phone: '081234567890',
    password: '123456',
    role: 'user',
  ),
];

// Session global
UserModel? currentUser;
CleanerModel? currentCleaner;

// Helper untuk cek role yang sedang login
String? get currentRole {
  if (currentUser != null) return currentUser!.role;
  if (currentCleaner != null) return currentCleaner!.role;
  return null;
}

// Daftar semua pesanan (global, bisa diakses user & cleaner)
List<OrderModel> allOrders = [
  OrderModel(
    id: 'ORD-1001',
    serviceName: 'Kos / Kamar',
    packageType: 'Reguler',
    homeSize: 'Kos / Kamar',
    duration: '2 Jam',
    paymentMethod: 'Cash',
    customerName: 'Nadia Putri',
    address: 'Jl. Merpati No. 12, Bandung',
    notes: 'Tolong fokus kamar tidur dan kamar mandi.',
    date: '2026-06-08',
    time: '09:00',
    status: 'Menunggu',
    totalPrice: 90000,
    agreed: true,
    userRating: 0,
    userReview: '',
    cleanerId: null,
    cleanerName: null,
  ),
  OrderModel(
    id: 'ORD-1002',
    serviceName: 'Rumah Sedang',
    packageType: 'Deep Cleaning',
    homeSize: 'Rumah Sedang',
    duration: '3 Jam',
    paymentMethod: 'Transfer Bank',
    customerName: 'Rizky Hadi',
    address: 'Jl. Melati 45, Jakarta',
    notes: 'Pastikan area dapur dan ruang tamu bersih.',
    date: '2026-06-09',
    time: '13:00',
    status: 'Negosiasi',
    totalPrice: 120000,
    agreed: true,
    userRating: 0,
    userReview: '',
    cleanerId: sampleCleaner.id,
    cleanerName: sampleCleaner.name,
  ),
  OrderModel(
    id: 'ORD-1003',
    serviceName: 'Rumah Besar',
    packageType: 'Paket Lengkap',
    homeSize: 'Rumah Besar',
    duration: '4 Jam',
    paymentMethod: 'E-Wallet',
    customerName: 'Dewi Lestari',
    address: 'Komplek Griya Asri, Bogor',
    notes: 'Termasuk cuci jendela dan pel lantai.',
    date: '2026-06-10',
    time: '08:30',
    status: 'Diterima',
    totalPrice: 150000,
    agreed: true,
    userRating: 0,
    userReview: '',
    cleanerId: sampleCleaner.id,
    cleanerName: sampleCleaner.name,
  ),
];

// Helper untuk mendapatkan pesanan user yang sedang login
List<OrderModel> get myUserOrders {
  if (currentUser == null) return [];
  return allOrders.where((o) => o.customerName == currentUser!.name).toList();
}

// Helper untuk mendapatkan pesanan yang menunggu cleaner
List<OrderModel> get pendingOrders {
  return allOrders.where((o) => o.status == 'Menunggu').toList();
}

// Helper untuk mendapatkan pesanan yang diterima cleaner
List<OrderModel> get cleanerActiveOrders {
  if (currentCleaner == null) return [];
  return allOrders.where((o) => o.cleanerId == currentCleaner!.id).toList();
}

// Daftar semua pesan chat (global)
List<ChatMessageModel> allMessages = [];
