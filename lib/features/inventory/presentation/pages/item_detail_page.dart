import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/base_card.dart';
import '../widgets/info_tile.dart';
import '../widgets/timeline_indicator.dart';

class ItemDetailPage extends StatelessWidget {
  const ItemDetailPage({
    super.key,
    required this.itemId,
  });

  final String itemId;

  @override
  Widget build(BuildContext context) {
    final timelines = Timeline.generate(5);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Barang $itemId'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          const SizedBox(height: 16),
          BaseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Informasi Barang',
                  style: const TextStyle(
                    color: black,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                InfoTile(
                  title: 'Tanggal Pengiriman',
                  value: '\$DateTime',
                ),
                const SizedBox(height: 4),
                InfoTile(
                  title: 'Customer',
                  value: '\$CustomerName',
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InfoTile(
                        title: 'No Invoice',
                        value: '\$invoiceNum',
                      ),
                    ),
                    Expanded(
                      child: InfoTile(
                        title: 'No Resi',
                        value: '\$trackingNumber',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InfoTile(
                        title: 'Gudang Awal',
                        value: '\$firstWarehouse',
                      ),
                    ),
                    Expanded(
                      child: InfoTile(
                        title: 'Gudang Akhir',
                        value: '\$lastWarehouse',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          BaseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Detail Status',
                  style: const TextStyle(
                    color: black,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$ItemId',
                  style: const TextStyle(
                    color: black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Status: \$status',
                  style: const TextStyle(
                    color: black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),
                ListView.builder(
                  itemBuilder: (context, index) => SizedBox(
                    height: 80,
                    child: TimelineIndicator(timeline: timelines[index]),
                  ),
                  itemCount: timelines.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
