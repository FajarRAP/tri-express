import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../features/inventory/domain/entities/batch_entity.dart';
import '../../features/inventory/domain/entities/good_entity.dart';
import '../../features/inventory/domain/entities/warehouse_entity.dart';
import '../routes/router.dart';

const apiUrl = String.fromEnvironment('API_URL');
const accessTokenKey = String.fromEnvironment('ACCESS_TOKEN_KEY');
const refreshTokenKey = String.fromEnvironment('REFRESH_TOKEN_KEY');
const onboardingKey = String.fromEnvironment('ONBOARDING_KEY');

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
  '$receiveGoodsRoute$scanReceiveGoodsRoute',
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

const dropdownItems = <DropdownMenuItem>[
  DropdownMenuItem(value: 'A', child: Text('Item A')),
  DropdownMenuItem(value: 'B', child: Text('Item B')),
  DropdownMenuItem(value: 'C', child: Text('Item C')),
  DropdownMenuItem(value: 'D', child: Text('Item D')),
  DropdownMenuItem(value: 'E', child: Text('Item E')),
];

const imagePath = 'assets/images';
const onboardingImagePath = '$imagePath/onboarding-bg.jpg';
const loginImagePath = '$imagePath/login-bg.png';
const logoTextImagePath = '$imagePath/logo-text.png';

const superAdminRole = 'superadmin';

final _warehouse = WarehouseEntity(
  id: 'id',
  countryId: 'countryId',
  address: 'address',
  description: 'description',
  latitude: 'latitude',
  longitude: 'longitude',
  name: 'name',
  phone: 'phone',
  warehouseCode: 'warehouseCode',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
final batch = BatchEntity(
  id: 'id',
  name: 'name',
  status: 'status',
  trackingNumber: 'trackingNumber',
  goods: [
    for (var i = 0; i < 3; i++)
      GoodEntity(
        id: 'id-$i',
        name: 'name-$i',
        receiptNumber: 'TRI.2507231450302$i',
      )
  ],
  origin: _warehouse,
  destination: _warehouse,
  sendAt: DateTime.now(),
);
