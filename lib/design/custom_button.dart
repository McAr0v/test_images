import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final Color buttonColor;
  final VoidCallback onTap;
  final IconData? icon;
  final String buttonText;

  const CustomButton({super.key, required this.onTap, required this.buttonText, this.buttonColor = Colors.orange, this.icon});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(25)),
        ),
        onPressed: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, color: Colors.white,),
            if (icon != null) const SizedBox(width: 10),
            Text(
              buttonText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
            ),
          ],
        )
    );
  }

}