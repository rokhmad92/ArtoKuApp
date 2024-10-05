import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artoku/bloc/category/category_bloc.dart';
import 'package:artoku/bloc/laporan/laporan_bloc.dart';
import 'package:artoku/models/laporan_model.dart';
import 'package:artoku/widget/button_select.dart';
import 'package:artoku/widget/date_field.dart';
import 'package:artoku/widget/elevated_button.dart';
import 'package:artoku/widget/number_field.dart';
import 'package:artoku/widget/select_field.dart';
import 'package:artoku/widget/templete.dart';
import 'package:artoku/widget/text_field.dart';
import 'package:intl/intl.dart';

class Input extends StatelessWidget {
  const Input({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryBloc>().add(GetCategoryEvent(category: 'Pemasukan'));
    });
    final formKey = GlobalKey<FormState>();
    late String category;
    final TextEditingController dateController = TextEditingController();
    final TextEditingController keteranganController = TextEditingController();
    final TextEditingController nominalController = TextEditingController();

    return Scaffold(
        body: Templete(
      content: Form(
          key: formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Form input data',
              style: Theme.of(context)
                  .primaryTextTheme
                  .displayLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: Theme.of(context).primaryTextTheme.displayMedium,
                children: const [
                  TextSpan(
                    text:
                        'Isi form ini untuk menginput laporan keuangan. Tanda',
                  ),
                  TextSpan(
                    text: ' * ',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(
                    text: 'wajib di isi',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const ButtonSelect(
              options: ['Pemasukan', 'Pengeluaran'],
              getCategory: true,
            ),
            const SizedBox(height: 15),
            BlocConsumer<LaporanBloc, LaporanState>(listener: (context, state) {
              if (state is LaporanSuccess) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is LaporanError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            }, builder: (context, state) {
              if (state is LaporanLoading) {
                return const Column(children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ]);
              }

              return Column(
                children: [
                  FormDate(
                      labelText: 'Tanggal *',
                      hintText: '',
                      controller: dateController),
                  const SizedBox(height: 15),
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryError) {
                        return Text(state.message);
                      } else if (state is CategoryLoaded) {
                        List<String> categoryNames = state.categories
                            .map((category) => category.name)
                            .toList();
                        category =
                            categoryNames.isNotEmpty ? categoryNames.first : '';

                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FormSelect(
                                list: categoryNames,
                                onChanged: (String? value) {
                                  category = value!;
                                },
                              ),
                              if (categoryNames.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Buat kategori dahulu!',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )
                            ]);
                      }

                      return const Center();
                    },
                  ),
                  const SizedBox(height: 15),
                  FormText(
                    labelText: 'Keterangan',
                    hintText: '',
                    required: false,
                    controller: keteranganController,
                  ),
                  const SizedBox(height: 15),
                  FormNumber(
                    labelText: 'Nominal *',
                    hintText: '',
                    currency: true,
                    controller: nominalController,
                    inputActionDone: true,
                  ),
                  const SizedBox(height: 30),
                  ButtonElevated(
                      text: "Simpan Data",
                      onPress: () {
                        if (formKey.currentState!.validate()) {
                          DateTime dateTime = DateFormat('dd-MM-yyyy')
                              .parse(dateController.text);
                          int nominalInt = int.parse(nominalController.text
                              .replaceAll(RegExp(r'[^0-9]'), ''));

                          final model = LaporanModel(
                              nominal: nominalInt,
                              keterangan: keteranganController.text,
                              categoryName: category,
                              tanggal: dateTime,
                              createdAt: DateTime.now());

                          context
                              .read<LaporanBloc>()
                              .add(CreateLaporanEvent(model: model));

                          dateController.clear();
                          keteranganController.clear();
                          nominalController.clear();
                        }
                      })
                ],
              );
            }),
          ])),
    ));
  }
}
