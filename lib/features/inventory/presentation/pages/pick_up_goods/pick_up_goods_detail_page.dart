import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/fonts/fonts.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/widgets/base_card.dart';
import '../../../domain/entities/picked_good_entity.dart';
import '../../widgets/info_tile.dart';

class PickUpGoodsDetailPage extends StatelessWidget {
  const PickUpGoodsDetailPage({
    super.key,
    required this.pickedGood,
  });

  final PickedGoodEntity pickedGood;

  @override
  Widget build(BuildContext context) {
    return _Tari(pickedGood: pickedGood);
    return _Gemini(pickedGood: pickedGood);
    return _Claude(pickedGood: pickedGood);
  }
}

class _Tari extends StatelessWidget {
  const _Tari({required this.pickedGood});
  final PickedGoodEntity pickedGood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barang Yang Diambil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              BaseCard(
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
                      value: pickedGood.name,
                    ),
                    const SizedBox(height: 8),
                    InfoTile(
                      title: 'Tanggal Selesai',
                      value: pickedGood.deliveredAt.toDDMMMMYYYY,
                    ),
                    const SizedBox(height: 8),
                    InfoTile(
                      title: 'Customer',
                      value: pickedGood.customer.name,
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: InfoTile(
                            isCopyable: true,
                            title: 'No Invoice',
                            value: pickedGood.invoiceNumber,
                          ),
                        ),
                        Expanded(
                          child: InfoTile(
                            isCopyable: true,
                            title: 'No Resi',
                            value: pickedGood.receiptNumber,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Barang yang Diambil',
                      style: TextStyle(fontSize: 12, color: gray),
                    ),
                    ListView.separated(
                      itemBuilder: (context, index) {
                        final firstIndex = index * 2;
                        final secondIndex = firstIndex + 1;
                        final isOdd =
                            secondIndex >= pickedGood.uniqueCodes.length;

                        return Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                pickedGood.uniqueCodes[firstIndex],
                                style: label[medium].copyWith(color: black),
                              ),
                            ),
                            Expanded(
                              child: isOdd
                                  ? const SizedBox()
                                  : Text(
                                      pickedGood.uniqueCodes[secondIndex],
                                      style:
                                          label[medium].copyWith(color: black),
                                    ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemCount: (pickedGood.uniqueCodes.length / 2).ceil(),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              BaseCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Foto',
                      style: paragraphSmall[heavy].copyWith(
                        color: black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Image.network(
                      pickedGood.photoUrl,
                      height: 150,
                      width: 150,
                    ),
                    const SizedBox(height: 6),
                    InfoTile(
                      title: 'Catatan',
                      value: pickedGood.note,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Gemini extends StatelessWidget {
  const _Gemini({required this.pickedGood});

  final PickedGoodEntity pickedGood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Barang'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildItemHeader(),
            const SizedBox(height: 24),
            _buildKeyInfo(),
            const SizedBox(height: 24),
            _buildDetailsCard(),
            const SizedBox(height: 24),
            _buildUniqueCodesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildItemHeader() {
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            pickedGood.photoUrl,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.image_not_supported_rounded,
              size: 100,
              color: graySecondary,
            ),
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          pickedGood.name,
          textAlign: TextAlign.center,
          style: heading5[regular].copyWith(color: black),
        ),
        const SizedBox(height: 4),
        Text(
          'Selesai pada ${pickedGood.deliveredAt.toDDMMMMYYYY}',
          textAlign: TextAlign.center,
          style: label[medium].copyWith(color: gray),
        ),
      ],
    );
  }

  Widget _buildKeyInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: primary200),
        borderRadius: BorderRadius.circular(12),
        color: primary50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: _buildCopyableInfo(
              'No. Resi',
              pickedGood.receiptNumber,
            ),
          ),
          const SizedBox(
            height: 40,
            child: VerticalDivider(color: graySecondary),
          ),
          Expanded(
            child: _buildCopyableInfo(
              'No. Invoice',
              pickedGood.invoiceNumber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableInfo(String title, String value) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: label[regular].copyWith(color: gray),
        ),
        const SizedBox(height: 4),
        Row(
          children: <Widget>[
            Expanded(
                child:
                    Text(value, style: label[semibold].copyWith(color: black))),
            IconButton(
              onPressed: () => Clipboard.setData(ClipboardData(text: value)),
              icon: const Icon(Icons.copy_rounded, color: primary, size: 18),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InfoTile(
              title: 'Customer',
              value: pickedGood.customer.name,
            ),
            const Divider(height: 24, thickness: 0.5, color: graySecondary),
            InfoTile(
              title: 'Catatan Pengiriman',
              value: pickedGood.note.isEmpty ? '-' : pickedGood.note,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUniqueCodesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Kode Unik Barang',
          style: paragraphSmall[semibold].copyWith(color: black),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: pickedGood.uniqueCodes.map((code) {
            return Chip(
              backgroundColor: primary50,
              label: Text(code),
              labelStyle: label[medium].copyWith(color: primary800),
              side: const BorderSide(color: primary200),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _Claude extends StatelessWidget {
  const _Claude({required this.pickedGood});

  final PickedGoodEntity pickedGood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Barang Diambil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section - Item Name & Status
            _buildHeroSection(),

            // Customer & Invoice Info Cards
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                _buildInfoCard(
                  title: 'Customer',
                  value: pickedGood.customer.name,
                  icon: Icons.person_outline,
                  color: Colors.blue,
                ),
                _buildInfoCard(
                  title: 'Items',
                  value: '${pickedGood.uniqueCodes.length} pcs',
                  icon: Icons.inventory_2_outlined,
                  color: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Invoice & Receipt Numbers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildCopyableCard(
                      title: 'No Invoice',
                      value: pickedGood.invoiceNumber,
                      icon: Icons.receipt_long,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildCopyableCard(
                      title: 'No Resi',
                      value: pickedGood.receiptNumber,
                      icon: Icons.local_shipping_outlined,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Items Grid
            _buildUniqueCodesGrid(),

            const SizedBox(height: 24),

            // Photo & Notes Section
            _buildPhotoAndNoteSection(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Container _buildPhotoAndNoteSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.photo_camera_outlined,
                  color: Colors.grey.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Foto Pengiriman',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    pickedGood.photoUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (pickedGood.note.isNotEmpty) ...[
              Row(
                children: [
                  Icon(
                    Icons.note_outlined,
                    color: Colors.grey.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Catatan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.amber.shade200,
                    width: 1,
                  ),
                ),
                child: Text(
                  pickedGood.note,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Container _buildUniqueCodesGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.qr_code,
                  color: Colors.grey.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Kode Barang (${pickedGood.uniqueCodes.length})',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: pickedGood.uniqueCodes.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      pickedGood.uniqueCodes[index],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Container _buildHeroSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withValues(alpha: .1),
            offset: const Offset(0, 8),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
        ),
      ),
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'SELESAI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              pickedGood.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Diselesaikan ${pickedGood.deliveredAt.toDDMMMMYYYY}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: .9),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withValues(alpha: .05),
            offset: const Offset(0, 4),
          ),
        ],
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.grey.shade600,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Clipboard.setData(ClipboardData(text: value)),
                child: Icon(
                  Icons.copy,
                  color: Colors.grey.shade500,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
