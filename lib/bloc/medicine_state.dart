import 'package:equatable/equatable.dart';
import '../data/models/medicine_model.dart';

abstract class MedicineState extends Equatable {
  const MedicineState();

  @override
  List<Object?> get props => [];
}

class MedicineInitial extends MedicineState {
  const MedicineInitial();
}

class MedicineLoading extends MedicineState {
  const MedicineLoading();
}

class MedicineLoaded extends MedicineState {
  final List<Medicine> medicines;
  const MedicineLoaded(this.medicines);

  @override
  List<Object?> get props => [medicines];
}

class MedicineOperationSuccess
    extends MedicineState {
  final List<Medicine> medicines;
  final String message;
  const MedicineOperationSuccess(
      this.medicines, this.message);

  @override
  List<Object?> get props => [medicines, message];
}

class MedicineError extends MedicineState {
  final String message;
  const MedicineError(this.message);

  @override
  List<Object?> get props => [message];
}
