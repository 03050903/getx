import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/state_manager.dart';

int times = 3;
int get last => times - 1;

Future<String> valueNotifier() {
  final c = Completer<String>();
  final value = ValueNotifier<int>(0);
  final timer = Stopwatch();
  timer.start();

  value.addListener(() {
    if (last == value.value) {
      timer.stop();
      c.complete(
          """${value.value} listeners notified | [VALUENOTIFIER] objs time: ${timer.elapsedMicroseconds}ms""");
    }
  });

  for (var i = 0; i < times; i++) {
    value.value = i;
  }

  return c.future;
}

Future<String> getValue() {
  final c = Completer<String>();
  final value = Value<int>(0);
  final timer = Stopwatch();
  timer.start();

  value.addListener(() {
    if (last == value.value) {
      timer.stop();
      c.complete(
          """${value.value} listeners notified | [GETX VALUE] objs time: ${timer.elapsedMicroseconds}ms""");
    }
  });

  for (var i = 0; i < times; i++) {
    value.value = i;
  }

  return c.future;
}

Future<String> getStream() {
  final c = Completer<String>();

  final value = StreamController<int>();
  final timer = Stopwatch();
  timer.start();

  value.stream.listen((v) {
    if (last == v) {
      timer.stop();
      c.complete(
          """$v listeners notified | [STREAM] objs time: ${timer.elapsedMicroseconds}ms""");
    }
  });

  for (var i = 0; i < times; i++) {
    value.add(i);
  }

  return c.future;
}

void main() async {
  test('run benchmarks', () async {
    print(await getValue());
    print(await valueNotifier());
    print(await getStream());
    times = 30000;
    print(await getValue());
    print(await valueNotifier());
    print(await getStream());
  });
}

typedef VoidCallback = void Function();
