import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/src/services/shared_prefernces.dart';




extension AutoDisposeRefCache on AutoDisposeRef{
  /* Keeps the provider alive since when it was first created
  * even if all the listeners are remove before then */
  void cacheFor(Duration duration){
    final link = keepAlive();
    final timer = Timer(duration, () => link.close());
    onDispose(() => timer.cancel());
  }
}

final loadingProvider = StateProvider.autoDispose<bool>((ref) => false);
final tokenProvider = FutureProvider<String?>((ref) async {
  String? token = await Preferences().getToken();
  return token;
});
