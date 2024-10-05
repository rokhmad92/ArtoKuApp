// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:artoku/bloc/laporan/laporan_bloc.dart';
import 'package:artoku/global_variable.dart';
import 'package:artoku/widget/dialog.dart';

class ListData extends StatelessWidget {
  final String? uid;
  final String kategori;
  final String? tanggal;
  final int nominal;
  final String keterangan;
  final String tipe;
  final DateTime? date;
  final LaporanBloc? bloc1;
  final LaporanBloc? bloc2;
  final bool? pageLaporan;

  const ListData({
    super.key,
    this.uid,
    required this.kategori,
    this.tanggal,
    required this.nominal,
    required this.keterangan,
    required this.tipe,
    this.date,
    this.bloc1,
    this.bloc2,
    this.pageLaporan = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          // ketika delete or slidable paling ujung
          // dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              onPressed: (context) {
                DialogWidget.deleteLaporan(
                    context, bloc1!, bloc2!, uid!, date!);
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
            ),
            SlidableAction(
              onPressed: (context) {
                DialogWidget.editLaporan(
                  context,
                  bloc1!,
                  bloc2!,
                  uid!,
                  date!,
                  keterangan,
                  nominal.toString(),
                );
              },
              backgroundColor: const Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.edit,
            ),
          ],
        ),
        enabled: pageLaporan! ? false : true,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  kategori,
                  style: Theme.of(context).primaryTextTheme.displayMedium,
                ),
                if (tanggal != null)
                  Text(
                    tanggal!,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .displaySmall!
                        .copyWith(color: Colors.black26),
                  ),
              ]),
              Text(
                GlobalVariable.convertToRupiah(nominal),
                style: Theme.of(context)
                    .primaryTextTheme
                    .displayMedium
                    ?.copyWith(
                        color: tipe == 'Pemasukan' ? Colors.green : Colors.red),
              )
            ],
          ),
          const SizedBox(height: 10),
          if (keterangan.isNotEmpty)
            Text(
              keterangan,
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .primaryTextTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.w300, letterSpacing: 0.4),
            ),
          const Divider(
            color: Colors.black54,
            thickness: 1,
            height: 20,
          ),
        ]),
      ),
    ]);
  }
}
