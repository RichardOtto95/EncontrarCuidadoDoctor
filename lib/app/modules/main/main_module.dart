import 'package:encontrar_cuidadodoctor/app/modules/main/main_page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => MainStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => MainPage()),
  ];

  @override
  Widget get view => MainPage();
}
