import 'package:flutter/material.dart';
import 'package:artoku/global_variable.dart';
import 'package:artoku/widget/elevated_button.dart';

class Reconnect extends StatelessWidget {
  const Reconnect({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/connected.png',
            width: GlobalVariable.deviceWidth(context) * 0.55,
            height: GlobalVariable.deviceWidth(context) * 0.4,
          ),
          Text(
            'Tidak ada koneksi internet. Mohon periksa pengaturan jaringan Anda dan coba lagi.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .primaryTextTheme
                .displaySmall!
                .copyWith(color: Colors.black26),
          ),
          const SizedBox(height: 18.0),
          SizedBox(
            width: GlobalVariable.deviceWidth(context) * 0.4,
            child: ButtonElevated(
              onPress: () {
                Navigator.pushReplacementNamed(context, 'userPage');
              },
              text: 'Coba Lagi',
            ),
          )
        ],
      ),
    );
  }
}
