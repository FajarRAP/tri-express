import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/router.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/dropdowns/transport_mode_dropdown.dart';
import '../../../../../core/widgets/dropdowns/warehouse_dropdown.dart';
import '../../../../../core/widgets/notification_icon_button.dart';
import '../../../../core/domain/entities/dropdown_entity.dart';

class PrepareGoodsFilterPage extends StatefulWidget {
  const PrepareGoodsFilterPage({super.key});

  @override
  State<PrepareGoodsFilterPage> createState() => _PrepareGoodsFilterPageState();
}

class _PrepareGoodsFilterPageState extends State<PrepareGoodsFilterPage> {
  late final TextEditingController _batchNameController;
  late final TextEditingController _estimateDateController;
  late final TextEditingController _transportModeController;
  late final TextEditingController _warehouseController;
  DropdownEntity? _selectedTransportMode;
  DropdownEntity? _selectedWarehouse;

  @override
  void initState() {
    super.initState();
    _batchNameController = TextEditingController(text: 'NAMA BATCHNYA');
    _estimateDateController = TextEditingController();
    _transportModeController = TextEditingController();
    _warehouseController = TextEditingController();
  }

  @override
  void dispose() {
    _batchNameController.dispose();
    _estimateDateController.dispose();
    _transportModeController.dispose();
    _warehouseController.dispose();
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
            TextFormField(
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (context) => WarehouseDropdown(
                  onTap: (warehouse) {
                    _warehouseController.text = warehouse.value;
                    setState(() => _selectedWarehouse = warehouse);
                    context.pop();
                  },
                ),
              ),
              controller: _warehouseController,
              decoration: const InputDecoration(
                labelText: 'Pilih Gudang Asal',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 12),
            TextFormField(
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (context) => TransportModeDropdown(
                  onTap: (transportMode) {
                    _transportModeController.text = transportMode.value;
                    setState(() => _selectedTransportMode = transportMode);
                    context.pop();
                  },
                ),
              ),
              controller: _transportModeController,
              decoration: const InputDecoration(
                labelText: 'Pilih Jalur Pengiriman',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'DD MM YYYY',
                labelText: 'Tanggal Terima',
                suffixIcon: Icon(Icons.calendar_month),
              ),
              initialValue: DateTime.now().toDDMMMMYYYY,
              readOnly: true,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'DD MM YYYY',
                labelText: 'Estimasi Tiba',
                suffixIcon: Icon(Icons.calendar_month),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _batchNameController,
              decoration: const InputDecoration(
                labelText: 'Batch',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed:
                    _selectedWarehouse == null || _selectedTransportMode == null
                        ? null
                        : () => context.push(
                              prepareGoodsScanRoute,
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
