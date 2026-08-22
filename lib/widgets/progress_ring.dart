import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing({super.key, required this.value, this.size = 56});

  final double value;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: 6,
            strokeCap: StrokeCap.round,
            backgroundColor: const Color(0xFFEDE8F7),
          ),
          Text(
            '${(value * 100).round()}٪',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
