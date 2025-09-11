import 'good_entity.dart';
import 'warehouse_entity.dart';

// class BatchEntity {
//   BatchEntity(
//       {required this.id,
//       required this.batch,
//       required this.destination,
//       required this.itemCount,
//       required this.origin,
//       required this.path,
//       required this.sendAt,
//       required this.status,
//       this.isChecked = false});

//   final String id;
//   final String batch;
//   final String destination;
//   final int itemCount;
//   final String origin;
//   final String path;
//   final DateTime sendAt;
//   final String status;
//   bool isChecked;

//   static List<BatchEntity> generate(int count) {
//     const path = <String, dynamic>{
//       '1': 'Darat',
//       '2': 'Laut',
//       '3': 'Udara',
//       '4': 'Kereta'
//     };
//     const status = <String, dynamic>{
//       '1': 'Selesai',
//       '2': 'Sedang Dikirim',
//       '3': 'Terjadwal'
//     };

//     final randomizer = faker.randomGenerator;

//     return List.generate(
//       count,
//       (index) => BatchEntity(
//         id: faker.guid.guid(),
//         batch: "Batch $index",
//         destination: faker.address.city(),
//         itemCount: count * randomizer.integer(100, min: 1) +
//             randomizer.integer(1000, min: 1),
//         origin: faker.address.city(),
//         path: randomizer.mapElementValue(path),
//         sendAt: DateTime.now(),
//         status: randomizer.mapElementValue(status),
//       ),
//     );
//   }
// }

class BatchEntity {
  const BatchEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.trackingNumber,
    required this.goods,
    required this.origin,
    required this.destination,
    required this.sendAt,
  });

  final String id;
  final String name;
  final String status;
  final String trackingNumber;
  final List<GoodEntity> goods;
  final WarehouseEntity origin;
  final WarehouseEntity destination;
  final DateTime sendAt;
}
