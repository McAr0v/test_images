import 'package:flutter/material.dart';
import 'package:test_images/design/text_and_icon_widget.dart';
import 'package:test_images/image_class/image_from_pixabay.dart';
import '../screens/full_screen_page.dart';

class ImageWidget extends StatelessWidget {

  final ImageFromPixabay image;
  final double height;

  const ImageWidget({super.key, required this.image, required this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          navigateToFullScreen(context);
        },
        child: Stack(
          children: [

            // Картинка
            SizedBox(
              width: double.infinity,
              height: height,
              child: Image.network(
                image.imageURL,
                fit: BoxFit.cover,
              ),
            ),

            // Лайки и просмотры
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextAndIconWidget(
                        text: image.likes.toString(),
                        icon: Icons.favorite,
                      ),
                      TextAndIconWidget(
                        text: image.views.toString(),
                        icon: Icons.visibility,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }

  void navigateToFullScreen(BuildContext context){
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FullScreenImagePage(imageUrl: image.largeImageURL, imageId: image.id.toString(),);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

}