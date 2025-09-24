import 'package:dio/dio.dart';

import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/utils/helpers.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/entities/good_entity.dart';
import '../../domain/use_cases/create_prepare_shipments_use_case.dart';
import '../../domain/use_cases/create_receive_shipments_use_case.dart';
import '../../domain/use_cases/fetch_delivery_shipments_use_case.dart';
import '../../domain/use_cases/fetch_inventories_use_case.dart';
import '../../domain/use_cases/fetch_preview_receive_shipments_use_case.dart';
import '../../domain/use_cases/fetch_on_the_way_shipments_use_case.dart';
import '../../domain/use_cases/fetch_prepare_shipments_use_case.dart';
import '../../domain/use_cases/fetch_receive_shipments_use_case.dart';
import '../models/batch_model.dart';
import '../models/good_model.dart';

abstract class InventoryRemoteDataSources {
  Future<String> createPrepareShipments(
      {required CreatePrepareShipmentsUseCaseParams params});
  Future<String> createReceiveShipments(
      {required CreateReceiveShipmentsUseCaseParams params});
  Future<String> deletePreparedShipments({required String shipmentId});
  Future<List<BatchEntity>> fetchDeliveryShipments(
      {required FetchDeliveryShipmentsUseCaseParams params});
  Future<List<BatchEntity>> fetchInventories(
      {required FetchInventoriesUseCaseParams params});
  Future<int> fetchInventoriesCount();
  Future fetchOnTheWayShipments(
      {required FetchOnTheWayShipmentsUseCaseParams params});
  Future fetchPrepareShipments(
      {required FetchPrepareShipmentsUseCaseParams params});
  Future<List<GoodEntity>> fetchPreviewPrepareShipments(
      {required List<String> uniqueCodes});
  Future<List<BatchEntity>> fetchPreviewReceiveShipments(
      {required FetchPreviewReceiveShipmentsUseCaseParams params});
  Future<List<BatchEntity>> fetchReceiveShipments(
      {required FetchReceiveShipmentsUseCaseParams params});
}

class InventoryRemoteDataSourcesImpl implements InventoryRemoteDataSources {
  const InventoryRemoteDataSourcesImpl({required this.dio});

  final Dio dio;

  @override
  Future<String> createPrepareShipments(
      {required CreatePrepareShipmentsUseCaseParams params}) async {
    try {
      final response = await dio.post(
        '/prepare/store',
        data: {
          'shipment_date': params.shippedAt.toIso8601String(),
          'estimate_date': params.estimatedAt.toIso8601String(),
          'batch_code': params.batchName,
          'next_warehouse_id': params.nextWarehouse.id,
          'type': params.transportMode.id,
          'codes': params.uniqueCodes,
        },
      );

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> createReceiveShipments(
      {required CreateReceiveShipmentsUseCaseParams params}) async {
    try {
      final response = await dio.post(
        '/receive/store',
        data: {
          'receive_date': params.receivedAt.toIso8601String(),
          'codes': params.uniqueCodes,
        },
      );

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> deletePreparedShipments({required String shipmentId}) async {
    try {
      final response = await dio.delete('/prepare/destroy/$shipmentId');

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

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
  Future<List<BatchEntity>> fetchInventories(
      {required FetchInventoriesUseCaseParams params}) async {
    try {
      final response = await dio.get(
        '/inventory',
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
  Future<int> fetchInventoriesCount() async {
    try {
      final response = await dio.get('/inventory/total');

      return response.data['data']['total_units'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
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
  Future fetchPrepareShipments(
      {required FetchPrepareShipmentsUseCaseParams params}) async {
    try {
      final response = await dio.get(
        '/prepare',
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

  @override
  Future<List<GoodEntity>> fetchPreviewPrepareShipments(
      {required List<String> uniqueCodes}) async {
    try {
      final response = await dio.post(
        '/prepare/preview',
        data: {'codes': uniqueCodes},
      );
      final contents =
          List<Map<String, dynamic>>.from(response.data['data']['items']);

      return contents.map((e) => GoodModel.fromJson(e).toEntity()).toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<List<BatchEntity>> fetchPreviewReceiveShipments(
      {required FetchPreviewReceiveShipmentsUseCaseParams params}) async {
    try {
      final response = await dio.post(
        '/receive/preview',
        data: {'codes': params.uniqueCodes},
      );

      final contents = List<Map<String, dynamic>>.from(response.data['data']);

      return contents.map((e) => BatchModel.fromJson(e).toEntity()).toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }
}
