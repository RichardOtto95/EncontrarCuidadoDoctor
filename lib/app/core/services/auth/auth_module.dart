// import 'package:encontrarCuidado/app/core/services/auth/auth_Page.dart';
import 'package:encontrar_cuidadodoctor/app/core/services/auth/auth_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AuthStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    // ChildRoute(Modular.initialRoute, child: (_, args) => AuthPage()),
  ];
}
