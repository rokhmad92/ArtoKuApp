import 'package:flutter/material.dart';
import 'package:artoku/widget/elevated_button.dart';
import '../services/intro_service.dart';
import '../global_variable.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  int locationPage = 0;
  PageController _controller = PageController();

  @override
  void initState() {
    _controller = PageController(initialPage: 0);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).secondaryHeaderColor,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  setState(() {
                    locationPage = index;
                  });
                },
                itemBuilder: (BuildContext context, int i) {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image.asset(
                          contents[i].image,
                          width: GlobalVariable.deviceWidth(context) * 0.80,
                          height: GlobalVariable.deviceHeight(context) * 0.50,
                        ),
                        Text(contents[i].title,
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).primaryTextTheme.titleMedium),
                        const SizedBox(height: 20),
                        Text(
                          contents[i].text,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).primaryTextTheme.titleSmall,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
            buildDot(contents, locationPage),
            const SizedBox(
              height: 20,
            ),
            ButtonElevated(
              text:
                  locationPage == contents.length - 1 ? 'Login' : 'Selanjutnya',
              onPress: () {
                if (locationPage == contents.length - 1) {
                  Navigator.pushNamed(context, 'login');
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDot(contents, index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        contents.length,
        (int i) => Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: index == i ? Colors.white : Colors.white38),
        ),
      ),
    );
  }
}
