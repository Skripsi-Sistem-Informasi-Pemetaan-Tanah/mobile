import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 5, left: 12),
      child: CupertinoSearchTextField(
        controller: controller,
        onChanged: onSearchChanged,
        backgroundColor: Colors.white,
      ),
    );
  }
}
