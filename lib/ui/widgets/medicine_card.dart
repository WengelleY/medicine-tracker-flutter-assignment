import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_tracker/bloc/medicine_bloc.dart';
import 'package:medicine_tracker/data/models/medicine_model.dart';
import 'package:medicine_tracker/ui/ui_config.dart';
import 'package:medicine_tracker/ui/pages/medicine_detail_page.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;

  const MedicineCard(
      {super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    final bool isTaken =
        medicine.status == 'Taken';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<MedicineBloc>(),
            child: MedicineDetailPage(
                medicine: medicine),
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isTaken
                ? AppTheme.takenGreen
                    .withValues(alpha: 0.3)
                : AppTheme.paleCyan,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.deepTeal
                  .withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Left: plain medicine icon, no circle
              const Icon(
                Icons.medication_rounded,
                color: AppTheme.paleCyan,
                size: 26,
              ),
              const SizedBox(width: 14),
              // Middle: medicine info
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.medicineName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            decoration: isTaken
                                ? TextDecoration
                                    .lineThrough
                                : TextDecoration
                                    .none,
                            color: isTaken
                                ? const Color(
                                    0xFF9BC5CE)
                                : const Color(
                                    0xFF1A3A42),
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _infoChip(
                            Icons
                                .colorize_rounded,
                            medicine.dosage),
                        const SizedBox(width: 8),
                        _infoChip(
                            Icons
                                .access_time_rounded,
                            medicine.time),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.paleCyan,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 11, color: AppTheme.deepTeal),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.deepTeal,
            ),
          ),
        ],
      ),
    );
  }
}
