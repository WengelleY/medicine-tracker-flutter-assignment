import 'package:flutter/material.dart';

const Color _mintGreen = Color(0xFFDEF5E5);
const Color _mediumTeal = Color(0xFF3DAA8C);

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: _mintGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.medication_outlined,
              size: 50,
              color: _mediumTeal,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No medicines yet',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first medicine',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
