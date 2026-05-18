import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_tracker/data/repositories/medicine_repository.dart';
import 'package:medicine_tracker/data/models/medicine_model.dart';
import 'package:medicine_tracker/bloc/medicine_event.dart';
import 'package:medicine_tracker/bloc/medicine_state.dart';

class MedicineBloc
    extends Bloc<MedicineEvent, MedicineState> {
  final MedicineRepository _repository;
  List<Medicine> _medicines = [];

  MedicineBloc({
    required MedicineRepository repository,
  })  : _repository = repository,
        super(const MedicineInitial()) {
    on<LoadMedicines>(_onLoadMedicines);
    on<AddMedicine>(_onAddMedicine);
    on<UpdateMedicine>(_onUpdateMedicine);
    on<DeleteMedicine>(_onDeleteMedicine);
    on<ToggleMedicineStatus>(
      _onToggleMedicineStatus,
    );
  }

  Future<void> _onLoadMedicines(
    LoadMedicines event,
    Emitter<MedicineState> emit,
  ) async {
    emit(const MedicineLoading());
    try {
      _medicines =
          await _repository.getMedicines();
      emit(MedicineLoaded(List.from(_medicines)));
    } catch (e) {
      emit(MedicineError(e.toString()));
    }
  }

  Future<void> _onAddMedicine(
    AddMedicine event,
    Emitter<MedicineState> emit,
  ) async {
    emit(const MedicineLoading());
    try {
      final created = await _repository
          .createMedicine(event.medicine);
      _medicines.add(created);
      emit(
        MedicineOperationSuccess(
          List.from(_medicines),
          'Medicine added successfully!',
        ),
      );
    } catch (e) {
      emit(MedicineError(e.toString()));
    }
  }

  Future<void> _onUpdateMedicine(
    UpdateMedicine event,
    Emitter<MedicineState> emit,
  ) async {
    emit(const MedicineLoading());
    try {
      final updated =
          await _repository.updateMedicine(
        event.id,
        event.medicine,
      );
      final index = _medicines.indexWhere(
        (m) => m.id == event.id,
      );
      if (index != -1) {
        _medicines[index] = updated;
      }
      emit(
        MedicineOperationSuccess(
          List.from(_medicines),
          'Medicine updated successfully!',
        ),
      );
    } catch (e) {
      emit(MedicineError(e.toString()));
    }
  }

  Future<void> _onDeleteMedicine(
    DeleteMedicine event,
    Emitter<MedicineState> emit,
  ) async {
    emit(const MedicineLoading());
    try {
      await _repository.deleteMedicine(event.id);
      _medicines.removeWhere(
        (m) => m.id == event.id,
      );
      emit(
        MedicineOperationSuccess(
          List.from(_medicines),
          'Medicine deleted.',
        ),
      );
    } catch (e) {
      emit(MedicineError(e.toString()));
    }
  }

  Future<void> _onToggleMedicineStatus(
    ToggleMedicineStatus event,
    Emitter<MedicineState> emit,
  ) async {
    final newStatus =
        event.medicine.status == 'Not Taken'
            ? 'Taken'
            : 'Not Taken';
    final updated = event.medicine.copyWith(
      status: newStatus,
    );
    add(
      UpdateMedicine(event.medicine.id!, updated),
    );
  }
}
