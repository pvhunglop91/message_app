import 'package:flutter/material.dart';

class BuildSelect extends StatelessWidget {
  const BuildSelect({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
  });
  final Function()? onPressed;
  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          Text(text),
          const Spacer(),
          icon,
        ],
      ),
    );
  }
}
