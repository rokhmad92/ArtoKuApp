import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GlobalVariable {
  static double deviceWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static String convertToRupiah(dynamic number) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return currencyFormatter.format(number);
  }
}
