part of 'laporan_bloc.dart';

@immutable
sealed class LaporanState {}

final class LaporanInitial extends LaporanState {}

class LaporanLoading extends LaporanState {}

class LaporanLoaded extends LaporanState {
  final List<LaporanModel> dataLaporan;

  LaporanLoaded({required this.dataLaporan});
}

class LaporanSuccess extends LaporanState {
  final String message;

  LaporanSuccess({required this.message});
}

class LaporanError extends LaporanState {
  final String message;

  LaporanError({required this.message});
}

class LaporanSumCalculationState extends LaporanState {
  final int pemasukan;
  final int pengeluaran;
  final List<LaporanModel> data;

  LaporanSumCalculationState(
      {required this.pemasukan, required this.pengeluaran, required this.data});
}

class LaporanPieChartState extends LaporanState {
  final List dataChart;

  LaporanPieChartState({required this.dataChart});
}
