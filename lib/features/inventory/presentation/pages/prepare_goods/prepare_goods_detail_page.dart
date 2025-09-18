import 'package:flutter/material.dart';

import '../../../../../core/fonts/fonts.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/widgets/base_card.dart';
import '../../../domain/entities/good_entity.dart';
import '../../../domain/entities/warehouse_entity.dart';
import '../../widgets/info_tile.dart';

class PrepareGoodsDetailPage extends StatelessWidget {
  const PrepareGoodsDetailPage({
    super.key,
    required this.batchName,
    required this.good,
    required this.nextWarehouse,
    required this.estimateAt,
    required this.shipmentAt,
  });

  final String batchName;
  final GoodEntity good;
  final WarehouseEntity nextWarehouse;
  final DateTime estimateAt;
  final DateTime shipmentAt;

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
                        title: 'Tanggal Pengiriman',
                        value: shipmentAt.toDDMMMMYYYY,
                      ),
                    ),
                    Expanded(
                      child: InfoTile(
                        title: 'Estimasi Tiba',
                        value: estimateAt.toDDMMMMYYYY,
                      ),
                    ),
                  ],
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
                        title: 'Gudang Tujuan',
                        value: nextWarehouse.name,
                      ),
                    ),
                    Expanded(
                      child: InfoTile(
                        title: 'Gudang Tujuan Akhir',
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
