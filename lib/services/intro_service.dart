class Intro {
  final String title;
  final String image;
  final String text;

  Intro({
    required this.title,
    required this.image,
    required this.text,
  });
}

List<Intro> contents = [
  Intro(
    title: 'Pantau Keuangan Anda Secara Real-Time',
    image: 'assets/intro1.png',
    text: 'Lihat kesehatan finansial Anda kapan saja. Pantau pengeluaran dan pemasukan dengan cepat dan akurat.',
  ),
  Intro(
    title: 'Pencatatan Transaksi Mudah Dan Cepat',
    image: 'assets/intro2.png',
    text: 'Mudah mencatat transaksi dan melihat laporan keuangan Anda. Pastikan tidak ada detail yang terlewat.',
  ),
  Intro(
    title: 'Lihat Laporan Keuangan Anda Secara Instan',
    image: 'assets/intro3.png',
    text: 'Mudah mencatat transaksi dan melihat laporan keuangan Anda. Pastikan tidak ada detail yang terlewat.',
  ),
];
