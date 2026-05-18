import 'package:dio/dio.dart';
import '../models/medicine_model.dart';
import '../services/dio_client.dart';

class MedicineRepository {
  final DioClient _dioClient;
  static const String _endpoint = '/medicines';

  MedicineRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  Future<List<Medicine>> getMedicines() async {
    try {
      final response =
          await _dioClient.dio.get(_endpoint);
      final List<dynamic> data = response.data;
      return data
          .map((json) => Medicine.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Medicine> getMedicineById(
      String id) async {
    try {
      final response = await _dioClient.dio
          .get('$_endpoint/$id');
      return Medicine.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Medicine> createMedicine(
      Medicine medicine) async {
    try {
      final response = await _dioClient.dio.post(
        _endpoint,
        data: medicine.toJson(),
      );
      return Medicine.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Medicine> updateMedicine(
      String id, Medicine medicine) async {
    try {
      final response = await _dioClient.dio.put(
        '$_endpoint/$id',
        data: medicine.toJson(),
      );
      return Medicine.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deleteMedicine(String id) async {
    try {
      await _dioClient.dio
          .delete('$_endpoint/$id');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out. Please check your internet.';
      case DioExceptionType.receiveTimeout:
        return 'Server took too long to respond.';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
