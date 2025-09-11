import 'package:dio/dio.dart';

import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/utils/helpers.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/use_cases/fetch_delivery_goods_use_case.dart';
import '../models/batch_model.dart';

abstract class InventoryRemoteDataSources {
  Future fetchDeliveryGood({required String id});
  Future<List<BatchEntity>> fetchDeliveryGoods(
      {required FetchDeliveryGoodsUseCaseParams params});
  Future fetchInvoice({required String id});
  Future fetchInvoices();
  Future fetchOnTheWayGood({required String id});
  Future fetchOnTheWayGoods();
  Future fetchPrepareGood({required String id});
  Future fetchPrepareGoods();
  Future fetchReceiveGood({required String id});
  Future<List<BatchEntity>> fetchReceiveGoods();
}

class InventoryRemoteDataSourcesImpl implements InventoryRemoteDataSources {
  const InventoryRemoteDataSourcesImpl({required this.dio});

  final Dio dio;

  @override
  Future fetchDeliveryGood({required String id}) {
    // TODO: implement fetchDeliveryGood
    throw UnimplementedError();
  }

  @override
  Future<List<BatchEntity>> fetchDeliveryGoods(
      {required FetchDeliveryGoodsUseCaseParams params}) async {
    try {
      final response = await dio.get(
        '/delivery',
        queryParameters: {
          'page': params.currentPage,
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
  Future fetchOnTheWayGood({required String id}) {
    // TODO: implement fetchOnTheWayGood
    throw UnimplementedError();
  }

  @override
  Future fetchOnTheWayGoods() {
    // TODO: implement fetchOnTheWayGoods
    throw UnimplementedError();
  }

  @override
  Future fetchPrepareGood({required String id}) {
    // TODO: implement fetchPrepareGood
    throw UnimplementedError();
  }

  @override
  Future fetchPrepareGoods() {
    // TODO: implement fetchPrepareGoods
    throw UnimplementedError();
  }

  @override
  Future fetchReceiveGood({required String id}) {
    // TODO: implement fetchReceiveGood
    throw UnimplementedError();
  }

  @override
  Future<List<BatchEntity>> fetchReceiveGoods() async {
    try {
      final response = await dio.get('/receive');
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
