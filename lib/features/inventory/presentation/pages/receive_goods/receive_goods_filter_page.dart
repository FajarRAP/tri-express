import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/router.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/dropdowns/warehouse_dropdown.dart';
import '../../../../core/domain/entities/dropdown_entity.dart';

class ReceiveGoodsFilterPage extends StatefulWidget {
  const ReceiveGoodsFilterPage({super.key});

  @override
  State<ReceiveGoodsFilterPage> createState() => _ReceiveGoodsFilterPageState();
}

class _ReceiveGoodsFilterPageState extends State<ReceiveGoodsFilterPage> {
  late final TextEditingController _dateController;
  late final TextEditingController _warehouseController;
  DropdownEntity? _selectedWarehouse;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _warehouseController = TextEditingController();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _warehouseController.dispose();
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
            TextFormField(
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (context) => WarehouseDropdown(
                  onTap: (warehouse) {
                    _warehouseController.text = warehouse.value;
                    setState(() => _selectedWarehouse = warehouse);
                    context.pop();
                  },
                  titleSuffix: 'Asal',
                ),
              ),
              controller: _warehouseController,
              decoration: const InputDecoration(
                labelText: 'Pilih Gudang Asal',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'DD MM YYYY',
                labelText: 'Tanggal Terima',
                suffixIcon: Icon(Icons.calendar_month),
              ),
              initialValue: DateTime.now().toDDMMMMYYYY,
              readOnly: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: _selectedWarehouse == null
                    ? null
                    : () => context.push(receiveGoodsScanRoute),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
