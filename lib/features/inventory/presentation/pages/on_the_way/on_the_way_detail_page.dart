import 'package:flutter/material.dart';

import '../../../../../../core/fonts/fonts.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/helpers.dart';
import '../../../../../../core/widgets/base_card.dart';
import '../../../domain/entities/batch_entity.dart';
import '../../../domain/entities/good_entity.dart';
import '../../widgets/info_tile.dart';

class OnTheWayDetailPage extends StatelessWidget {
  const OnTheWayDetailPage({
    super.key,
    required this.batch,
    required this.good,
  });

  final BatchEntity batch;
  final GoodEntity good;

  @override
  Widget build(BuildContext context) {
    final uniqueCodesSet = good.uniqueCodes.toSet();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Barang'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BaseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Informasi Barang',
                  style: paragraphSmall[heavy].copyWith(
                    color: black,
                  ),
                ),
                const SizedBox(height: 12),
                InfoTile(
                  title: 'Nama Barang',
                  value: good.name,
                ),
                const SizedBox(height: 8),
                InfoTile(
                  title: 'Tanggal Pengiriman',
                  value: batch.shippedAt.toDDMMMYYY,
                ),
                const SizedBox(height: 8),
                InfoTile(
                  title: 'Customer',
                  value: good.customer.name,
                ),
                const SizedBox(height: 8),
                InfoTile(
                  title: 'Total Koli',
                  value: '${good.totalItem}',
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InfoTile(
                        isCopyable: true,
                        title: 'No Invoice',
                        value: good.invoiceNumber,
                      ),
                    ),
                    Expanded(
                      child: InfoTile(
                        isCopyable: true,
                        title: 'No Resi',
                        value: good.receiptNumber,
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
                        value: good.origin.name,
                      ),
                    ),
                    Expanded(
                      child: InfoTile(
                        title: 'Gudang Akhir',
                        value: good.destination.name,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Informasi Koli',
                  style: TextStyle(fontSize: 12, color: gray),
                ),
                ListView.separated(
                  itemBuilder: (context, index) =>
                      buildUniqueCodes(index, uniqueCodesSet, good),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemCount: (good.allUniqueCodes.length / 2).ceil(),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
