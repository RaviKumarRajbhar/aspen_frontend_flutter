import 'dart:async';

class RefreshCoordinator {

  bool isRefreshing = false;

  Completer<void>? completer;
}