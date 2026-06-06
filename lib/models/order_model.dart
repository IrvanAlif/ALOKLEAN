class OrderModel {
  String id;
  String serviceName;
  String packageType;
  String homeSize;
  String duration;
  String paymentMethod;
  String customerName;
  String address;
  String notes;
  String date;
  String time;
  String status; // 'Menunggu', 'Negosiasi', 'Diterima', 'Diproses', 'Dalam Perjalanan', 'Selesai', 'Ditolak'
  int totalPrice; // Harga yang ditentukan user
  bool agreed;
  int userRating;
  String userReview;
  String? cleanerId; // ID cleaner yang menerima
  String? cleanerName; // Nama cleaner yang menerima

  OrderModel({
    required this.id,
    required this.serviceName,
    required this.packageType,
    required this.homeSize,
    required this.duration,
    required this.paymentMethod,
    required this.customerName,
    required this.address,
    required this.notes,
    required this.date,
    required this.time,
    required this.status,
    required this.totalPrice,
    required this.agreed,
    required this.userRating,
    required this.userReview,
    this.cleanerId,
    this.cleanerName,
  });

  factory OrderModel.initial() {
    return OrderModel(
      id: '',
      serviceName: 'Deep Cleaning',
      packageType: 'Sekali Panggil',
      homeSize: 'Kos / Kamar',
      duration: '2 Jam',
      paymentMethod: 'Cash',
      customerName: '',
      address: '',
      notes: '',
      date: '',
      time: '',
      status: 'Belum dipesan',
      totalPrice: 0, // User tentukan sendiri
      agreed: false,
      userRating: 0,
      userReview: '',
      cleanerId: null,
      cleanerName: null,
    );
  }
}
