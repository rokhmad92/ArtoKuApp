class LaporanModel {
  String? uid;
  String? userId;
  String? keterangan;
  int nominal;
  String? categoryTipe;
  String categoryName;
  DateTime tanggal;
  DateTime createdAt;

  LaporanModel({
    this.uid,
    this.userId,
    this.keterangan,
    this.categoryTipe,
    required this.nominal,
    required this.categoryName,
    required this.tanggal,
    required this.createdAt,
  });
}
