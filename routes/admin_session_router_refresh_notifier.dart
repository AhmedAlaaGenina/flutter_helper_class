import 'dart:async';

import 'package:admin_panel_standalone/features/auth/presentation/bloc/session/admin_session_bloc.dart';
import 'package:flutter/foundation.dart';

class AdminSessionRouterRefreshNotifier extends ChangeNotifier {
  AdminSessionRouterRefreshNotifier(this._sessionBloc) {
    _subscription = _sessionBloc.stream.listen((_) => notifyListeners());
    Future<void>.microtask(notifyListeners);
  }

  final AdminSessionBloc _sessionBloc;
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
