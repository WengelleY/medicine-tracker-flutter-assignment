import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_tracker/bloc/medicine_bloc.dart';
import 'package:medicine_tracker/bloc/medicine_event.dart';
import 'package:medicine_tracker/bloc/medicine_state.dart';
import 'package:medicine_tracker/data/models/medicine_model.dart';
import 'package:medicine_tracker/ui/ui_config.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({super.key});

  @override
  State<AddMedicinePage> createState() =>
      _AddMedicinePageState();
}

class _AddMedicinePageState
    extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _dosageCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dosageCtrl.dispose();
    _timeCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppTheme.primary,
            onSurface: AppTheme.primary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      _timeCtrl.text = picked.format(context);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    final medicine = Medicine(
      medicineName: _nameCtrl.text.trim(),
      dosage: _dosageCtrl.text.trim(),
      time: _timeCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty
          ? null
          : _notesCtrl.text.trim(),
      status: 'Not Taken',
    );

    context
        .read<MedicineBloc>()
        .add(AddMedicine(medicine));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicineBloc,
        MedicineState>(
      listener: (context, state) {
        if (state is MedicineOperationSuccess) {
          setState(() => _isLoading = false);
          Navigator.pop(context);
        } else if (state is MedicineError) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('Add Medicine'),
          leading: IconButton(
            icon: const Icon(
                Icons.arrow_back_ios_rounded),
            onPressed: () =>
                Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                _sectionHeader(
                    'Medicine Details'),
                const SizedBox(height: 16),
                _labeledField(
                  label: 'Medicine Name',
                  hint: 'e.g. Amoxicillin',
                  controller: _nameCtrl,
                  icon: Icons.medication_rounded,
                  validator: (v) =>
                      v == null || v.isEmpty
                          ? 'Name is required'
                          : null,
                ),
                const SizedBox(height: 20),
                _labeledField(
                  label: 'Dosage',
                  hint: 'e.g. 500mg',
                  controller: _dosageCtrl,
                  icon: Icons.colorize_rounded,
                  validator: (v) =>
                      v == null || v.isEmpty
                          ? 'Dosage is required'
                          : null,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickTime,
                  child: AbsorbPointer(
                    child: _labeledField(
                      label: 'Time',
                      hint: 'Tap to select time',
                      controller: _timeCtrl,
                      icon: Icons
                          .access_time_rounded,
                      validator: (v) =>
                          v == null || v.isEmpty
                              ? 'Time is required'
                              : null,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _sectionHeader('Additional Info'),
                const SizedBox(height: 16),
                _labeledField(
                  label: 'Notes',
                  hint:
                      'e.g. Take after meals (optional)',
                  controller: _notesCtrl,
                  icon: Icons.notes_rounded,
                  maxLines: 3,
                ),
                const SizedBox(height: 36),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : _submit,
                    child: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child:
                                CircularProgressIndicator(
                                    color: Colors
                                        .white,
                                    strokeWidth:
                                        2),
                          )
                        : const Text(
                            'Add Medicine'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppTheme.mediumTeal,
            borderRadius:
                BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _labeledField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon,
                size: 15,
                color: AppTheme.mediumTeal),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.mediumTeal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppTheme.paleCyan,
                  width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppTheme.paleCyan,
                  width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppTheme.primary,
                  width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppTheme.errorRed,
                  width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
