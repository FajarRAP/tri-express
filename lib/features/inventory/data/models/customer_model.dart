import '../../domain/entities/customer_entity.dart';

class CustomerModel extends CustomerEntity {
  const CustomerModel({
    required super.id,
    required super.code,
    required super.address,
    required super.name,
    required super.phoneNumber,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: '${json['id']}',
      code: json['kode'],
      address: json['alamat'],
      name: json['nama'],
      phoneNumber: json['no_telp'],
    );
  }

  CustomerEntity toEntity() {
    return CustomerEntity(
      id: id,
      code: code,
      address: address,
      name: name,
      phoneNumber: phoneNumber,
    );
  }
}
