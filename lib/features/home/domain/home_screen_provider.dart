import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tabControllerProvider =
    NotifierProvider.autoDispose<TabControllerNotifier, TabController>(
  TabControllerNotifier.new,
);

class TabControllerNotifier extends AutoDisposeNotifier<TabController> {
  @override
  TabController build() {
    final vsync = _SingleTickerProvider();

    final controller = TabController(length: 2, vsync: vsync, initialIndex: 0);

    controller.addListener(() {
      ref.notifyListeners();
    });

    ref.onDispose(() {
      controller.dispose();
      vsync.dispose();
    });

    return controller;
  }
}

class _SingleTickerProvider extends TickerProvider {
  Ticker? _ticker;

  @override
  Ticker createTicker(TickerCallback onTick) {
    _ticker = Ticker(onTick);
    return _ticker!;
  }

  void dispose() {
    _ticker?.dispose();
  }
}
