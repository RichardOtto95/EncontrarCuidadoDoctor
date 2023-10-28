import 'package:encontrar_cuidadodoctor/app/modules/profile_edit/profileEdit_Page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile_edit/profileEdit_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfileEditModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ProfileEditStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => ProfileEditPage()),
  ];
}
