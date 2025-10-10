import 'package:dio/dio.dart';

import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/utils/helpers.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/entities/good_entity.dart';
import '../../domain/entities/lost_good_entity.dart';
import '../../domain/entities/picked_good_entity.dart';
import '../../domain/entities/timeline_summary_entity.dart';
import '../../domain/use_cases/create_delivery_shipments_use_case.dart';
import '../../domain/use_cases/create_picked_up_goods_use_case.dart';
import '../../domain/use_cases/create_prepare_shipments_use_case.dart';
import '../../domain/use_cases/create_receive_shipments_use_case.dart';
import '../../domain/use_cases/fetch_delivery_shipments_use_case.dart';
import '../../domain/use_cases/fetch_inventories_use_case.dart';
import '../../domain/use_cases/fetch_on_the_way_shipments_use_case.dart';
import '../../domain/use_cases/fetch_picked_up_goods_use_case.dart';
import '../../domain/use_cases/fetch_prepare_shipments_use_case.dart';
import '../../domain/use_cases/fetch_preview_delivery_shipments_use_case.dart';
import '../../domain/use_cases/fetch_preview_receive_shipments_use_case.dart';
import '../../domain/use_cases/fetch_receive_shipments_use_case.dart';
import '../models/batch_model.dart';
import '../models/good_model.dart';
import '../models/lost_good_model.dart';
import '../models/picked_good_model.dart';
import '../models/timeline_summary_model.dart';

abstract class InventoryRemoteDataSources {
  Future<String> createDeliveryShipments(
      CreateDeliveryShipmentsUseCaseParams params);
  Future<String> createPickedUpGoods(CreatePickedUpGoodsUseCaseParams params);
  Future<String> createPrepareShipments(
      CreatePrepareShipmentsUseCaseParams params);
  Future<String> createReceiveShipments(
      CreateReceiveShipmentsUseCaseParams params);
  Future<String> deletePreparedShipments(String shipmentId);
  Future<List<BatchEntity>> fetchDeliveryShipments(
      FetchDeliveryShipmentsUseCaseParams params);
  Future<TimelineSummaryEntity> fetchGoodTimeline(String receiptNumber);
  Future<List<BatchEntity>> fetchInventories(
      FetchInventoriesUseCaseParams params);
  Future<int> fetchInventoriesCount();
  Future<List<BatchEntity>> fetchOnTheWayShipments(
      FetchOnTheWayShipmentsUseCaseParams params);
  Future<List<PickedGoodEntity>> fetchPickedUpGoods(
      FetchPickedUpGoodsUseCaseParams params);
  Future<List<BatchEntity>> fetchPrepareShipments(
      FetchPrepareShipmentsUseCaseParams params);
  Future<List<BatchEntity>> fetchPreviewDeliveryShipments(
      FetchPreviewDeliveryShipmentsUseCaseParams params);
  Future<List<GoodEntity>> fetchPreviewPickUpGoods(List<String> uniqueCodes);
  Future<List<GoodEntity>> fetchPreviewPrepareShipments(
      List<String> uniqueCodes);
  Future<List<BatchEntity>> fetchPreviewReceiveShipments(
      FetchPreviewReceiveShipmentsUseCaseParams params);
  Future<List<BatchEntity>> fetchReceiveShipments(
      FetchReceiveShipmentsUseCaseParams params);
  Future<LostGoodEntity> fetchLostGood(String uniqueCode);
}

class InventoryRemoteDataSourcesImpl implements InventoryRemoteDataSources {
  const InventoryRemoteDataSourcesImpl({required this.dio});

  final Dio dio;

  @override
  Future<String> createDeliveryShipments(
      CreateDeliveryShipmentsUseCaseParams params) async {
    try {
      final response = await dio.post(
        '/delivery/store',
        data: {
          'next_warehouse_id': params.nextWarehouse.id,
          'delivery_date': params.deliveredAt.toYYYYMMDD,
          'user_id': params.driver.id,
          'codes': params.uniqueCodes,
          'shipment_ids': params.shipmentIds,
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
  Future<String> createPickedUpGoods(
      CreatePickedUpGoodsUseCaseParams params) async {
    try {
      final response = await dio.post(
        '/taking/store',
        data: FormData.fromMap(
          {
            'batch_tracking_number': params.receiptNumbers,
            'codes': params.uniqueCodes,
            'note': params.note,
            'foto': await MultipartFile.fromFile(params.imagePath),
            'delivery_date': params.pickedUpAt.toYYYYMMDD,
          },
          ListFormat.multiCompatible,
        ),
      );

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> createPrepareShipments(
      CreatePrepareShipmentsUseCaseParams params) async {
    try {
      final response = await dio.post(
        '/prepare/store',
        data: {
          'shipment_date': params.shippedAt.toYYYYMMDD,
          'estimate_date': params.estimatedAt.toYYYYMMDD,
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
      CreateReceiveShipmentsUseCaseParams params) async {
    try {
      final response = await dio.post(
        '/receive/store',
        data: {
          'receive_date': params.receivedAt.toYYYYMMDD,
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
  Future<String> deletePreparedShipments(String shipmentId) async {
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
      FetchDeliveryShipmentsUseCaseParams params) async {
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
  Future<TimelineSummaryEntity> fetchGoodTimeline(String receiptNumber) async {
    try {
      final response = await dio.get(
        '/inventory/timeline',
        queryParameters: {'q': receiptNumber},
      );

      return TimelineSummaryModel.fromJson(response.data['data']).toEntity();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<List<BatchEntity>> fetchInventories(
      FetchInventoriesUseCaseParams params) async {
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
  Future<LostGoodEntity> fetchLostGood(String uniqueCode) async {
    try {
      final response = await dio.get(
        '/inventory/search',
        queryParameters: {'code': uniqueCode},
      );

      return LostGoodModel.fromJson(response.data['data']).toEntity();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<List<BatchEntity>> fetchOnTheWayShipments(
      FetchOnTheWayShipmentsUseCaseParams params) async {
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
  Future<List<PickedGoodEntity>> fetchPickedUpGoods(
      FetchPickedUpGoodsUseCaseParams params) async {
    try {
      final response = await dio.get(
        '/taking',
        queryParameters: {
          'page': params.page,
          'per_page': params.perPage,
          'search': params.search,
        },
      );

      final contents =
          List<Map<String, dynamic>>.from(response.data['data']['data']);

      return contents
          .map((e) => PickedGoodModel.fromJson(e).toEntity())
          .toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<List<BatchEntity>> fetchPrepareShipments(
      FetchPrepareShipmentsUseCaseParams params) async {
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
      FetchReceiveShipmentsUseCaseParams params) async {
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
  Future<List<BatchEntity>> fetchPreviewDeliveryShipments(
      FetchPreviewDeliveryShipmentsUseCaseParams params) async {
    try {
      final response = await dio.post(
        '/delivery/preview',
        data: {
          'next_warehouse_id': params.nextWarehouse.id,
          // 'driver_id': params.driver?.id,
          'codes': params.uniqueCodes,
        },
      );

      final contents = List<Map<String, dynamic>>.from(response.data['data']);

      return contents.map((e) => BatchModel.fromJson(e).toEntity()).toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<List<GoodEntity>> fetchPreviewPickUpGoods(
      List<String> uniqueCodes) async {
    try {
      final response = await dio.post(
        '/taking/preview',
        data: {'codes': uniqueCodes},
      );

      final contents = List<Map<String, dynamic>>.from(response.data['data']);

      return contents.map((e) => GoodModel.fromJson(e).toEntity()).toList();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<List<GoodEntity>> fetchPreviewPrepareShipments(
      List<String> uniqueCodes) async {
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
      FetchPreviewReceiveShipmentsUseCaseParams params) async {
    try {
      final response = await dio.post(
        '/receive/preview',
        data: {
          'codes': params.uniqueCodes,
          'warehouse_id': params.origin.id,
        },
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
