import 'package:artoku/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:artoku/bloc/laporan/laporan_bloc.dart';
import 'package:artoku/widget/button_select.dart';
import 'package:artoku/listData/list_data.dart';
import 'package:artoku/widget/pie_chart.dart';
import 'package:artoku/widget/templete.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Report extends StatelessWidget {
  Report({super.key});

  final DateTime now = DateTime.now();
  final LaporanBloc bloc1 = LaporanBloc();
  final LaporanBloc bloc2 = LaporanBloc();
  final LaporanBloc bloc3 = LaporanBloc();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc1.add(PieChartEvent(endDate: now));
      bloc2.add(GetWhereDateLaporanEvent(
          startDate: DateTime(now.year, now.month, 1),
          endDate: DateTime(now.year, now.month + 1, 0)));
      bloc3.add(SumMonthNominalEvent(
          startDate: DateTime(now.year, now.month, 1),
          endDate: DateTime(now.year, now.month + 1, 0)));
    });

    final List<Widget> skeletonLoaders = List.generate(
      6,
      (index) => const Skeletonizer(
        enabled: true,
        child: ListData(
          kategori: 'hallo word',
          keterangan: 'asdsdgjsadkgjsdlkgjaskejf',
          nominal: 0,
          tipe: '',
        ),
      ),
    );

    return Templete(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyPieChart(bloc: bloc1),
          const SizedBox(height: 20),
          BlocBuilder<LaporanBloc, LaporanState>(
            bloc: bloc3,
            builder: (context, state) {
              if (state is LaporanError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is LaporanSumCalculationState) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 14.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: state.selisih < 0
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).secondaryHeaderColor,
                        offset: const Offset(0, 4),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: [
                            Text('Total',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .displaySmall!),
                            const SizedBox(height: 5),
                            Text(GlobalVariable.convertToRupiah(state.selisih),
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .displayLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: state.selisih < 0
                                            ? Colors.red
                                            : Colors.green))
                          ],
                        ),
                      )
                    ]),
                  ),
                );
              }

              return const Center();
            },
          ),
          const SizedBox(height: 20),
          ButtonSelect(
            options: const ['Bulan ini', 'Bulan lalu', '3 Bulan'],
            bloc1: bloc1,
            bloc2: bloc2,
            bloc3: bloc3,
          ),
          const SizedBox(height: 20),
          Text(
            'History Laporan',
            style: Theme.of(context)
                .primaryTextTheme
                .displayLarge!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          BlocConsumer<LaporanBloc, LaporanState>(
            bloc: bloc2,
            listener: (context, state) {
              if (state is LaporanError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is LaporanSuccess) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              if (state is LaporanLoading) {
                return Column(children: skeletonLoaders);
              } else if (state is LaporanLoaded) {
                if (state.dataLaporan.isEmpty) {
                  return const Center(
                    child: SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          'Laporan belum tersedia',
                          style:
                              TextStyle(color: Colors.black45, fontSize: 20.0),
                        ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  itemCount: state.dataLaporan.length,
                  itemBuilder: (context, index) {
                    final data = state.dataLaporan[index];
                    return ListData(
                      uid: data.uid,
                      date: data.tanggal,
                      kategori: data.categoryName,
                      tanggal:
                          DateFormat('d MMMM').format(data.tanggal).toString(),
                      keterangan: data.keterangan!,
                      nominal: data.nominal,
                      tipe: data.categoryTipe!,
                      bloc1: bloc1,
                      bloc2: bloc2,
                      pageLaporan: true,
                    );
                  },
                );
              }
              return Column(children: skeletonLoaders);
            },
          ),
        ],
      ),
    );
  }
}
