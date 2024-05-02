import 'package:flutter/material.dart';

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          tag: 'imageHero', // Тот же тег, что и у маленького изображения
          child: FadeTransition(
            opacity: AlwaysStoppedAnimation(1),
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}