import 'package:dio/dio.dart';

import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSources {
  Future<UserModel> fetchCurrentUser();
  Future<UserModel> login({required LoginParams params});
  Future<String> logout();
}

class AuthRemoteDataSourcesImpl extends AuthRemoteDataSources {
  AuthRemoteDataSourcesImpl({required this.dio});

  final Dio dio;

  @override
  Future<UserModel> fetchCurrentUser() async {
    try {
      final response = await dio.get(apiUrl);

      return UserModel.fromJson(response.data['data']['user']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          throw ServerException(
            message: de.response?.data['message'] ?? 'Something went wrong',
            statusCode: de.response?.statusCode ?? 500,
          );
      }
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<UserModel> login({required LoginParams params}) async {
    try {
      final response = await dio.post(
        apiUrl,
        data: {
          'email': params.email,
          'password': params.password,
        },
      );

      return UserModel.fromJson(response.data['data']['user']);
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          throw ServerException(
            message: de.response?.data['message'] ?? 'Something went wrong',
            statusCode: de.response?.statusCode ?? 500,
          );
      }
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> logout() async {
    try {
      final response = await dio.post(apiUrl);

      return response.data['message'];
    } on DioException catch (de) {
      switch (de.response?.statusCode) {
        default:
          throw ServerException(
            message: de.response?.data['message'] ?? 'Something went wrong',
            statusCode: de.response?.statusCode ?? 500,
          );
      }
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }
}
