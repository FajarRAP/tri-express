import 'package:dio/dio.dart';

import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/utils/helpers.dart';

abstract class CoreRemoteDataSources {
  Future<List<String>> fetchBanners();
  Future<List<int>> fetchSummary();
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
}
