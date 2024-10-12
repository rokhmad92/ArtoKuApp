// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'laporan_bloc.dart';

@immutable
sealed class LaporanEvent {}

class GetLaporanEvent extends LaporanEvent {}

class GetWhereDateLaporanEvent extends LaporanEvent {
  final DateTime startDate;
  final DateTime endDate;

  GetWhereDateLaporanEvent({
    required this.startDate,
    required this.endDate,
  });
}

class CreateLaporanEvent extends LaporanEvent {
  final LaporanModel model;

  CreateLaporanEvent({required this.model});
}

class UpdateDateLaporanEvent extends LaporanEvent {
  final String uid;
  final int nominal;
  final String? keterangan;
  final DateTime date;

  UpdateDateLaporanEvent({
    required this.uid,
    required this.nominal,
    this.keterangan,
    required this.date,
  });
}

class DestroyDateLaporanEvent extends LaporanEvent {
  final String uid;
  final DateTime date;

  DestroyDateLaporanEvent({
    required this.uid,
    required this.date,
  });
}

class SumMonthNominalEvent extends LaporanEvent {
  final DateTime? date;
  final DateTime? startDate;
  final DateTime? endDate;

  SumMonthNominalEvent({
    this.date,
    this.startDate,
    this.endDate,
  });
}

class PieChartEvent extends LaporanEvent {
  final DateTime? startDate;
  final DateTime endDate;

  PieChartEvent({
    this.startDate,
    required this.endDate,
  });
}
