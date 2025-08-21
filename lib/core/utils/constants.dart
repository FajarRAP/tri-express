import 'package:flutter/services.dart';

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
  '/receive-goods',
  '/prepare-goods',
  '/inventory',
};

const inScannablePageMethod = 'inScannablePage';
const notInScannablePageMethod = 'notInScannablePage';
const handleInventoryButtonMethod = 'handleInventoryButton';
const getTagInfoMethod = 'getTagInfo';
const startInventoryMethod = 'startInventory';
const stopInventoryMethod = 'stopInventory';
const failedInventoryMethod = 'failedInventory';
