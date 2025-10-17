import 'package:flutter/services.dart';

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
const forceStopInventoryMethod = 'forceStopInventory';

const kSpaceBarHeight = 88.0;

const imagePath = 'assets/images';
const onboardingImagePath = '$imagePath/onboarding-bg.jpg';
const loginImagePath = '$imagePath/login-bg.png';
const logoTextImagePath = '$imagePath/logo-text.png';
const logoImagePath = '$imagePath/logo.png';

const superAdminRole = 'superadmin';

const boxSvgPath = 'assets/svgs/box.svg';
const boxAddSvgPath = 'assets/svgs/box-add.svg';
const truckSvgPath = 'assets/svgs/truck.svg';
const helmetSvgPath = 'assets/svgs/helmet.svg';
const resetSvgPath = 'assets/svgs/reset.svg';
const saveSvgPath = 'assets/svgs/save.svg';
const sendSvgPath = 'assets/svgs/send.svg';
const homeSvgPath = 'assets/svgs/home.svg';
const truckAltSvgPath = 'assets/svgs/truck-alt.svg';
const qrScannerSvgPath = 'assets/svgs/qr-scanner.svg';
const boxAltSvgPath = 'assets/svgs/box-alt.svg';
const settingSvgPath = 'assets/svgs/setting.svg';
const connectionOffSvgPath = 'assets/svgs/connection-off.svg';
const connectionOnSvgPath = 'assets/svgs/connection-on.svg';
