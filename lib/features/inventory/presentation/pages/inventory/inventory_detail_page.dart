import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/fonts/fonts.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/helpers.dart';
import '../../../../../../core/widgets/base_card.dart';
import '../../../domain/entities/batch_entity.dart';
import '../../../domain/entities/good_entity.dart';
import '../../cubit/inventory_cubit.dart';
import '../../widgets/info_tile.dart';
import '../../widgets/timeline_indicator.dart';

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
    return Tari(batch: batch, good: good);
    return _Gemini(batch: batch, good: good);
    return _Claude(batch: batch, good: good);
  }
}

class Tari extends StatelessWidget {
  const Tari({
    super.key,
    required this.batch,
    required this.good,
  });

  final BatchEntity batch;
  final GoodEntity good;

  @override
  Widget build(BuildContext context) {
    final inventoryCubit = context.read<InventoryCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Barang'),
      ),
      body: BlocBuilder<InventoryCubit, InventoryState>(
        bloc: inventoryCubit
          ..fetchGoodTimeline(receiptNumber: good.receiptNumber),
        buildWhen: (previous, current) => current is FetchGoodTimeline,
        builder: (context, state) {
          if (state is FetchGoodTimelineLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (state is FetchGoodTimelineLoaded) {
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
                              good.status ?? batch.status,
                              good.statusLabel ?? batch.statusLabel,
                            ),
                          ),
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
                      Row(
                        children: [
                          Expanded(
                            child: InfoTile(
                              title: 'Tanggal Kirim',
                              value: batch.deliveredAt?.toDDMMMYYY ??
                                  batch.shippedAt.toDDMMMYYY,
                            ),
                          ),
                          Expanded(
                            child: InfoTile(
                              title: 'Tanggal Terima',
                              value: batch.receivedAt == null
                                  ? '-'
                                  : batch.receivedAt!.toDDMMMYYY,
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
                              value: good.statusLabel ?? batch.statusLabel,
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
                        itemCount: (good.uniqueCodes.length / 2).ceil(),
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
                        'Status: ${good.statusLabel ?? batch.statusLabel}',
                        style: label[regular].copyWith(color: black),
                      ),
                      const SizedBox(height: 24),
                      ListView.builder(
                        itemBuilder: (context, index) => IntrinsicHeight(
                          child: TimelineIndicator(
                            timeline: state.timeline.timelines[index],
                            isLast:
                                index == state.timeline.timelines.length - 1,
                          ),
                        ),
                        itemCount: state.timeline.timelines.length,
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

class _Gemini extends StatelessWidget {
  const _Gemini({
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
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[100], // Beri sedikit warna latar
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // BAGIAN 1: INFORMASI UTAMA
            _buildMainInfoSection(context),
            const SizedBox(height: 16),

            // BAGIAN 2: DETAIL PENGIRIMAN
            _buildShipmentDetailsSection(context),
            const SizedBox(height: 16),

            // BAGIAN 3: INFORMASI KOLI
            _buildKoliSection(context),
          ],
        ),
      ),
    );
  }

  // Widget builder untuk informasi utama
  Widget _buildMainInfoSection(BuildContext context) {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Informasi Utama',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: determineBadge(
                  good.status ?? batch.status,
                  good.statusLabel ?? batch.statusLabel,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          InfoTile(title: 'Nama Barang', value: good.name),
          const SizedBox(height: 8),
          InfoTile(title: 'Customer', value: good.customer.name),
          const SizedBox(height: 8),
          InfoTile(title: 'Batch', value: batch.name),
        ],
      ),
    );
  }

  // Widget builder untuk detail pengiriman
  Widget _buildShipmentDetailsSection(BuildContext context) {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail Pengiriman',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.receipt_long_outlined,
            leftTitle: 'No. Invoice',
            leftValue: good.invoiceNumber,
            rightTitle: 'No. Resi',
            rightValue: good.receiptNumber,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.warehouse_outlined,
            leftTitle: 'Gudang Awal',
            leftValue: good.origin.name,
            rightTitle: 'Gudang Tujuan',
            rightValue: good.destination.name,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            leftTitle: 'Tanggal Kirim',
            leftValue:
                batch.deliveredAt?.toDDMMMYYY ?? batch.shippedAt.toDDMMMYYY,
            rightTitle: 'Tanggal Terima',
            rightValue: batch.receivedAt?.toDDMMMYYY ?? '-',
          ),
        ],
      ),
    );
  }

  // Widget builder untuk rincian koli
  Widget _buildKoliSection(BuildContext context) {
    return BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Informasi Koli',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text('Total: ', style: Theme.of(context).textTheme.bodySmall),
              Text(
                '${good.totalItem}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 24),
          if (good.uniqueCodes.isEmpty)
            const Center(child: Text('Tidak ada kode unik.'))
          else
            // Menggunakan Wrap agar lebih responsif dan modern
            Wrap(
              spacing: 8.0, // Jarak horizontal antar chip
              runSpacing: 4.0, // Jarak vertikal antar baris
              children: good.uniqueCodes.map((code) {
                return Chip(
                  label: Text(code),
                  backgroundColor: Colors.blue.shade50,
                  labelStyle: TextStyle(
                      color: Colors.blue.shade800, fontWeight: FontWeight.w500),
                  side: BorderSide(color: Colors.blue.shade200),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // Helper widget untuk membuat baris info dengan ikon
  Widget _buildInfoRow({
    required IconData icon,
    required String leftTitle,
    required String leftValue,
    required String rightTitle,
    required String rightValue,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(width: 12),
        Expanded(child: InfoTile(title: leftTitle, value: leftValue)),
        const SizedBox(width: 8),
        Expanded(child: InfoTile(title: rightTitle, value: rightValue)),
      ],
    );
  }
}

class _Claude extends StatelessWidget {
  const _Claude({
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
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan status badge
              _buildHeaderSection(),

              const SizedBox(height: 16),

              // Informasi Utama Barang
              _buildMainInfoSection(),

              const SizedBox(height: 16),

              // Informasi Pengiriman
              _buildShippingInfoSection(),

              const SizedBox(height: 16),

              // Informasi Tanggal & Status
              _buildStatusSection(),

              const SizedBox(height: 16),

              // Daftar Koli
              _buildPackageListSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return BaseCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      good.name,
                      style: heading5[bold].copyWith(
                        color: black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Batch: ${batch.name}',
                      style: label[regular].copyWith(
                        color: gray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: determineBadge(
                    good.status ?? batch.status,
                    good.statusLabel ?? batch.statusLabel,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfoSection() {
    return BaseCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Barang',
              style: paragraphSmall[heavy].copyWith(
                color: black,
              ),
            ),
            const SizedBox(height: 12),
            InfoTile(
              title: 'Customer',
              value: good.customer.name,
              // icon: Icons.business,
            ),
            const Divider(height: 24),
            InfoTile(
              title: 'Mode Transportasi',
              value: good.transportMode,
              // icon: Icons.local_shipping,
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: InfoTile(
                    title: 'No Invoice',
                    value: good.invoiceNumber,
                    // icon: Icons.receipt_long,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InfoTile(
                    title: 'No Resi',
                    value: good.receiptNumber,
                    // icon: Icons.local_post_office,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingInfoSection() {
    return BaseCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rute Pengiriman',
              style: paragraphSmall[heavy].copyWith(
                color: black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Origin
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.warehouse,
                          color: Colors.blue.shade600,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Gudang Asal',
                        style: TextStyle(
                          color: gray,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        good.origin.name,
                        style: label[semibold].copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Arrow
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.green.shade600,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        good.transportMode,
                        style: TextStyle(
                          color: Colors.green.shade600,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Destination
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.warehouse,
                          color: Colors.green.shade600,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Gudang Tujuan',
                        style: TextStyle(
                          fontSize: 12,
                          color: gray,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        good.destination.name,
                        style: label[semibold].copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    return BaseCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Pengiriman',
              style: paragraphSmall[heavy].copyWith(
                color: black,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDateInfo(
                    'Tanggal Kirim',
                    batch.deliveredAt?.toDDMMMYYY ?? batch.shippedAt.toDDMMMYYY,
                    Icons.flight_takeoff,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateInfo(
                    'Tanggal Terima',
                    batch.receivedAt?.toDDMMMYYY ?? 'Belum diterima',
                    Icons.flight_land,
                    batch.receivedAt != null ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.inventory_2,
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Koli',
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${good.totalItem} koli',
                          style: paragraphSmall[bold].copyWith(
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo(String text, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                text,
                style: TextStyle(
                  color: color.withValues(alpha: .8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: label[semibold].copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageListSection() {
    return BaseCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.qr_code,
                  color: Colors.purple.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Daftar Koli (${good.uniqueCodes.length} koli)',
                  style: paragraphSmall[heavy].copyWith(
                    color: black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: good.uniqueCodes.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.purple.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 14,
                          color: Colors.purple.shade600,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            good.uniqueCodes[index],
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.purple.shade800,
                                    ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


