import 'package:dio/dio.dart';

import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/utils/helpers.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/use_cases/fetch_delivery_shipments_use_case.dart';
import '../../domain/use_cases/fetch_receive_shipments_use_case.dart';
import '../models/batch_model.dart';

abstract class InventoryRemoteDataSources {
  Future fetchDeliveryShipment({required String id});
  Future<List<BatchEntity>> fetchDeliveryShipments(
      {required FetchDeliveryShipmentsUseCaseParams params});
  Future fetchInvoice({required String id});
  Future fetchInvoices();
  Future fetchOnTheWayShipment({required String id});
  Future fetchOnTheWayShipments();
  Future fetchPrepareShipment({required String id});
  Future fetchPrepareShipments();
  Future fetchReceiveShipment({required String id});
  Future<List<BatchEntity>> fetchReceiveShipments(
      {required FetchReceiveShipmentsUseCaseParams params});
}

class InventoryRemoteDataSourcesImpl implements InventoryRemoteDataSources {
  const InventoryRemoteDataSourcesImpl({required this.dio});

  final Dio dio;

  @override
  Future fetchDeliveryShipment({required String id}) {
    // TODO: implement fetchDeliveryShipment
    throw UnimplementedError();
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
  Future fetchInvoice({required String id}) {
    // TODO: implement fetchInvoice
    throw UnimplementedError();
  }

  @override
  Future fetchInvoices() {
    // TODO: implement fetchInvoices
    throw UnimplementedError();
  }

  @override
  Future fetchOnTheWayShipment({required String id}) {
    // TODO: implement fetchOnTheWayShipment
    throw UnimplementedError();
  }

  @override
  Future fetchOnTheWayShipments() {
    // TODO: implement fetchOnTheWayShipments
    throw UnimplementedError();
  }

  @override
  Future fetchPrepareShipment({required String id}) {
    // TODO: implement fetchPrepareShipment
    throw UnimplementedError();
  }

  @override
  Future fetchPrepareShipments() {
    // TODO: implement fetchPrepareShipments
    throw UnimplementedError();
  }

  @override
  Future fetchReceiveShipment({required String id}) {
    // TODO: implement fetchReceiveShipment
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
