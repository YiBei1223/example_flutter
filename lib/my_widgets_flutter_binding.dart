// created by YiBei at 2022/3/9
// Copyright ©2022 zcy_app. All rights reserved.


import 'dart:collection';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

const double screenWidthDesign = 375;

/// 一个自定义的 WidgetsFlutterBinding 子类
class MyWidgetsFlutterBinding extends WidgetsFlutterBinding {
  final Queue<PointerEvent> _pendingPointerEvents = Queue<PointerEvent>();

  static MyWidgetsFlutterBinding ensureInitialized() {
    MyWidgetsFlutterBinding();
    return WidgetsBinding.instance as MyWidgetsFlutterBinding;
  }

  @override
  void scheduleAttachRootWidget(Widget rootWidget) {
    super.scheduleAttachRootWidget(rootWidget);
  }

  @override
  void initInstances() {
    super.initInstances();
    window.onPointerDataPacket = _handlePointerDataPacket;
  }

  @override
  ViewConfiguration createViewConfiguration() {
    return ViewConfiguration(
      size: Size(
          screenWidthDesign, window.physicalSize.height / (window.physicalSize.width / screenWidthDesign)),
      devicePixelRatio: window.physicalSize.width / screenWidthDesign,
    );
  }

  void _handlePointerDataPacket(PointerDataPacket packet) {
    // We convert pointer data to logical pixels so that e.g. the touch slop can be
    // defined in a device-independent manner.
    _pendingPointerEvents.addAll(PointerEventConverter.expand(
        packet.data, window.physicalSize.width / screenWidthDesign));
    if (!locked) _flushPointerEventQueue();
  }

  void _flushPointerEventQueue() {
    assert(!locked);

    while (_pendingPointerEvents.isNotEmpty) {
      handlePointerEvent(_pendingPointerEvents.removeFirst());
    }
  }
}
