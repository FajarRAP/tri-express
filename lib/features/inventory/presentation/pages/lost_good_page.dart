import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/states.dart';
import '../../../../core/widgets/base_card.dart';
import '../../domain/entities/lost_good_entity.dart';
import '../../domain/entities/timeline_summary_entity.dart';
import '../cubit/shipment_cubit.dart';
import '../widgets/info_tile.dart';
import '../widgets/timeline_indicator.dart';

class LostGoodPage extends StatelessWidget {
  const LostGoodPage({
    super.key,
    required this.lostGood,
  });

  final LostGoodEntity lostGood;

  @override
  Widget build(BuildContext context) {
    final shipmentCubit = context.read<ShipmentCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Barang'),
      ),
      body: BlocBuilder<ShipmentCubit, ReusableState>(
        bloc: shipmentCubit
          ..fetchGoodTimeline(receiptNumber: lostGood.receiptNumber),
        builder: (context, state) {
          if (state is Loading<TimelineSummaryEntity>) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (state is Loaded<TimelineSummaryEntity>) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Details
                BaseCard(
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
                          const SizedBox(width: 24),
                          Expanded(
                            child: determineBadge(
                              lostGood.status ?? -1,
                              lostGood.statusLabel ?? '-',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      InfoTile(
                        title: 'Customer',
                        value: lostGood.customer.name,
                      ),
                      const SizedBox(height: 8),
                      InfoTile(
                        title: 'Nama Barang',
                        value: lostGood.name,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: InfoTile(
                              isCopyable: true,
                              title: 'No Invoice',
                              value: lostGood.invoiceNumber,
                            ),
                          ),
                          Expanded(
                            child: InfoTile(
                              isCopyable: true,
                              title: 'No Resi',
                              value: lostGood.receiptNumber,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: InfoTile(
                              title: 'Tanggal Invoice',
                              value: lostGood.issuedAt.toDDMMMYYY,
                            ),
                          ),
                          Expanded(
                            child: InfoTile(
                              title: 'Usia Barang',
                              value:
                                  '${lostGood.issuedAt.dayDiffenrences} Hari',
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
                              value: lostGood.origin.name,
                            ),
                          ),
                          Expanded(
                            child: InfoTile(
                              title: 'Gudang Akhir',
                              value: lostGood.destination.name,
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
                              value: '${lostGood.totalItem}',
                            ),
                          ),
                          Expanded(
                            child: InfoTile(
                              title: 'Gudang Sekarang',
                              value: lostGood.currentWarehouse.name,
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
                          final isOdd =
                              secondIndex < lostGood.allUniqueCodes.length;

                          return Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  lostGood.allUniqueCodes[firstIndex],
                                  style: label[medium].copyWith(color: black),
                                ),
                              ),
                              Expanded(
                                child: isOdd
                                    ? Text(
                                        lostGood.allUniqueCodes[secondIndex],
                                        style: label[medium]
                                            .copyWith(color: black),
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemCount: (lostGood.allUniqueCodes.length / 2).ceil(),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Timeline
                BaseCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Status',
                        style: paragraphSmall[heavy].copyWith(
                          color: black,
                        ),
                      ),
                      Text(
                        'Status: ${lostGood.statusLabel ?? '-'}',
                        style: label[regular].copyWith(color: black),
                      ),
                      const SizedBox(height: 24),
                      ListView.builder(
                        itemBuilder: (context, index) => IntrinsicHeight(
                          child: TimelineIndicator(
                            timeline: state.data.timelines[index],
                            isLast: index == state.data.timelines.length - 1,
                          ),
                        ),
                        itemCount: state.data.timelines.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
