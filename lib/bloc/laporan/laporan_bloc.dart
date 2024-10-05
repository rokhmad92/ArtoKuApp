import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:artoku/models/laporan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'laporan_event.dart';
part 'laporan_state.dart';

class LaporanBloc extends Bloc<LaporanEvent, LaporanState> {
  final db = FirebaseFirestore.instance;
  final Uuid uuid = const Uuid();

  LaporanBloc() : super(LaporanInitial()) {
    on<CreateLaporanEvent>((event, emit) async {
      emit(LaporanLoading());

      try {
        final String userId = await getIdUser();
        final String generateUid = uuid.v4();
        late String categoryTipe;
        late String categoryName;

        // validasi
        if (event.model.nominal <= 0 ||
            event.model.categoryName.isEmpty ||
            event.model.categoryName == '') {
          return emit(LaporanError(message: 'Harap mengisi form yang wajib'));
        }

        QuerySnapshot snapshot = await db
            .collection("category")
            .where('name', isEqualTo: event.model.categoryName)
            .where('userId', isEqualTo: userId)
            .get();

        if (snapshot.docs.isNotEmpty) {
          categoryTipe = snapshot.docs.first['category'];
          categoryName = snapshot.docs.first['name'];
        } else {
          return emit(LaporanError(message: 'Category tidak ditemukan'));
        }

        await db.collection("laporan").doc(generateUid).set({
          "uid": generateUid,
          "userId": userId,
          "keterangan": event.model.keterangan,
          "nominal": event.model.nominal,
          "categoryTipe": categoryTipe,
          "categoryName": categoryName,
          "tanggal": event.model.tanggal,
          "createdAt": event.model.createdAt,
        });

        emit(LaporanSuccess(message: 'Berhasil input laporan'));
      } catch (e) {
        emit(LaporanError(message: e.toString()));
      }
    });

    // with date
    on<GetWhereDateLaporanEvent>(
      (event, emit) async {
        emit(LaporanLoading());

        final DateTime startDay = DateTime(event.startDate.year,
            event.startDate.month, event.startDate.day, 0, 0, 0, 0);
        final DateTime endDay = DateTime(event.endDate.year,
            event.endDate.month, event.endDate.day, 23, 59, 59, 999);

        try {
          await _getWhereDateLaporan(startDay, endDay, emit);
        } catch (e) {
          emit(LaporanError(message: e.toString()));
        }
      },
    );

    on<UpdateDateLaporanEvent>(
      (event, emit) async {
        emit(LaporanLoading());

        final DateTime startDay = DateTime(
            event.date.year, event.date.month, event.date.day, 0, 0, 0, 0);
        final DateTime endDay = DateTime(
            event.date.year, event.date.month, event.date.day, 23, 59, 59, 999);

        final getData = db.collection("laporan").doc(event.uid);
        final docSnapshot = await getData.get();

        if (!docSnapshot.exists) {
          emit(LaporanError(message: 'Laporan not found.'));
          return;
        }

        try {
          await getData.update(
              {"keterangan": event.keterangan, "nominal": event.nominal});
          emit(LaporanSuccess(message: 'Berhasil update laporan'));
          await _getWhereDateLaporan(startDay, endDay, emit);
        } catch (e) {
          emit(LaporanError(message: e.toString()));
        }
      },
    );

    on<DestroyDateLaporanEvent>(
      (event, emit) async {
        emit(LaporanLoading());

        final DateTime startDay = DateTime(
            event.date.year, event.date.month, event.date.day, 0, 0, 0, 0);
        final DateTime endDay = DateTime(
            event.date.year, event.date.month, event.date.day, 23, 59, 59, 999);

        try {
          db.collection("laporan").doc(event.uid).delete();

          emit(LaporanSuccess(message: 'Berhasil hapus data'));
          await _getWhereDateLaporan(startDay, endDay, emit);
        } catch (e) {
          emit(LaporanError(message: e.toString()));
        }
      },
    );

    // penjumlahan
    on<SumMonthNominalEvent>(
      (event, emit) async {
        emit(LaporanLoading());

        final String userId = await getIdUser();
        final DateTime startDate =
            DateTime(event.date.year, event.date.month, 1);
        final DateTime endDate = DateTime(
          startDate.year,
          startDate.month + 1,
          0, // Last day of the month
          23, // Hour
          59, // Minute
          59, // Second
          999, // Milliseconds
        );
        final Timestamp startTimestamp = Timestamp.fromDate(startDate);
        final Timestamp endTimestamp = Timestamp.fromDate(endDate);

        try {
          QuerySnapshot queryPemasukan = await db
              .collection('laporan')
              .where('userId', isEqualTo: userId)
              .where('categoryTipe', isEqualTo: 'Pemasukan')
              .where('tanggal', isGreaterThanOrEqualTo: startTimestamp)
              .where('tanggal', isLessThan: endTimestamp)
              .get();

          QuerySnapshot queryPengeluaran = await db
              .collection('laporan')
              .where('userId', isEqualTo: userId)
              .where('categoryTipe', isEqualTo: 'Pengeluaran')
              .where('tanggal', isGreaterThanOrEqualTo: startTimestamp)
              .where('tanggal', isLessThan: endTimestamp)
              .get();

          int totalPemasukan = queryPemasukan.docs.fold(0, (data, doc) {
            final value = (doc.data() as Map<String, dynamic>)['nominal'] ?? 0;
            return data + (value is num ? value.toInt() : 0);
          });

          int totalPengeluaran = queryPengeluaran.docs.fold(0, (data, doc) {
            final value = (doc.data() as Map<String, dynamic>)['nominal'] ?? 0;
            return data + (value is num ? value.toInt() : 0);
          });

          final List<LaporanModel> pemasukanList = queryPemasukan.docs
              .map((item) => LaporanModel(
                  nominal: item['nominal'],
                  categoryName: item['categoryName'],
                  tanggal: (item['tanggal'] as Timestamp).toDate(),
                  createdAt: (item['createdAt'] as Timestamp).toDate()))
              .toList();

          final List<LaporanModel> pengeluaranList = queryPengeluaran.docs
              .map((item) => LaporanModel(
                  nominal: item['nominal'],
                  categoryName: item['categoryName'],
                  tanggal: (item['tanggal'] as Timestamp).toDate(),
                  createdAt: (item['createdAt'] as Timestamp).toDate()))
              .toList();

          List<LaporanModel> laporanData = [
            ...pemasukanList,
            ...pengeluaranList
          ];

          emit(LaporanSumCalculationState(
              pemasukan: totalPemasukan,
              pengeluaran: totalPengeluaran,
              data: laporanData));
        } catch (e) {
          emit(LaporanError(message: e.toString()));
        }
      },
    );

    on<PieChartEvent>(
      (event, emit) async {
        emit(LaporanLoading());

        final String userId = await getIdUser();
        final Random random = Random();

        final DateTime now = DateTime.now();
        final DateTime startDate = event.startDate != null
            ? DateTime(event.startDate!.year, event.startDate!.month, 1)
            : DateTime(now.year, now.month, 1);
        final DateTime endDate = DateTime(
            event.endDate.year, event.endDate.month + 1, 0, 23, 59, 59, 999);
        final Timestamp startTimestamp = Timestamp.fromDate(startDate);
        final Timestamp endTimestamp = Timestamp.fromDate(endDate);

        try {
          final QuerySnapshot getCategories = await db
              .collection('category')
              .where('userId', isEqualTo: userId)
              .get();

          final dataChart =
              await Future.wait(getCategories.docs.map((item) async {
            final QuerySnapshot laporan = await db
                .collection('laporan')
                .where('userId', isEqualTo: userId)
                .where('categoryName', isEqualTo: item['name'])
                .where('tanggal', isGreaterThanOrEqualTo: startTimestamp)
                .where('tanggal', isLessThanOrEqualTo: endTimestamp)
                .get();

            int sumNominal = laporan.docs.fold(0, (data, doc) {
              final value =
                  (doc.data() as Map<String, dynamic>)['nominal'] ?? 0;
              return data + (value is num ? value.toInt() : 0);
            });

            return {
              'title': item['name'],
              'value': sumNominal,
              'color': Color.fromRGBO(
                random.nextInt(256),
                random.nextInt(256),
                random.nextInt(256),
                1,
              )
            };
          }).toList());

          int totalNominal = dataChart.fold(0, (data, doc) {
            final value = (doc)['value'] ?? 0;
            return data + (value is num ? value.toInt() : 0);
          });

          for (var item in dataChart) {
            item['value'] =
                (((item['value'] as int) / totalNominal) * 100).round();
          }

          emit(LaporanPieChartState(dataChart: dataChart));
        } catch (e) {
          emit(LaporanError(message: e.toString()));
        }
      },
    );
  }

  Future<String> getIdUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid') ?? '';
  }

  Future<void> _getWhereDateLaporan(
      DateTime startDay, DateTime endDay, Emitter<LaporanState> emit) async {
    final String userId = await getIdUser();
    final Timestamp startTimestamp = Timestamp.fromDate(startDay);
    final Timestamp endTimestamp = Timestamp.fromDate(endDay);

    try {
      final QuerySnapshot getLaporan = await db
          .collection('laporan')
          .where('tanggal', isGreaterThanOrEqualTo: startTimestamp)
          .where('tanggal', isLessThanOrEqualTo: endTimestamp)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      final result = getLaporan.docs
          .map((data) => LaporanModel(
                uid: data['uid'],
                keterangan: data['keterangan'],
                nominal: data['nominal'],
                categoryTipe: data['categoryTipe'],
                categoryName: data['categoryName'],
                tanggal: (data['tanggal'] as Timestamp).toDate(),
                createdAt: (data['createdAt'] as Timestamp).toDate(),
              ))
          .toList();

      emit(LaporanLoaded(dataLaporan: result));
    } catch (e) {
      emit(LaporanError(message: e.toString()));
    }
  }
}
