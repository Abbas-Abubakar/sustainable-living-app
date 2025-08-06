import 'package:flutter/material.dart';

class ProgressItem extends StatefulWidget {
  final String label;
  final double value;
  final Color color;
  const ProgressItem({super.key, required this.label, required this.value,
  required this.color});

  @override
  State<ProgressItem> createState() => _ProgressItemState();
}

class _ProgressItemState extends State<ProgressItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(widget.label, style: const TextStyle(fontSize: 12)),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: widget.value,
            backgroundColor: widget.color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation(widget.color),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(widget.value * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
