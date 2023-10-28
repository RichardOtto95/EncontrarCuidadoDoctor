import 'package:encontrar_cuidadodoctor/app/modules/drprofile/drprofile_store.dart';
import 'drprofile_page.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DrProfileModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => DrProfileStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => DrProfilePage()),
  ];

  @override
  Widget get view => DrProfilePage();
}
