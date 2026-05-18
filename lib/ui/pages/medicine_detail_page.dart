import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_tracker/bloc/medicine_bloc.dart';
import 'package:medicine_tracker/bloc/medicine_event.dart';
import 'package:medicine_tracker/bloc/medicine_state.dart';
import 'package:medicine_tracker/data/models/medicine_model.dart';
import 'package:medicine_tracker/ui/ui_config.dart';

class MedicineDetailPage extends StatefulWidget {
  final Medicine medicine;
  const MedicineDetailPage(
      {super.key, required this.medicine});

  @override
  State<MedicineDetailPage> createState() =>
      _MedicineDetailPageState();
}

class _MedicineDetailPageState
    extends State<MedicineDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _dosageCtrl;
  late TextEditingController _timeCtrl;
  late TextEditingController _notesCtrl;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(
        text: widget.medicine.medicineName);
    _dosageCtrl = TextEditingController(
        text: widget.medicine.dosage);
    _timeCtrl = TextEditingController(
        text: widget.medicine.time);
    _notesCtrl = TextEditingController(
        text: widget.medicine.notes ?? '');
  }

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
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
              primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      _timeCtrl.text = picked.format(context);
    }
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    final updated = widget.medicine.copyWith(
      medicineName: _nameCtrl.text.trim(),
      dosage: _dosageCtrl.text.trim(),
      time: _timeCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty
          ? null
          : _notesCtrl.text.trim(),
    );

    context.read<MedicineBloc>().add(
        UpdateMedicine(
            widget.medicine.id!, updated));
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16)),
        title: const Text('Delete Medicine?'),
        content: Text(
            'Remove ${widget.medicine.medicineName} from your tracker?'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(
                    color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppTheme.errorRed),
            onPressed: () {
              Navigator.pop(context);
              context.read<MedicineBloc>().add(
                  DeleteMedicine(
                      widget.medicine.id!));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTaken =
        widget.medicine.status == 'Taken';

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
          title: Text(_isEditing
              ? 'Edit Medicine'
              : 'Medicine Details'),
          leading: IconButton(
            icon: const Icon(
                Icons.arrow_back_ios_rounded),
            onPressed: () {
              if (_isEditing) {
                setState(
                    () => _isEditing = false);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            if (!_isEditing)
              IconButton(
                icon: const Icon(
                    Icons.edit_rounded),
                onPressed: () => setState(
                    () => _isEditing = true),
              ),
            if (!_isEditing)
              IconButton(
                icon: const Icon(
                    Icons.delete_outline_rounded),
                onPressed: _confirmDelete,
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: _isEditing
              ? _buildEditForm()
              : _buildDetailView(isTaken),
        ),
      ),
    );
  }

  Widget _buildDetailView(bool isTaken) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppTheme.primary,
                AppTheme.mediumTeal
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
                BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withValues(alpha: 0.2),
                      borderRadius:
                          BorderRadius.circular(
                              12),
                    ),
                    child: const Icon(
                        Icons.medication_rounded,
                        color: Colors.white,
                        size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget
                          .medicine.medicineName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6),
                decoration: BoxDecoration(
                  color: isTaken
                      ? AppTheme.takenGreen
                      : AppTheme.pendingAmber,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  isTaken
                      ? '✓  Taken'
                      : '✗  Not Taken',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _detailCard(
            label: 'Medicine Name',
            value: widget.medicine.medicineName,
            icon: Icons.medication_rounded),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _detailCard(
                  label: 'Dosage',
                  value: widget.medicine.dosage,
                  icon: Icons.colorize_rounded),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _detailCard(
                  label: 'Time',
                  value: widget.medicine.time,
                  icon:
                      Icons.access_time_rounded),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _detailCard(
          label: 'Status',
          value: isTaken ? 'Taken' : 'Not Taken',
          icon:
              Icons.check_circle_outline_rounded,
          valueColor: isTaken
              ? AppTheme.takenGreen
              : AppTheme.pendingAmber,
        ),
        if (widget.medicine.notes != null &&
            widget
                .medicine.notes!.isNotEmpty) ...[
          const SizedBox(height: 12),
          _detailCard(
              label: 'Notes',
              value: widget.medicine.notes!,
              icon: Icons.notes_rounded),
        ],
        const SizedBox(height: 32),
        Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: isTaken
                  ? AppTheme.pendingAmber
                  : AppTheme.takenGreen,
            ),
            icon: Icon(
              isTaken
                  ? Icons.undo_rounded
                  : Icons.check_rounded,
              color: Colors.white,
              size: 16,
            ),
            label: Text(
              isTaken
                  ? 'Mark as Not Taken'
                  : 'Mark as Taken',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13),
            ),
            onPressed: () => context
                .read<MedicineBloc>()
                .add(ToggleMedicineStatus(
                    widget.medicine)),
          ),
        ),
      ],
    );
  }

  Widget _detailCard({
    required String label,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppTheme.paleCyan, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 18,
              color: AppTheme.mediumTeal),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.mediumTeal,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: valueColor ??
                    const Color(0xFF1A3A42),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          _labeledField(
            label: 'Medicine Name',
            hint: 'e.g. Amoxicillin',
            controller: _nameCtrl,
            icon: Icons.medication_rounded,
            validator: (v) => v!.isEmpty
                ? 'Name is required'
                : null,
          ),
          const SizedBox(height: 20),
          _labeledField(
            label: 'Dosage',
            hint: 'e.g. 500mg',
            controller: _dosageCtrl,
            icon: Icons.colorize_rounded,
            validator: (v) => v!.isEmpty
                ? 'Dosage is required'
                : null,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _pickTime,
            child: AbsorbPointer(
              child: _labeledField(
                label: 'Time',
                hint: 'Select time',
                controller: _timeCtrl,
                icon: Icons.access_time_rounded,
                validator: (v) => v!.isEmpty
                    ? 'Time is required'
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _labeledField(
            label: 'Notes',
            hint:
                'e.g. Take after meals (optional)',
            controller: _notesCtrl,
            icon: Icons.notes_rounded,
            maxLines: 3,
          ),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : _saveChanges,
              child: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child:
                          CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2),
                    )
                  : const Text('Save Changes',
                      style: TextStyle(
                          fontSize: 13)),
            ),
          ),
        ],
      ),
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
