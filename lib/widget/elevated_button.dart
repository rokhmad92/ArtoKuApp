import 'package:flutter/material.dart';

class ButtonElevated extends StatelessWidget {
  const ButtonElevated({
    super.key,
    this.styleText,
    required this.onPress,
    required this.text,
  });

  final VoidCallback onPress;
  final String text;
  final TextStyle? styleText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPress,
        style: Theme.of(context).elevatedButtonTheme.style,
        child: Text(
          text,
          style: styleText ??
              Theme.of(context)
                  .primaryTextTheme
                  .displayMedium!
                  .copyWith(letterSpacing: 1),
        ));
  }
}
