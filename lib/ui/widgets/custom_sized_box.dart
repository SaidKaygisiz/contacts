import 'package:flutter/material.dart';

class CustomSizedBox extends StatelessWidget {
  double? height;
  double? width;
  CustomSizedBox({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 24,
      width: width ?? 0,
    );
  }
}
