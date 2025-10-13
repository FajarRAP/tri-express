import 'package:dio/dio.dart';

import '../../../../core/exceptions/internal_exception.dart';
import '../../../../core/utils/helpers.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/update_user_use_case.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserEntity> fetchCurrentUser();
  Future<LoginResponseModel> login(LoginUseCaseParams params);
  Future<String> logout();
  Future<String> updateUser(UpdateUserUseCaseParams params);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<UserEntity> fetchCurrentUser() async {
    try {
      final response = await dio.get('/profile');

      return UserModel.fromJson(response.data['data']['user']).toEntity();
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<LoginResponseModel> login(LoginUseCaseParams params) async {
    try {
      final response = await dio.post(
        '/login',
        data: {
          'email': params.email,
          'password': params.password,
        },
      );

      return LoginResponseModel.fromJson(response.data['data']);
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> logout() async {
    try {
      final response = await dio.post('/logout');

      return response.data['data'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }

  @override
  Future<String> updateUser(UpdateUserUseCaseParams params) async {
    try {
      final response = await dio.post(
        '/profile',
        data: {
          'name': params.name,
          'email': params.email,
          'no_telp': params.phoneNumber,
          'password': params.password,
          'avatar': params.avatarPath != null
              ? await MultipartFile.fromString(params.avatarPath!)
              : null,
        },
      );

      return response.data['message'];
    } on DioException catch (de) {
      throw handleDioException(de);
    } catch (e) {
      throw InternalException(message: '$e');
    }
  }
}
