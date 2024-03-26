import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 5, left: 12, right: 12),
      child: CupertinoSearchTextField(
        controller: TextEditingController(),
        backgroundColor: Colors.white,
      ),
    );
  }
}
