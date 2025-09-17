import '../../domain/entities/dropdown_entity.dart';

class DropdownModel extends DropdownEntity {
  const DropdownModel({
    required super.id,
    required super.value,
  });

  factory DropdownModel.fromJson(Map<String, dynamic> json) {
    return DropdownModel(
      id: '${json['id']}',
      value: json['text'],
    );
  }

  DropdownEntity toEntity() {
    return DropdownEntity(
      id: id,
      value: value,
    );
  }
}
