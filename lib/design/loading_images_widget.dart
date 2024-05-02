import 'package:flutter/material.dart';

class LoadingImagesWidget extends StatelessWidget {

  const LoadingImagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(15.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.orange,),
              SizedBox(width: 15,),
              Text(
                "Подгружаем фотографии",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
              ),

            ],
          )
      ),
    );
  }

}