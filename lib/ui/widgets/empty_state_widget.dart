import 'package:flutter/material.dart';
import '../ui_config.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.mintGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.medication_outlined,
              size: 50,
              color: AppTheme.mediumTeal,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No medicines yet',
            style: Theme.of(context)
                .textTheme
                .displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first medicine',
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),
        ],
      ),
    );
  }
}
