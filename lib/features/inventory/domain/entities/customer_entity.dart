import 'package:equatable/equatable.dart';

class CustomerEntity extends Equatable {
  const CustomerEntity({
    required this.id,
    required this.code,
    required this.address,
    required this.name,
    required this.phoneNumber,
  });

  final String id;
  final String code;
  final String address;
  final String name;
  final String phoneNumber;

  @override
  List<Object?> get props => [id, code, address, name, phoneNumber];
}
