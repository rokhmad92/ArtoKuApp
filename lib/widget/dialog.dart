import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artoku/bloc/auth/auth_bloc.dart';
import 'package:artoku/bloc/category/category_bloc.dart';
import 'package:artoku/bloc/laporan/laporan_bloc.dart';
import 'package:artoku/widget/number_field.dart';
import 'package:artoku/widget/text_field.dart';

class DialogWidget {
  // logout
  static void logout(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Keluar Akun',
                style: Theme.of(context).primaryTextTheme.displayLarge,
              ),
            ),
            content: const Text('Apakah Anda yakin ingin keluar?'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
                    },
                    child: const Text('Yakin'),
                  ),
                ],
              )
            ],
          );
        });
  }

  // Category
  static void editCategory(
      BuildContext context, String uidEdit, String nameEdit, String category) {
    final TextEditingController editNameController =
        TextEditingController(text: nameEdit);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Edit Kategori',
              style: Theme.of(context).primaryTextTheme.displayLarge,
            ),
          ),
          content: FormText(
            controller: editNameController,
            labelText: 'Name',
            hintText: '',
            inputActionDone: true,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<CategoryBloc>().add(UpdateCategoryEvent(
                        uid: uidEdit, name: editNameController.text));
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Simpan'),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  static void deleteCategory(
      BuildContext context, String uid, String category) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Hapus Kategori',
                style: Theme.of(context).primaryTextTheme.displayLarge,
              ),
            ),
            content: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 300,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Apakah anda yakin ingin menghapus data ini?'),
                  SizedBox(height: 15),
                  Text(
                    "Aksi ini akan menghapus semua data terkait kategori.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.red),
                  )
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<CategoryBloc>().add(
                          DestroyCategoryEvent(uid: uid, category: category));
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('Yakin'),
                  ),
                ],
              )
            ],
          );
        });
  }

  // Laporan
  static void editLaporan(
      BuildContext context,
      LaporanBloc bloc1,
      LaporanBloc bloc2,
      String uidEdit,
      DateTime dateEdit,
      String keteranganEdit,
      String nominalEdit) {
    final TextEditingController editKeteranganController =
        TextEditingController(text: keteranganEdit);
    final TextEditingController editNominalController =
        TextEditingController(text: nominalEdit);

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Edit Laporan',
              style: Theme.of(context).primaryTextTheme.displayLarge,
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormText(
                    controller: editKeteranganController,
                    labelText: 'Keterangan',
                    hintText: '',
                    inputActionDone: false,
                    required: false,
                  ),
                  const SizedBox(height: 20.0),
                  FormNumber(
                    controller: editNominalController,
                    labelText: 'Nominal',
                    hintText: '',
                    inputActionDone: true,
                    currency: true,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      int nominalInt = int.parse(editNominalController.text
                          .replaceAll(RegExp(r'[^0-9]'), ''));

                      bloc1.add(UpdateDateLaporanEvent(
                          uid: uidEdit,
                          nominal: nominalInt,
                          keterangan: editKeteranganController.text,
                          date: dateEdit));
                      bloc2.add(SumMonthNominalEvent(date: dateEdit));
                      Navigator.of(dialogContext).pop();
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static void deleteLaporan(BuildContext context, LaporanBloc bloc1,
      LaporanBloc bloc2, String uid, DateTime date) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Hapus Laporan',
                style: Theme.of(context).primaryTextTheme.displayLarge,
              ),
            ),
            content: const Text('Apakah anda yakin menghapus data ini?'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      bloc1.add(DestroyDateLaporanEvent(uid: uid, date: date));
                      bloc2.add(SumMonthNominalEvent(date: date));
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('Yakin'),
                  ),
                ],
              )
            ],
          );
        });
  }
}
