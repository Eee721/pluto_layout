import 'package:flutter/cupertino.dart';
import 'package:pluto_layout/pluto_layout.dart';

import '../events/events.dart';
import '../pluto_layout_event_stream_controller.dart';

/// [Intent] collection for performing specific actions
/// by registering keyboard shortcuts.
///
/// {@macro pluto_layout_shortcuts_example}
abstract class PlutoLayoutActions {
  /// {@macro pluto_layout_action_hide_all_tab_view_intent}
  static PlutoLayoutActionHideAllTabViewIntent hideAllTabView({
    bool afterFocusToBody = true,
  }) {
    return PlutoLayoutActionHideAllTabViewIntent(
      afterFocusToBody: afterFocusToBody,
    );
  }

  /// {@macro pluto_layout_action_toggle_tab_view_intent}
  static PlutoLayoutActionToggleTabViewIntent toggleTabView(
    PlutoLayoutId layoutId,
    Object itemId,
  ) {
    return PlutoLayoutActionToggleTabViewIntent(layoutId, itemId);
  }

  /// {@macro pluto_layout_action_rotate_tab_view_intent}
  static PlutoLayoutActionRotateTabViewIntent rotateTabView(
    PlutoLayoutId layoutId,
  ) {
    return PlutoLayoutActionRotateTabViewIntent(layoutId);
  }

  /// {@macro pluto_layout_action_increase_tab_view_intent}
  static PlutoLayoutActionIncreaseTabViewIntent increaseTabView({
    PlutoLayoutId? layoutId,
    double size = PlutoLayoutHasInDecreaseTabViewEvent.defaultSize,
    bool reverseByDirection = false,
  }) {
    assert(size > 0);

    return PlutoLayoutActionIncreaseTabViewIntent(
      layoutId,
      size: size,
      reverseByDirection: reverseByDirection,
    );
  }

  /// {@macro pluto_layout_action_decrease_tab_view_intent}
  static PlutoLayoutActionDecreaseTabViewIntent decreaseTabView({
    PlutoLayoutId? layoutId,
    double size = PlutoLayoutHasInDecreaseTabViewEvent.defaultSize,
    bool reverseByDirection = false,
  }) {
    assert(size > 0);

    return PlutoLayoutActionDecreaseTabViewIntent(
      layoutId,
      size: size,
      reverseByDirection: reverseByDirection,
    );
  }

  /// {@macro pluto_layout_action_remove_tab_item_intent}
  static PlutoLayoutActionRemoveTabItemIntent removeTabItem({
    PlutoLayoutId? layoutId,
    Object? itemId,
  }) {
    return PlutoLayoutActionRemoveTabItemIntent(layoutId, itemId);
  }

  static Map<Type, Action<Intent>> getActionsByShortcuts(
    Map<LogicalKeySet, PlutoLayoutIntent> shortcuts,
    PlutoLayoutEventStreamController layoutEvents,
  ) {
    final actions = <Type, Action<Intent>>{};

    for (final shortcut in shortcuts.entries) {
      switch (shortcut.value.runtimeType) {
        case PlutoLayoutActionHideAllTabViewIntent:
          actions[PlutoLayoutActionHideAllTabViewIntent] =
              PlutoLayoutActionHideAllTabViewAction(layoutEvents);
          break;
        case PlutoLayoutActionToggleTabViewIntent:
          actions[PlutoLayoutActionToggleTabViewIntent] =
              PlutoLayoutActionToggleTabViewAction(layoutEvents);
          break;
        case PlutoLayoutActionRotateTabViewIntent:
          actions[PlutoLayoutActionRotateTabViewIntent] =
              PlutoLayoutActionRotateTabViewAction(layoutEvents);
          break;
        case PlutoLayoutActionIncreaseTabViewIntent:
          actions[PlutoLayoutActionIncreaseTabViewIntent] =
              PlutoLayoutActionIncreaseTabViewAction(layoutEvents);
          break;
        case PlutoLayoutActionDecreaseTabViewIntent:
          actions[PlutoLayoutActionDecreaseTabViewIntent] =
              PlutoLayoutActionDecreaseTabViewAction(layoutEvents);
          break;
        case PlutoLayoutActionRemoveTabItemIntent:
          actions[PlutoLayoutActionRemoveTabItemIntent] =
              PlutoLayoutActionRemoveTabItemAction(layoutEvents);
          break;
      }
    }

    return actions;
  }
}

abstract class PlutoLayoutIntent extends Intent {
  const PlutoLayoutIntent();
}

abstract class PlutoLayoutAction<T extends PlutoLayoutIntent>
    extends Action<T> {
  PlutoLayoutAction(this.events);

  final PlutoLayoutEventStreamController events;
}
