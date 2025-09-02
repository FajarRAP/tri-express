import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tri_express/core/routes/router.dart';

import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/notification_icon_button.dart';

class FilterPrepareGoodsPage extends StatefulWidget {
  const FilterPrepareGoodsPage({super.key});

  @override
  State<FilterPrepareGoodsPage> createState() => _FilterPrepareGoodsPageState();
}

class _FilterPrepareGoodsPageState extends State<FilterPrepareGoodsPage> {
  late final TextEditingController _batchNameController;

  @override
  void initState() {
    super.initState();
    _batchNameController = TextEditingController();
  }

  @override
  void dispose() {
    _batchNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const <Widget>[
          NotificationIconButton(),
          SizedBox(width: 16),
        ],
        title: const Text('Persiapan Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 24),
            GridView.count(
              childAspectRatio: 2.5 / 1,
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                DropdownButtonFormField(
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                    labelText: 'Gudang Asal',
                    hintText: 'Pilih gudang',
                  ),
                  items: <DropdownMenuItem>[
                    DropdownMenuItem(
                      value: 'A',
                      child: const Text('Gudang A'),
                    ),
                    DropdownMenuItem(
                      value: 'B',
                      child: const Text('Gudang B'),
                    ),
                    DropdownMenuItem(
                      value: 'C',
                      child: const Text('Gudang C'),
                    ),
                  ],
                ),
                DropdownButtonFormField(
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                    labelText: 'Gudang Tujuan',
                    hintText: 'Pilih gudang',
                  ),
                  items: <DropdownMenuItem>[
                    DropdownMenuItem(
                      value: 'A',
                      child: const Text('Gudang A'),
                    ),
                    DropdownMenuItem(
                      value: 'B',
                      child: const Text('Gudang B'),
                    ),
                    DropdownMenuItem(
                      value: 'C',
                      child: const Text('Gudang C'),
                    ),
                  ],
                ),
                DropdownButtonFormField(
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                    labelText: 'Jalur Pengiriman',
                    hintText: 'Pilih jalur',
                  ),
                  items: <DropdownMenuItem>[
                    DropdownMenuItem(
                      value: 'A',
                      child: const Text('Jalur A'),
                    ),
                    DropdownMenuItem(
                      value: 'B',
                      child: const Text('Jalur B'),
                    ),
                    DropdownMenuItem(
                      value: 'C',
                      child: const Text('Jalur C'),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _batchNameController,
                  decoration: const InputDecoration(
                    labelText: 'Batch',
                  ),
                ),
                TextFormField(
                  onTap: () => showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Pengiriman',
                    hintText: 'DD/MM/YYYY',
                    suffixIcon: Icon(Icons.calendar_month_outlined),
                  ),
                  readOnly: true,
                ),
                TextFormField(
                  onTap: () => showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Estimasi Tiba',
                    hintText: 'DD/MM/YYYY',
                    suffixIcon: Icon(Icons.calendar_month_outlined),
                  ),
                  readOnly: true,
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () => context.push(
                  prepareGoodsAddItemRoute,
                  extra: _batchNameController.text,
                ),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
