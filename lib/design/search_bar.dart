import 'package:flutter/material.dart';

import 'custom_button.dart';

class SearchingBar extends StatelessWidget {

  final TextEditingController searchController;
  final VoidCallback onClear;
  final VoidCallback onButtonClick;

  const SearchingBar({super.key, required this.searchController, required this.onClear, required this.onButtonClick});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Поиск',
                  prefixIcon: const Icon(Icons.search),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),

                  ),
                  suffixIcon: searchController.text.isNotEmpty ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: onClear,
                  ) : null,
                ),
                controller: searchController,

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: CustomButton(
              onTap: onButtonClick,
              buttonText: 'Поиск',
              icon: Icons.search,
            ),
          ),
        ],
      ),
    );
  }

}