import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/base_card.dart';
import '../widgets/info_tile.dart';

class ItemDetailPage extends StatelessWidget {
  const ItemDetailPage({
    super.key,
    required this.itemId,
  });

  final String itemId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Barang $itemId'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BaseCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
              GridView.count(
                crossAxisCount: 2,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 2.5 / 1,
                shrinkWrap: true,
                children: <Widget>[
                  InfoTile(
                    title: 'Jalur',
                    value: '\$path',
                  ),
                  InfoTile(
                    title: 'Batch',
                    value: '\$batchName',
                  ),
                  InfoTile(
                    title: 'Jumlah Koli',
                    value: '\$itemCount',
                  ),
                  InfoTile(
                    title: 'Total Koli',
                    value: '\$itemTotal',
                  ),
                  InfoTile(
                    title: 'No Invoice',
                    value: '\$invoiceNum',
                  ),
                  InfoTile(
                    title: 'No Resi',
                    value: '\$trackingNumber',
                  ),
                  InfoTile(
                    title: 'Gudang Awal',
                    value: '\$firstWarehouse',
                  ),
                  InfoTile(
                    title: 'Gudang Akhir',
                    value: '\$lastWarehouse',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
