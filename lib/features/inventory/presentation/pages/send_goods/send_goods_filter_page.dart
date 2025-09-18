import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/router.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/dropdowns/driver_dropdown.dart';
import '../../../../../core/widgets/dropdowns/warehouse_dropdown.dart';
import '../../../../../core/widgets/notification_icon_button.dart';
import '../../../../core/domain/entities/dropdown_entity.dart';

class SendGoodsFilterPage extends StatefulWidget {
  const SendGoodsFilterPage({super.key});

  @override
  State<SendGoodsFilterPage> createState() => _SendGoodsFilterPageState();
}

class _SendGoodsFilterPageState extends State<SendGoodsFilterPage> {
  late final TextEditingController _driverController;
  late final TextEditingController _warehouseController;
  DropdownEntity? _selectedWarehouse;
  DropdownEntity? _selectedDriver;

  @override
  void initState() {
    super.initState();
    _driverController = TextEditingController();
    _warehouseController = TextEditingController();
  }

  @override
  void dispose() {
    _driverController.dispose();
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
        title: const Text('Kirim Barang'),
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
                  titleSuffix: 'Tujuan',
                ),
              ),
              controller: _warehouseController,
              decoration: const InputDecoration(
                hintText: 'Pilih Gudang Tujuan',
                labelText: 'Pilih Gudang Tujuan',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (context) => DriverDropdown(
                  onTap: (driver) {
                    _driverController.text = driver.value;
                    setState(() => _selectedDriver = driver);
                    context.pop();
                  },
                ),
              ),
              controller: _driverController,
              decoration: const InputDecoration(
                hintText: 'Pilih Kurir Gudang',
                labelText: 'Pilih Kurir Gudang',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'DD MM YYYY',
                labelText: 'Tanggal Kirim',
                suffixIcon: Icon(Icons.calendar_month_outlined),
              ),
              initialValue: DateTime.now().toDDMMMMYYYY,
              readOnly: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: _selectedDriver == null || _selectedWarehouse == null
                    ? null
                    : () => context.push(sendGoodsScanRoute),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
