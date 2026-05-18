import 'package:equatable/equatable.dart';
import '../data/models/medicine_model.dart';

abstract class MedicineEvent extends Equatable {
  const MedicineEvent();

  @override
  List<Object?> get props => [];
}

class LoadMedicines extends MedicineEvent {
  const LoadMedicines();
}

class AddMedicine extends MedicineEvent {
  final Medicine medicine;
  const AddMedicine(this.medicine);

  @override
  List<Object?> get props => [medicine];
}

class UpdateMedicine extends MedicineEvent {
  final String id;
  final Medicine medicine;
  const UpdateMedicine(this.id, this.medicine);

  @override
  List<Object?> get props => [id, medicine];
}

class DeleteMedicine extends MedicineEvent {
  final String id;
  const DeleteMedicine(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleMedicineStatus extends MedicineEvent {
  final Medicine medicine;
  const ToggleMedicineStatus(this.medicine);

  @override
  List<Object?> get props => [medicine];
}
