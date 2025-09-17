class CustomerEntity {
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
}
