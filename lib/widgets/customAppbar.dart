import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String name;

  const CustomAppBar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          "assets/Logo3B.png",
          height: 40.0,
          width: 40.0,
        ),
        const SizedBox(width: 60),
        Expanded(
          child: FittedBox(
            child: Text(name),
          ),
        ),
      ],
    );
  }
}
