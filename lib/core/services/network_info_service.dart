import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class NetworkInfoService {
  Future<bool> get hasInternet;
  Stream<bool> get onInternetStatusChange;
}

class NetworkInfoServiceImpl implements NetworkInfoService {
  const NetworkInfoServiceImpl({required this.internetConnection});

  final InternetConnection internetConnection;

  @override
  Future<bool> get hasInternet => internetConnection.hasInternetAccess;

  @override
  Stream<bool> get onInternetStatusChange => internetConnection.onStatusChange
      .map((event) => event == InternetStatus.connected);
}
