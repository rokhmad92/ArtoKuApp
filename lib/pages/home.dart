import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:artoku/bloc/laporan/laporan_bloc.dart';
import 'package:artoku/models/laporan_model.dart';
import 'package:artoku/widget/card_info.dart';
import 'package:artoku/listData/list_data.dart';
import 'package:artoku/widget/templete.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime _today = DateTime.now();
  DateTime? _selectedDay;
  final LaporanBloc bloc1 = LaporanBloc();
  final LaporanBloc bloc2 = LaporanBloc();

  @override
  void initState() {
    bloc1.add(GetWhereDateLaporanEvent(startDate: _today, endDate: _today));
    bloc2.add(SumMonthNominalEvent(date: _today));
    super.initState();
  }

  List<LaporanModel> listOfDayEvents(DateTime day, LaporanState state) {
    if (state is LaporanSumCalculationState) {
      return state.data.where((event) {
        return event.tanggal.year == day.year &&
            event.tanggal.month == day.month &&
            event.tanggal.day == day.day;
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final DateTime firstYear = DateTime(_today.year - 1, 1, 1);
    final DateTime lastYear = DateTime(_today.year + 1, 12, 31);
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

    return Scaffold(
      body: Templete(
        withScrollView: false,
        content: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<LaporanBloc, LaporanState>(
                      bloc: bloc2,
                      builder: (context, state) {
                        return TableCalendar(
                          firstDay: firstYear,
                          lastDay: lastYear,
                          focusedDay: _today,
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                          selectedDayPredicate: (day) =>
                              isSameDay(_selectedDay, day),
                          eventLoader: (day) => listOfDayEvents(day, state),
                          onPageChanged: (focusedDay) {
                            setState(() {
                              _today = focusedDay;
                            });
                            bloc2.add(SumMonthNominalEvent(date: focusedDay));
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            if (!isSameDay(_selectedDay, selectedDay)) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _today = focusedDay;
                              });
                              bloc1.add(GetWhereDateLaporanEvent(
                                  startDate: selectedDay,
                                  endDate: selectedDay));
                            }
                          },
                          calendarBuilders: CalendarBuilders(
                            dowBuilder: (context, day) {
                              if (day.weekday == DateTime.sunday) {
                                final text = DateFormat.E().format(day);
                                return Center(
                                  child: Text(
                                    text,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                );
                              }
                              return null;
                            },
                            defaultBuilder: (context, day, focusedDay) {
                              if (day.weekday == DateTime.sunday) {
                                return Center(
                                  child: Text(
                                    '${day.day}',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                );
                              }
                              return null;
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'Riwayat',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .displayLarge!
                            .copyWith(
                                fontWeight: FontWeight.w500, fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        children: [
                          BlocConsumer<LaporanBloc, LaporanState>(
                            bloc: bloc1,
                            listener: (context, state) {
                              if (state is LaporanError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                              } else if (state is LaporanSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
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
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 20.0),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: state.dataLaporan.length,
                                  itemBuilder: (context, index) {
                                    final data = state.dataLaporan[index];
                                    return ListData(
                                      uid: data.uid,
                                      date: data.tanggal,
                                      kategori: data.categoryName,
                                      keterangan: data.keterangan!,
                                      nominal: data.nominal,
                                      tipe: data.categoryTipe!,
                                      bloc1: bloc1,
                                      bloc2: bloc2,
                                    );
                                  },
                                );
                              }
                              return Column(children: skeletonLoaders);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -20,
              child: CardInfo(bloc: bloc2),
            ),
          ],
        ),
      ),
    );
  }
}
