import 'package:pluto_layout/pluto_layout.dart';

import '../events/events.dart';

/// {@template pluto_layout_action_rotate_tab_view_intent}
/// Opens and closes all items in the tab view
/// corresponding to the [containerDirection] position in order.
/// {@endtemplate}
class PlutoLayoutActionRotateTabViewIntent extends PlutoLayoutIntent {
  const PlutoLayoutActionRotateTabViewIntent(
    this.containerDirection,
  );

  final PlutoLayoutContainerDirection containerDirection;
}

class PlutoLayoutActionRotateTabViewAction
    extends PlutoLayoutAction<PlutoLayoutActionRotateTabViewIntent> {
  PlutoLayoutActionRotateTabViewAction(super.events);

  @override
  void invoke(PlutoLayoutActionRotateTabViewIntent intent) {
    events.add(PlutoRotateTabViewEvent(
      intent.containerDirection,
    ));
  }
}