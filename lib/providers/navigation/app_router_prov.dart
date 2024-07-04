import 'package:indi_tool/models/navigation/indi_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router_prov.g.dart';

@Riverpod(keepAlive: true)
class SelectedRoute extends _$SelectedRoute {
  @override
  IndiRoute build() {
    return IndiRoute.workspace;
  }

  void select(IndiRoute route) {
    state = route;
  }
}
