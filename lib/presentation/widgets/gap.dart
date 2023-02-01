import 'package:flutter/material.dart';

/// Создает пустое пространство.
///
/// Используется для визуального отделения виджетов друг от друга.
/// Опционально принимает высоту [height] и ширину [width]
class Gap extends StatelessWidget {
  final double width;
  final double height;

  const Gap({this.width = 10, this.height = 10, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
