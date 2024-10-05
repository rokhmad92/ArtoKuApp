import 'package:flutter/material.dart';
import 'package:artoku/bloc/laporan/laporan_bloc.dart';
import 'package:artoku/global_variable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardInfo extends StatelessWidget {
  final LaporanBloc bloc;
  const CardInfo({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: GlobalVariable.deviceWidth(context) * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: (GlobalVariable.deviceWidth(context) * 0.79) / 2,
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(width: 1, color: Colors.grey)),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -10,
                  top: -10,
                  width: 50,
                  height: 60,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Color(0xFFC8E6C9),
                          Colors.white,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_upward,
                      size: 34,
                      color: Colors.green,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pemasukan',
                      style: TextStyle(color: Colors.black54),
                    ),
                    BlocBuilder<LaporanBloc, LaporanState>(
                      bloc: bloc,
                      builder: (context, state) {
                        if (state is LaporanSumCalculationState) {
                          return Text(
                              GlobalVariable.convertToRupiah(state.pemasukan),
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold));
                        }

                        return const Text('.............',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold));
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: (GlobalVariable.deviceWidth(context) * 0.79) / 2,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(width: 1, color: Colors.grey)),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -12,
                  top: -10,
                  width: 50,
                  height: 60,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(9),
                        bottomRight: Radius.circular(9),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Color(0xFFFFCDD2),
                          Colors.white,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_downward,
                      size: 34,
                      color: Colors.red,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pengeluaran',
                      style: TextStyle(color: Colors.black54),
                    ),
                    BlocBuilder<LaporanBloc, LaporanState>(
                      bloc: bloc,
                      builder: (context, state) {
                        if (state is LaporanSumCalculationState) {
                          return Text(
                              GlobalVariable.convertToRupiah(state.pengeluaran),
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold));
                        }

                        return const Text('.............',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold));
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
