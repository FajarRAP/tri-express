import 'package:flutter/material.dart';

import '../../../../../core/fonts/fonts.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/widgets/base_card.dart';
import '../../../../core/widgets/badges/success_badge.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/entities/good_entity.dart';
import '../widgets/info_tile.dart';

class InventoryDetailPage extends StatelessWidget {
  const InventoryDetailPage({
    super.key,
    required this.batch,
    required this.good,
  });

  final BatchEntity batch;
  final GoodEntity good;

  @override
  Widget build(BuildContext context) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Informasi Barang',
                      style: paragraphSmall[heavy].copyWith(
                        color: black,
                      ),
                    ),
                    SuccessBadge(label: batch.status),
                  ],
                ),
                const SizedBox(height: 12),
                InfoTile(
                  title: 'Batch',
                  value: batch.name,
                ),
                const SizedBox(height: 8),
                InfoTile(
                  title: 'Customer',
                  value: good.customer.name,
                ),
                const SizedBox(height: 8),
                InfoTile(
                  title: 'Nama Barang',
                  value: good.name,
                ),
                InfoTile(
                  title: 'Jalur',
                  value: good.transportMode,
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InfoTile(
                        title: 'No Invoice',
                        value: good.invoiceNumber,
                      ),
                    ),
                    Expanded(
                      child: InfoTile(
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
                Row(
                  children: [
                    Expanded(
                      child: InfoTile(
                        title: 'Tanggal Kirim',
                        value: batch.shipmentAt.toDDMMMMYYYY,
                      ),
                    ),
                    Expanded(
                      child: InfoTile(
                        title: 'Tanggal Terima',
                        value: batch.receiveAt == null
                            ? '-'
                            : batch.receiveAt!.toDDMMMMYYYY,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InfoTile(
                        title: 'Total Koli',
                        value: '${good.totalItem}',
                      ),
                    ),
                    Expanded(
                      child: InfoTile(
                        title: 'Status',
                        value: '${good.totalItem}',
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
                  itemBuilder: (context, index) {
                    final firstIndex = index * 2;
                    final secondIndex = firstIndex + 1;
                    final isOdd = secondIndex < good.uniqueCodes.length;

                    return Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            good.uniqueCodes[firstIndex],
                            style: label[medium].copyWith(color: black),
                          ),
                        ),
                        Expanded(
                          child: isOdd
                              ? Text(
                                  good.uniqueCodes[secondIndex],
                                  style: label[medium].copyWith(color: black),
                                )
                              : const SizedBox(),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemCount: (good.uniqueCodes.length / 2).ceil(),
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
