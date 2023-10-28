import 'package:encontrar_cuidadodoctor/app/modules/ratings/ratings_Page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/ratings/ratings_store.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RatingsModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => RatingsStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => RatingsPage()),
  ];

  @override
  Widget get view => RatingsPage();
}
