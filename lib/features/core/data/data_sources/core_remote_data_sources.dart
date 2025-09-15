import 'package:dio/dio.dart';

import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/utils/helpers.dart';
import '../../domain/entities/dropdown_entity.dart';
import '../models/dropdown_model.dart';

abstract class CoreRemoteDataSources {
  Future<List<String>> fetchBanners();
  Future<List<DropdownEntity>> fetchDriverDropdown();
  Future<List<int>> fetchSummary();
  Future<List<DropdownEntity>> fetchTransportModeDropdown();
  Future<List<DropdownEntity>> fetchWarehouseDropdown();
}

class CoreRemoteDataSourcesImpl implements CoreRemoteDataSources {
  const CoreRemoteDataSourcesImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<String>> fetchBanners() async {
    try {
      final response = await dio.get('/dashboard/banner');
      final contents = List<Map<String, dynamic>>.from(response.data['data']);

      return contents.map((e) => '${e['foto_url']}').toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<List<int>> fetchSummary() async {
    try {
      final response = await dio.get('/dashboard/summary');
      final contents = Map<String, dynamic>.from(response.data['data']);

      return [contents['ontheway'], contents['diterima'], contents['dikirim']];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<List<DropdownEntity>> fetchTransportModeDropdown() async {
    try {
      final response = await dio.get('/prepare/jalur');
      final contents = List<Map<String, dynamic>>.from(response.data['data']);

      return contents.map((e) => DropdownModel.fromJson(e).toEntity()).toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<List<DropdownEntity>> fetchWarehouseDropdown() async {
    try {
      final response = await dio.get('/prepare/warehouse');
      final contents = List<Map<String, dynamic>>.from(response.data['data']);

      return contents.map((e) => DropdownModel.fromJson(e).toEntity()).toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<List<DropdownEntity>> fetchDriverDropdown() async {
    try {
      final response = await dio.get('/delivery/driver_list');
      final contents = List<Map<String, dynamic>>.from(response.data['data']);

      return contents.map((e) => DropdownModel.fromJson(e).toEntity()).toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }
}
