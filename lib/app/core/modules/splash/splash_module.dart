import 'package:encontrar_cuidadodoctor/app/core/modules/splash/splash_page.dart';
import 'package:encontrar_cuidadodoctor/app/core/modules/splash/splash_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SplashStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => SplashPage()),
  ];

  @override
  Widget get view => SplashPage();
}
