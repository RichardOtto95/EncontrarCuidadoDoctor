import 'package:encontrar_cuidadodoctor/app/modules/secretaries/secretaries_Page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/secretaries/secretaries_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/secretaries/widgets/secretarie_profile.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SecretariesModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SecretariesStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SecretariesPage()),
    ChildRoute('/profile',
        child: (_, args) => SecretarieProfile(
              secretary: args.data,
            )),
  ];
}
