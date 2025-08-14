import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/routes/router.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/badges/secondary_badge.dart';
import '../../../../core/widgets/badges/success_badge.dart';
import '../../../../core/widgets/badges/warning_badge.dart';
import '../../../../core/widgets/base_card.dart';
import '../../../../core/widgets/buttons/outline_primary_button.dart';
import '../../../../core/widgets/notification_icon_button.dart';
import '../../../../core/widgets/primary_gradient_card.dart';
import '../../../../main.dart';
import '../widgets/info_tile.dart';

class OnTheWayPage extends StatelessWidget {
  const OnTheWayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final batches = Batch.generate(20);

    return Scaffold(
      appBar: AppBar(
        title: const Text('On The Way'),
        actions: <Widget>[
          const NotificationIconButton(),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          PrimaryGradientCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Dalam Pengiriman ke \$Warehouse Location',
                  style: const TextStyle(
                    color: light,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Number',
                  style: const TextStyle(
                    color: light,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ListView.separated(
            itemBuilder: (context, index) =>
                BatchCardItem(batch: batches[index]),
            separatorBuilder: (context, index) => const SizedBox(height: 24),
            itemCount: batches.length,
            padding: const EdgeInsets.only(bottom: 24),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
          )
        ],
      ),
    );
  }
}

class Batch {
  Batch({
    required this.id,
    required this.batch,
    required this.destination,
    required this.itemCount,
    required this.origin,
    required this.path,
    required this.sendAt,
    required this.status,
  });

  final String id;
  final String batch;
  final String destination;
  final int itemCount;
  final String origin;
  final String path;
  final DateTime sendAt;
  final String status;

  static List<Batch> generate(int count) {
    const path = <String, dynamic>{
      '1': 'Darat',
      '2': 'Laut',
      '3': 'Udara',
      '4': 'Kereta'
    };
    const status = <String, dynamic>{
      '1': 'Selesai',
      '2': 'Sedang Dikirim',
      '3': 'Terjadwal'
    };

    final randomizer = faker.randomGenerator;

    return List.generate(
      count,
      (index) => Batch(
        id: faker.guid.guid(),
        batch: "Batch $index",
        destination: faker.address.city(),
        itemCount: count * randomizer.integer(100, min: 1) +
            randomizer.integer(1000, min: 1),
        origin: faker.address.city(),
        path: randomizer.mapElementValue(path),
        sendAt: DateTime.now(),
        status: randomizer.mapElementValue(status),
      ),
    );
  }
}

class BatchCardItem extends StatelessWidget {
  const BatchCardItem({
    super.key,
    required this.batch,
  });

  final Batch batch;

  @override
  Widget build(BuildContext context) {
    const status = <String, dynamic>{
      'Selesai': SuccessBadge(label: 'Selesai'),
      'Sedang Dikirim': WarningBadge(label: 'Sedang Dikirim'),
      'Terjadwal': SecondaryBadge(label: 'Terjadwal')
    };

    return BaseCard(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  '${batch.origin} - ${batch.destination}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              status[batch.status] ?? const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 10),
          GridView.count(
            childAspectRatio: 2.5 / 1,
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              InfoTile(
                title: 'Batch',
                value: batch.batch,
              ),
              InfoTile(
                title: 'Jalur',
                value: batch.path,
              ),
              InfoTile(
                title: 'Total Koli',
                value: '${batch.itemCount}',
              ),
              InfoTile(
                title: 'Tanggal Dikirim',
                value: DateFormat('dd/MM/yyyy').format(batch.sendAt),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinePrimaryButton(
              onPressed: () => context.push(
                '$onTheWayRoute$batchDetailRoute/${batch.id}',
                extra: batch.batch,
              ),
              child: const Text('Detail'),
            ),
          ),
        ],
      ),
    );
  }
}
