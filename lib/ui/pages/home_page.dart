import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/medicine_bloc.dart';
import '../../bloc/medicine_event.dart';
import '../../bloc/medicine_state.dart';
import '../ui_config.dart';
import '../widgets/medicine_card.dart';
import '../widgets/empty_state_widget.dart';
import 'add_medicine_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context
        .read<MedicineBloc>()
        .add(const LoadMedicines());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        elevation: 0,
        title: const Text('MediTrack'),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.refresh_rounded),
            onPressed: () => context
                .read<MedicineBloc>()
                .add(const LoadMedicines()),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: BlocConsumer<MedicineBloc,
                MedicineState>(
              listener: (context, state) {
                if (state
                    is MedicineOperationSuccess) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                        content:
                            Text(state.message)),
                  );
                } else if (state
                    is MedicineError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content:
                          Text(state.message),
                      backgroundColor:
                          AppTheme.errorRed,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is MedicineLoading) {
                  return const Center(
                    child:
                        CircularProgressIndicator(
                      color: AppTheme.primary,
                    ),
                  );
                }

                final medicines = switch (state) {
                  MedicineLoaded(
                    :final medicines
                  ) =>
                    medicines,
                  MedicineOperationSuccess(
                    :final medicines
                  ) =>
                    medicines,
                  _ => null,
                };

                if (medicines == null) {
                  if (state is MedicineError) {
                    return _buildError(
                        context, state.message);
                  }
                  return const SizedBox.shrink();
                }

                if (medicines.isEmpty) {
                  return const EmptyStateWidget();
                }
                return RefreshIndicator(
                  color: AppTheme.primary,
                  onRefresh: () async {
                    context
                        .read<MedicineBloc>()
                        .add(
                            const LoadMedicines());
                  },
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.only(
                            top: 8, bottom: 100),
                    itemCount: medicines.length,
                    itemBuilder: (_, i) =>
                        MedicineCard(
                            medicine:
                                medicines[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<MedicineBloc>(),
              child: const AddMedicinePage(),
            ),
          ),
        ),
        child: const Icon(Icons.add_rounded,
            size: 28),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<MedicineBloc,
        MedicineState>(
      builder: (context, state) {
        final medicines = switch (state) {
          MedicineLoaded(:final medicines) =>
            medicines,
          MedicineOperationSuccess(
            :final medicines
          ) =>
            medicines,
          _ => <dynamic>[],
        };

        final total = medicines.length;
        final taken = medicines
            .where((m) => m.status == 'Taken')
            .length;
        final pending = total - taken;

        return Container(
          color: AppTheme.primary,
          padding: const EdgeInsets.fromLTRB(
              20, 0, 20, 20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Schedule',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _statCard('Total', '$total',
                      Icons.medication_rounded,
                      bgColor: AppTheme.deepTeal,
                      iconColor: Colors.white),
                  const SizedBox(width: 10),
                  _statCard(
                      'Taken',
                      '$taken',
                      Icons
                          .check_circle_outline_rounded,
                      bgColor:
                          AppTheme.takenGreen,
                      iconColor: Colors.white),
                  const SizedBox(width: 10),
                  _statCard(
                      'Not Taken',
                      '$pending',
                      Icons.cancel_outlined,
                      bgColor:
                          AppTheme.pendingAmber,
                      iconColor: Colors.white),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard(
      String label, String value, IconData icon,
      {Color bgColor = AppTheme.deepTeal,
      Color iconColor = Colors.white}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: iconColor, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(
      BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 56,
                color: AppTheme.mediumTeal),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(
                  Icons.refresh_rounded),
              label: const Text('Try Again'),
              onPressed: () => context
                  .read<MedicineBloc>()
                  .add(const LoadMedicines()),
            ),
          ],
        ),
      ),
    );
  }
}
