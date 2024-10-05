import 'package:flutter/material.dart';
import 'package:artoku/widget/app_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Templete extends StatelessWidget {
  final Widget content;
  final bool withScrollView;
  const Templete(
      {super.key, required this.content, this.withScrollView = true});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkConnection(context);
    });

    return Container(
      padding: const EdgeInsets.only(top: 15.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).secondaryHeaderColor,
          ],
        ),
      ),
      child: Column(
        children: [
          const Navbar(),
          Expanded(
              child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              color: Colors.white,
            ),
            child: withScrollView
                ? SingleChildScrollView(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: content,
                  )
                : content,
          ))
        ],
      ),
    );
  }

  Future<void> checkConnection(context) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      Navigator.pushReplacementNamed(context, 'reconnect');
    }
  }
}
