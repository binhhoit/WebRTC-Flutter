
import 'dart:async';

import 'package:rxdart/rxdart.dart';

class SubscriptionHandler {
  CompositeSubscription compositeDisposable = CompositeSubscription();

  void addSubscription<T>(Stream<T> stream,
      {Function? onStart,
        Function(T)? onSuccess,
        Function? onError,
        Function? onDone,
        bool cancelOnError = false}) {
    if (onStart != null) onStart();
    StreamSubscription<T> subscription = stream.listen(onSuccess, cancelOnError: cancelOnError);
    compositeDisposable.add(subscription);
    subscription.onError(onError);
    subscription.onDone(() {
      compositeDisposable.remove(subscription);
      if (onDone != null) onDone();
    });
  }

  void dispose() {
    compositeDisposable.dispose();
  }
}