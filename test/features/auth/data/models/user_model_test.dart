import 'package:flutter_test/flutter_test.dart';
import 'package:tri_express/features/auth/data/models/user_model.dart';
import 'package:tri_express/features/auth/domain/entities/user_entity.dart';

void main() {
  const tUserModel = UserModel(
    id: '-',
    warehouseId: '-',
    email: 'email',
    name: 'name',
    phoneNumber: 'phoneNumber',
    roles: ['role1', 'role2'],
  );

  test(
    'should be a subclass of user entity',
    () {
      // assert
      expect(tUserModel, isA<UserEntity>());
    },
  );

  test(
    'should return a valid model from JSON',
    () {
      // arrange
      const response = <String, dynamic>{
        'status': 'Success',
        'message': 'success login',
        'data': {
          'user': {
            'id': '019903c3-cea2-7034-a051-d4d169d78f72',
            'gudang_id': '019903c3-ca8b-713f-9037-0ef28cab6905',
            'name': 'admin_gudang',
            'email': 'admin_gudang@domain.com',
            'no_telp': '+231486558155',
            'email_verified_at': '2025-09-01T05:33:08.000000Z',
            'avatar': null,
            'status': 1,
            'created_at': '2025-09-01T05:33:08.000000Z',
            'updated_at': '2025-09-01T05:33:08.000000Z',
            'roles': [
              {
                'uuid': '019903c3-cafc-702b-955e-a6f8b06fcf04',
                'name': 'admin_gudang',
                'guard_name': 'web',
                'created_at': '2025-09-01T05:33:07.000000Z',
                'updated_at': '2025-09-01T05:33:07.000000Z',
                'pivot': {
                  'model_type': 'App\\Models\\User',
                  'model_uuid': '019903c3-cea2-7034-a051-d4d169d78f72',
                  'role_id': '019903c3-cafc-702b-955e-a6f8b06fcf04'
                }
              }
            ]
          },
          'token': '2|oYzqST7Tww54RlnbQ3rSknnGqTLt0gj5QaB8We3gccbab1a2',
          'role': 'admin_gudang'
        }
      };

      // act
      final result = UserModel.fromJson(response['data']['user']);

      // assert
      expect(result, isA<UserModel>());
    },
  );
}
