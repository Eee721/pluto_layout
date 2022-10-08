// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../helper/pluto_resize_helper.dart';

class LeftSideTabView extends StatefulWidget {
  const LeftSideTabView({
    required this.controller,
    super.key,
  });

  final PlutoLayoutController controller;

  @override
  State<LeftSideTabView> createState() => _LeftSideTabViewState();
}

class _LeftSideTabViewState extends State<LeftSideTabView> {
  final resizeNotifier = ChangeNotifier();

  List<SideMenuItem> _enabledSideMenus = [];

  @override
  void initState() {
    super.initState();

    _enabledSideMenus =
        widget.controller.enabledLeftSideMenus.toList(growable: false);

    widget.controller.addListener(listener);
  }

  @override
  void dispose() {
    resizeNotifier.dispose();

    widget.controller.removeListener(listener);

    super.dispose();
  }

  void listener() {
    setState(() {
      _enabledSideMenus =
          widget.controller.enabledLeftSideMenus.toList(growable: false);
    });
  }

  void resize(Object id, Offset offset) {
    final resizing = PlutoResizeHelper.items<SideMenuItem>(
      offset: offset.dy,
      items: _enabledSideMenus,
      isMainItem: (e) => e.id == id,
      getItemSize: (e) => e.tabViewHeight ?? 200,
      getItemMinSize: (e) => 45,
      setItemSize: (e, size) => e.tabViewHeight = size,
      mode: PlutoResizeMode.pushAndPull,
    );

    resizing.update();

    resizeNotifier.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final tabViews = <LayoutId>[];
    final total = _enabledSideMenus.length;
    int count = 0;

    for (final item in _enabledSideMenus) {
      Widget child = widget.controller.getEnabledLeftSideTabView(context, item);

      if (count < total - 1) {
        child = ResizeIndicator(
          id: item.id,
          position: ResizeIndicatorPosition.bottom,
          onResize: resize,
          child: child,
        );
      }

      tabViews.add(LayoutId(id: item.id, child: child));

      ++count;
    }

    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.dialogBackgroundColor,
      child: CustomMultiChildLayout(
        delegate: _Delegate(
          _enabledSideMenus,
          resizeNotifier,
          widget.controller,
        ),
        children: tabViews,
      ),
    );
  }
}

class _Delegate extends MultiChildLayoutDelegate {
  _Delegate(this.menuItems, this.resizeNotifier, this.controller)
      : super(relayout: resizeNotifier);

  final List<SideMenuItem> menuItems;

  final ChangeNotifier resizeNotifier;

  final PlutoLayoutController controller;

  @override
  void performLayout(Size size) {
    controller.leftSideHeight = size.height;
    int length = menuItems.length;
    int count = 0;
    double remainingHeight = size.height;
    double defaultHeight = size.height / length;
    double y = 0;
    bool isLast(int i) => i + 1 == length;

    for (final item in menuItems) {
      item.tabViewHeight ??= defaultHeight;

      if (!hasChild(item.id)) continue;

      if (isLast(count)) item.tabViewHeight = remainingHeight;

      final s = layoutChild(
        item.id,
        BoxConstraints.tightFor(
          height: min(item.tabViewHeight!, remainingHeight),
          width: size.width,
        ),
      );

      positionChild(item.id, Offset(0, y));

      y += s.height;

      remainingHeight -= s.height;

      ++count;
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}
