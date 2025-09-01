import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/routes/router.dart';
import '../../../../core/widgets/buttons/primary_button.dart';

class FilterReceivedGoodsPage extends StatefulWidget {
  const FilterReceivedGoodsPage({super.key});

  @override
  State<FilterReceivedGoodsPage> createState() =>
      _FilterReceivedGoodsPageState();
}

class _FilterReceivedGoodsPageState extends State<FilterReceivedGoodsPage> {
  late final TextEditingController _dateController;
  DateTime? _pickedDate;
  String? _selectedWarehouse;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terima Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField<String>(
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedWarehouse = value);
              },
              decoration: const InputDecoration(
                hintText: 'Pilih gudang asal',
                labelText: 'Gudang Asal',
              ),
              items: const <DropdownMenuItem<String>>[
                DropdownMenuItem(
                  value: 'A',
                  child: Text('Gudang A'),
                ),
                DropdownMenuItem(
                  value: 'B',
                  child: Text('Gudang B'),
                ),
                DropdownMenuItem(
                  value: 'C',
                  child: Text('Gudang C'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );

                if (pickedDate == null) return;
                setState(() {
                  _pickedDate = pickedDate;
                  _dateController.text =
                      DateFormat('dd/MM/yyyy').format(pickedDate);
                });
              },
              controller: _dateController,
              decoration: const InputDecoration(
                hintText: 'DD/MM/YYYY',
                labelText: 'Tanggal Terima',
              ),
              readOnly: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: _selectedWarehouse == null || _pickedDate == null
                    ? null
                    : () => context.push(receiveGoodsRoute),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
