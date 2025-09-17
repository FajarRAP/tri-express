import 'package:dio/dio.dart';

import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/utils/helpers.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/use_cases/fetch_delivery_shipments_use_case.dart';
import '../../domain/use_cases/fetch_on_the_way_shipments_use_case.dart';
import '../../domain/use_cases/fetch_receive_shipments_use_case.dart';
import '../models/batch_model.dart';

abstract class InventoryRemoteDataSources {
  Future<List<BatchEntity>> fetchDeliveryShipments(
      {required FetchDeliveryShipmentsUseCaseParams params});
  Future<List<BatchEntity>> fetchInventories();
  Future fetchOnTheWayShipments(
      {required FetchOnTheWayShipmentsUseCaseParams params});
  Future fetchPrepareShipments();
  Future<List<BatchEntity>> fetchReceiveShipments(
      {required FetchReceiveShipmentsUseCaseParams params});
}

class InventoryRemoteDataSourcesImpl implements InventoryRemoteDataSources {
  const InventoryRemoteDataSourcesImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<BatchEntity>> fetchDeliveryShipments(
      {required FetchDeliveryShipmentsUseCaseParams params}) async {
    try {
      final response = await dio.get(
        '/delivery',
        queryParameters: {
          'page': params.page,
          'per_page': params.perPage,
          'search': params.search,
        },
      );
      final contents =
          List<Map<String, dynamic>>.from(response.data['data']['data']);

      return contents.map((e) => BatchModel.fromJson(e).toEntity()).toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<List<BatchEntity>> fetchInventories() {
    // TODO: implement fetchInventories
    throw UnimplementedError();
  }

  @override
  Future fetchOnTheWayShipments(
      {required FetchOnTheWayShipmentsUseCaseParams params}) async {
    try {
      final response = await dio.get(
        '/otw',
        queryParameters: {
          'page': params.page,
          'per_page': params.perPage,
          'search': params.search
        },
      );
      final contents =
          List<Map<String, dynamic>>.from(response.data['data']['data']);

      return contents.map((e) => BatchModel.fromJson(e).toEntity()).toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future fetchPrepareShipments() {
    // TODO: implement fetchPrepareShipments
    throw UnimplementedError();
  }

  @override
  Future<List<BatchEntity>> fetchReceiveShipments(
      {required FetchReceiveShipmentsUseCaseParams params}) async {
    try {
      final response = await dio.get(
        '/receive',
        queryParameters: {
          'page': params.page,
          'per_page': params.perPage,
          'search': params.search,
        },
      );
      final contents =
          List<Map<String, dynamic>>.from(response.data['data']['data']);

      return contents.map((e) => BatchModel.fromJson(e).toEntity()).toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }
}
