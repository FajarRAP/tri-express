import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/services/network_info_service.dart';

class InternetCubit extends Cubit<bool> {
  InternetCubit(this._networkInfoService) : super(false) {
    _internetSubscription =
        _networkInfoService.onInternetStatusChange.listen(emit);
  }

  final NetworkInfoService _networkInfoService;

  late final StreamSubscription _internetSubscription;

  @override
  Future<void> close() {
    _internetSubscription.cancel();
    return super.close();
  }
}
