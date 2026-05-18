import 'package:equatable/equatable.dart';

class Medicine extends Equatable {
  final String? id;
  final String medicineName;
  final String dosage;
  final String time;
  final String status;
  final String? notes;

  const Medicine({
    this.id,
    required this.medicineName,
    required this.dosage,
    required this.time,
    this.status = 'Pending',
    this.notes,
  });

  factory Medicine.fromJson(
      Map<String, dynamic> json) {
    return Medicine(
      id: json['id']?.toString(),
      medicineName: json['medicineName'] ?? '',
      dosage: json['dosage'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? 'Pending',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineName': medicineName,
      'dosage': dosage,
      'time': time,
      'status': status,
      'notes': notes,
    };
  }

  Medicine copyWith({
    String? id,
    String? medicineName,
    String? dosage,
    String? time,
    String? status,
    String? notes,
  }) {
    return Medicine(
      id: id ?? this.id,
      medicineName:
          medicineName ?? this.medicineName,
      dosage: dosage ?? this.dosage,
      time: time ?? this.time,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        medicineName,
        dosage,
        time,
        status,
        notes
      ];
}
