import 'package:flutter/material.dart';

class TextAndIconWidget extends StatelessWidget {

  final String text;
  final IconData icon;

  const TextAndIconWidget({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 18,),
        const SizedBox(width: 10,),
        Text(text, style: const TextStyle(color: Colors.grey, fontSize: 12),)
      ],
    );
  }

}