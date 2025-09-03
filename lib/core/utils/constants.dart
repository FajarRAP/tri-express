import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../features/inventory/domain/entity/batch_entity.dart';
import '../routes/router.dart';

const shipmentPath = <String, dynamic>{
  '1': 'Darat',
  '2': 'Laut',
  '3': 'Udara',
  '4': 'Kereta'
};
const shipmentStatus = <String, dynamic>{
  '1': 'Selesai',
  '2': 'Sedang Dikirim',
  '3': 'Terjadwal'
};

const platform = MethodChannel('com.example.tri_express/channel');

const scannablePage = <String>{
  receiveGoodsRoute,
  prepareGoodsRoute,
  inventoryRoute,
};

const inScannablePageMethod = 'inScannablePage';
const notInScannablePageMethod = 'notInScannablePage';
const handleInventoryButtonMethod = 'handleInventoryButton';
const getTagInfoMethod = 'getTagInfo';
const startInventoryMethod = 'startInventory';
const stopInventoryMethod = 'stopInventory';
const failedInventoryMethod = 'failedInventory';

const kSpaceBarHeight = 88.0;

final batch = BatchEntity(
    id: '-',
    batch: 'Batch 100',
    destination: 'Yogyakarta',
    itemCount: 100,
    origin: 'Bandung',
    path: 'Darat',
    sendAt: DateTime.now(),
    status: 'Diterima',
    isChecked: false);

const dropdownItems = <DropdownMenuItem>[
  DropdownMenuItem(value: 'A', child: Text('Item A')),
  DropdownMenuItem(value: 'B', child: Text('Item B')),
  DropdownMenuItem(value: 'C', child: Text('Item C')),
  DropdownMenuItem(value: 'D', child: Text('Item D')),
  DropdownMenuItem(value: 'E', child: Text('Item E')),
];

const imagePath = 'assets/images';
const onboardingImagePath = '$imagePath/onboarding-bg.jpg';
const loginImagePath = '$imagePath/login-bg.jpg';
const logoTextImagePath = '$imagePath/logo-text.png';
