import 'package:flutter/material.dart';

class LogoHeader extends StatelessWidget {

  final String pixabayLogo = 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/84/Pixabay-logo_%28old%29.svg/1280px-Pixabay-logo_%28old%29.svg.png';

  const LogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              width: 200,
              child: Image.network(
                pixabayLogo,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 5,),

            const Text(
              'Приложение по поиску картинок',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }

}