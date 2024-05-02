import 'package:flutter/material.dart';
import 'custom_button.dart';

class EmptyResultWidget extends StatelessWidget {

  final VoidCallback onTap;

  const EmptyResultWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Изображений не найдено', style: TextStyle(color: Colors.black, fontSize: 20),),
              const SizedBox(height: 30,),
              SizedBox(
                width: 300,
                child: CustomButton(
                  onTap: onTap,
                  buttonText: 'Очистить поиск',
                  icon: Icons.delete,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}