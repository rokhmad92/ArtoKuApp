import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artoku/bloc/category/category_bloc.dart';
import 'package:artoku/bloc/laporan/laporan_bloc.dart';
import 'package:artoku/global_variable.dart';

class ButtonSelect extends StatefulWidget {
  const ButtonSelect(
      {super.key,
      required this.options,
      this.getCategory,
      this.bloc1,
      this.bloc2,
      this.bloc3,
      this.nameCategory});

  final List<String> options;
  final bool? getCategory;
  final String? nameCategory; // for get data laporan by category

  final LaporanBloc? bloc1; // for pie chart
  final LaporanBloc? bloc2; // for get data laporan
  final LaporanBloc? bloc3; // for get data laporan

  @override
  State<ButtonSelect> createState() => _ButtonSelectState();
}

class _ButtonSelectState extends State<ButtonSelect> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.options.isNotEmpty ? widget.options.first : '';
  }

  @override
  Widget build(BuildContext context) {
    final categoryBloc = BlocProvider.of<CategoryBloc>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.options.map((option) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: GlobalVariable.deviceWidth(context) * 0.02),
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: selectedOption == option
                    ? Theme.of(context).highlightColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: selectedOption == option
                      ? Colors.transparent
                      : Theme.of(context).highlightColor,
                  width: 1.0,
                ),
              ),
              child: Center(
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      selectedOption = option;
                    });

                    // get category
                    if (widget.getCategory == true) {
                      categoryBloc.add(GetCategoryEvent(category: option));
                    }

                    // pieChart
                    if (widget.bloc1 != null ||
                        widget.bloc2 != null ||
                        widget.bloc3 != null) {
                      final DateTime now = DateTime.now();
                      switch (option) {
                        case 'Bulan ini':
                          if (widget.bloc1 != null) {
                            widget.bloc1!.add(PieChartEvent(endDate: now));
                          }

                          if (widget.bloc2 != null) {
                            widget.bloc2!.add(GetWhereDateLaporanEvent(
                                nameCategory: widget.nameCategory,
                                startDate: DateTime(now.year, now.month, 1),
                                endDate: DateTime(now.year, now.month + 1, 0)));
                          }
                          if (widget.bloc3 != null) {
                            widget.bloc3!.add(SumMonthNominalEvent(
                                nameCategory: widget.nameCategory,
                                startDate: DateTime(now.year, now.month, 1),
                                endDate: DateTime(now.year, now.month + 1, 0)));
                          }
                          break;

                        case 'Bulan lalu':
                          if (widget.bloc1 != null) {
                            widget.bloc1!.add(PieChartEvent(
                                startDate:
                                    DateTime(now.year, now.month - 1, now.day),
                                endDate: DateTime(
                                    now.year, now.month - 1, now.day)));
                          }
                          if (widget.bloc2 != null) {
                            widget.bloc2!.add(GetWhereDateLaporanEvent(
                                nameCategory: widget.nameCategory,
                                startDate: DateTime(now.year, now.month - 1, 1),
                                endDate: DateTime(now.year, now.month, 0)));
                          }
                          if (widget.bloc3 != null) {
                            widget.bloc3!.add(SumMonthNominalEvent(
                              nameCategory: widget.nameCategory,
                              startDate: DateTime(now.year, now.month - 1, 1),
                              endDate: DateTime(now.year, now.month, 0),
                            ));
                          }
                          break;

                        case '3 Bulan':
                          if (widget.bloc1 != null) {
                            widget.bloc1!.add(PieChartEvent(
                                startDate:
                                    DateTime(now.year, now.month - 3, now.day),
                                endDate: now));
                          }
                          if (widget.bloc2 != null) {
                            widget.bloc2!.add(GetWhereDateLaporanEvent(
                                nameCategory: widget.nameCategory,
                                startDate:
                                    DateTime(now.year, now.month - 2, now.day),
                                endDate: now));
                          }
                          if (widget.bloc3 != null) {
                            widget.bloc3!.add(SumMonthNominalEvent(
                                nameCategory: widget.nameCategory,
                                startDate:
                                    DateTime(now.year, now.month - 2, now.day),
                                endDate: now));
                          }
                          break;
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: selectedOption == option
                        ? Colors.white
                        : Theme.of(context).highlightColor,
                    backgroundColor: selectedOption == option
                        ? Theme.of(context).highlightColor
                        : Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(option),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
