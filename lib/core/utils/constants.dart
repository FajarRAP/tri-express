import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../features/inventory/domain/entities/batch_entity.dart';
import '../../features/inventory/domain/entities/customer_entity.dart';
import '../../features/inventory/domain/entities/good_entity.dart';
import '../../features/inventory/domain/entities/warehouse_entity.dart';
import '../routes/router.dart';

const apiUrl = String.fromEnvironment('API_URL');
const accessTokenKey = String.fromEnvironment('ACCESS_TOKEN_KEY');
const refreshTokenKey = String.fromEnvironment('REFRESH_TOKEN_KEY');
const onboardingKey = String.fromEnvironment('ONBOARDING_KEY');

const platform = MethodChannel('com.example.tri_express/channel');

const scannablePage = <String>{
  receiveGoodsScanRoute,
  prepareGoodsScanRoute,
  pickUpGoodsScanRoute,
  sendGoodsScanRoute,
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

const _customer = CustomerEntity(
  id: 'id',
  code: 'code',
  address: 'address',
  name: 'name',
  phoneNumber: 'phoneNumber',
);

final _good = GoodEntity(
  id: 'id',
  receiptNumber: 'receiptNumber',
  invoiceNumber: 'invoiceNumber',
  name: 'name',
  transportMode: 'transportMode',
  totalItem: 1,
  customer: _customer,
  origin: _warehouse,
  destination: _warehouse,
  uniqueCodes: [],
);

final goods = [for (var i = 0; i < 20; i++) _good];
final batch = BatchEntity(
  id: 'id',
  name: 'name',
status: 1,
  statusLabel: 'status',
  trackingNumber: 'trackingNumber',
  transportMode: 'Darat',
  receivedUnits: 1,
  preparedUnits: 1,
  deliveredUnits: 1,
  totalAllUnits: 1,
  goods: goods,
  origin: _warehouse,
  destination: _warehouse,
  deliveredAt: DateTime.now(),
  estimateAt: DateTime.now(),
  receivedAt: DateTime.now(),
  shippedAt: DateTime.now(),
);
